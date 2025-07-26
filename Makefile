setup:
	@echo "セットアップを開始します..."
	@bash ./scripts/download_model.sh \
		qwen2.5-coder:7b-instruct-q4_K_M \
		qwen2.5-coder:1.5b \
		nomic-embed-text
	@echo "セットアップが完了しました"
