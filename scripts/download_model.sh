#!/bin/bash

# モデルダウンロードスクリプト
# 使用法: ./download_model.sh model1 model2 model3 ...

# set -e を削除（エラーハンドリングは手動で行う）

# 色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ヘルプ表示
show_help() {
    echo "使用法: $0 <model1> [model2] [model3] ..."
    echo ""
    echo "例:"
    echo "  $0 codellama:7b-instruct"
    echo "  $0 codellama:7b-instruct llama2:7b mistral:7b"
    echo ""
    echo "オプション:"
    echo "  -h, --help    このヘルプを表示"
    echo ""
}

# 引数チェック
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

# Ollamaサーバーの確認
check_ollama_server() {
    echo -e "${BLUE}Ollamaサーバーの確認中...${NC}"
    if ! curl -s http://ollama:11434 > /dev/null 2>&1; then
        echo -e "${RED}エラー: Ollamaサーバーに接続できません (http://ollama:11434)${NC}"
        echo "Ollamaサーバーが起動していることを確認してください。"
        return 1
    fi
    echo -e "${GREEN}✓ Ollamaサーバーに接続しました${NC}"
    return 0
}

# モデルのpull実行
pull_model() {
    local model=$1
    local model_num=$2
    local total_models=$3
    
    echo -e "\n${YELLOW}[$model_num/$total_models] モデル '$model' をダウンロード中...${NC}"
    
    # 一時ファイルでステータスを管理
    local temp_status="/tmp/ollama_pull_$$_${model_num}"
    local success_found=false
    
    # Ollama API経由でモデルをpull（リアルタイム処理）
    curl -X POST http://ollama:11434/api/pull \
        -H "Content-Type: application/json" \
        -d "{\"name\":\"$model\"}" \
        --no-buffer 2>/dev/null | while IFS= read -r line; do
        
        # 空行をスキップ
        if [ -z "$line" ]; then
            continue
        fi
        
        # JSON解析してステータスとプログレス情報を取得
        if echo "$line" | jq -e . >/dev/null 2>&1; then
            local status=$(echo "$line" | jq -r '.status // empty')
            local completed=$(echo "$line" | jq -r '.completed // 0')
            local total=$(echo "$line" | jq -r '.total // 0')
            local digest=$(echo "$line" | jq -r '.digest // empty' | cut -c1-12)
            
            case "$status" in
                "pulling manifest")
                    echo -ne "\r${BLUE}  📄 マニフェスト取得中...                                                    ${NC}"
                    ;;
                pulling*)
                    # "pulling [digest]" の形式をキャッチ
                    if [ "$total" != "0" ] && [ "$total" != "null" ] && [ "$completed" != "0" ]; then
                        local percentage=$((completed * 100 / total))
                        local completed_mb=$((completed / 1024 / 1024))
                        local total_mb=$((total / 1024 / 1024))
                        
                        # ダウンロード進行状況をプログレスバー風に表示
                        local bar_width=30
                        local filled=$((percentage * bar_width / 100))
                        local bar=""
                        for ((j=0; j<filled; j++)); do bar+="█"; done
                        for ((j=filled; j<bar_width; j++)); do bar+="░"; done
                        
                        echo -ne "\r${BLUE}  📥 [$digest] ${bar} ${percentage}% (${completed_mb}/${total_mb}MB)           ${NC}"
                    elif [ "$total" != "0" ] && [ "$total" != "null" ]; then
                        local total_mb=$((total / 1024 / 1024))
                        echo -ne "\r${BLUE}  📥 [$digest] 準備中... (${total_mb}MB)                                      ${NC}"
                    else
                        echo -ne "\r${BLUE}  📥 ダウンロード中... [$digest]                                              ${NC}"
                    fi
                    ;;
                "verifying sha256 digest")
                    echo -ne "\r${BLUE}  🔍 SHA256検証中... [$digest]                                                ${NC}"
                    ;;
                "writing manifest")
                    echo -ne "\r${BLUE}  📝 マニフェスト書き込み中...                                                ${NC}"
                    ;;
                "removing any unused layers")
                    echo -ne "\r${BLUE}  🗑️  未使用レイヤー削除中...                                                ${NC}"
                    ;;
                "success")
                    echo -e "\r${GREEN}  ✅ '$model' のダウンロードが完了しました                                      ${NC}"
                    echo "success" > "$temp_status"
                    break
                    ;;
                *)
                    if [ -n "$status" ]; then
                        echo -ne "\r${BLUE}  ⏳ $status                                                                  ${NC}"
                    fi
                    ;;
            esac
        else
            # JSON以外の出力の場合
            echo -e "\r${BLUE}  $line                                                                           ${NC}"
        fi
    done
    
    # curlの終了ステータスを取得（パイプラインの場合）
    local curl_exit_code=${PIPESTATUS[0]}
    
    # 結果判定
    local success_found=false
    if [ -f "$temp_status" ] && [ "$(cat "$temp_status" 2>/dev/null)" = "success" ]; then
        success_found=true
    fi
    
    if [ $curl_exit_code -eq 0 ] && [ "$success_found" = true ]; then
        echo -e "\n${GREEN}✓ モデル '$model' が正常にダウンロードされました${NC}"
        rm -f "$temp_status" 2>/dev/null
        return 0
    else
        echo -e "\n${RED}✗ モデル '$model' のダウンロードに失敗しました (curl exit code: $curl_exit_code)${NC}"
        rm -f "$temp_status" 2>/dev/null
        return 1
    fi
}

# メイン処理
main() {
    local models=("$@")
    local total_models=${#models[@]}
    local successful=0
    local failed=0
    
    echo -e "${BLUE}=== Ollama モデルダウンローダー ===${NC}"
    echo -e "${BLUE}ダウンロード対象: ${total_models}個のモデル${NC}"
    
    # Ollamaサーバーチェック
    if ! check_ollama_server; then
        echo -e "${RED}Ollamaサーバーチェックに失敗しました${NC}"
        exit 1
    fi
    
    echo ""
    
    # 各モデルを順次ダウンロード
    for i in "${!models[@]}"; do
        local model="${models[$i]}"
        local model_num=$((i + 1))
        
        if pull_model "$model" "$model_num" "$total_models"; then
            ((successful++))
        else
            ((failed++))
        fi
    done
    
    # 結果サマリー
    echo -e "\n${BLUE}=== ダウンロード完了 ===${NC}"
    echo -e "${GREEN}成功: ${successful}個${NC}"
    if [ $failed -gt 0 ]; then
        echo -e "${RED}失敗: ${failed}個${NC}"
        exit 1
    else
        echo -e "${GREEN}すべてのモデルが正常にダウンロードされました！${NC}"
    fi
}

# スクリプト実行
main "$@"
