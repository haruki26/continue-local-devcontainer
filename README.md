# Continue Local Dev Container

Continue.dev のローカル開発環境を Dev Container で構築するプロジェクトです。Ollama と React + TypeScript + Vite を組み合わせて、ローカル LLM を使った開発環境を提供します。

## 🚀 特徴

- **Dev Container**: 完全に隔離された開発環境
- **Ollama 統合**: ローカル LLM モデルの自動ダウンロードとセットアップ
- **Continue.dev**: VS Code 拡張機能による AI アシスタント
- **React + TypeScript + Vite**: モダンなフロントエンド開発環境
- **Tailwind CSS**: ユーティリティファーストの CSS フレームワーク

## 📋 前提条件

- Docker
- Docker Compose
- Visual Studio Code
- Dev Containers 拡張機能

## 🛠️ セットアップ

### 1. リポジトリのクローン

```bash
git clone https://github.com/haruki26/continue-local-devcontainer.git
cd continue-local-devcontainer
```

### 2. Dev Container で開く

VS Code でプロジェクトを開き、以下のいずれかの方法で Dev Container を起動：

- コマンドパレット（Ctrl+Shift+P）から `Dev Containers: Reopen in Container`
- 右下に表示される通知から「Reopen in Container」をクリック

### 3. モデルのダウンロード

Dev Container 内で以下のコマンドを実行して Ollama モデルをダウンロード：

```bash
make setup
```

これにより以下のモデルが自動的にダウンロードされます：

- `qwen2.5-coder:7b-instruct-q4_K_M` - コード生成用 7B モデル
- `qwen2.5-coder:1.5b` - 軽量コード生成モデル
- `nomic-embed-text` - テキスト埋め込み用モデル

### 4. 開発サーバーの起動

```bash
npm run dev
```

ブラウザで `http://localhost:5173` にアクセスして開発環境を確認できます。

## 📁 プロジェクト構成

```
├── .devcontainer/          # Dev Container設定
├── scripts/                # ユーティリティスクリプト
├── src/                    # Reactアプリケーションソース
├── public/                 # 静的ファイル
├── Makefile               # タスク管理
├── package.json           # Node.js依存関係
├── vite.config.ts         # Vite設定
└── tsconfig.json          # TypeScript設定
```

## 🔧 利用可能なコマンド

### 開発コマンド

```bash
# 開発サーバー起動
npm run dev

# プロダクションビルド
npm run build

# ESLintによるコード検証
npm run lint

# プレビューサーバー起動
npm run preview
```

### セットアップコマンド

```bash
# Ollamaモデルの一括ダウンロード
make setup
```

## 🤖 Continue.dev の使用方法

1. **自動設定**: Dev Container 起動時に Continue.dev 拡張機能が自動インストール
2. **設定ファイル**: `.continue/config.yaml`で Ollama モデルが自動設定
3. **チャット**: VS Code のサイドバーから Continue アイコンをクリックしてチャット開始
4. **コード生成**: エディタ内で`Ctrl+I`でインラインコード生成

## 📚 技術スタック

- **Runtime**: Node.js 22
- **Frontend**: React 19.1.0, TypeScript 5.8.3
- **Build Tool**: Vite 7.0.4
- **Styling**: Tailwind CSS 4.1.11
- **Linting**: ESLint 9.30.1
- **AI Models**: Ollama (Qwen2.5-Coder, Nomic-Embed)
- **Container**: Docker + Dev Containers

## 🔍 トラブルシューティング

### Ollama サーバーに接続できない

```bash
# Ollamaサービスの状態確認
curl http://ollama:11434

# Ollamaサービス再起動
docker-compose restart ollama
```

### Continue.dev でモデルが認識されない

1. `.continue/config.yaml`の設定を確認
2. VS Code を再起動
3. Continue 拡張機能を再読み込み

### ポートフォワーディングの問題

Dev Container のポートタブで Port 5173 が正しくフォワードされているか確認してください。

## 🤝 貢献

プルリクエストやイシューの報告を歓迎します。開発環境のセットアップや新機能の提案など、お気軽にご連絡ください。
