setup:
	@echo "セットアップを開始します..."
	@bash ./scripts/download_model.sh \
		gpt-oss:20b \
		qwen2.5-coder:1.5b \
		nomic-embed-text
	@echo "セットアップが完了しました"


add-model:
	@echo "モデルの追加を開始します..."
	@bash ./scripts/download_model.sh $(word 2,$(MAKECMDGOALS))
	@echo "モデルの追加が完了しました"
