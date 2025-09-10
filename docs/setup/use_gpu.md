# GPU を使用する

このドキュメントでは、wsl2 + Docker 環境で GPU を使用する方法について説明します。

想定プラットフォームは Windows 11 + wsl2 + Ubuntu 24.04 です。

## 公式

- https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

## 前提条件

以下の点を確認してください。

- nvivdia GPU 搭載マシンであること
- Windows に [nvidia ドライバ](https://www.nvidia.com/ja-jp/drivers/)がインストールされていること

## セットアップ手順

1. WSL2 に NVIDIA Container Toolkit をインストール

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt update && sudo apt upgrade -y
sudo apt install -y nvidia-container-toolkit
```

2. コンテナランタイムの設定

```bash
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

- 動作確認

```bash
docker run --rm --gpus all nvidia/cuda:12.4.1-base-ubuntu22.04 nvidia-smi
```

- ホストマシンの GPU 情報が表示されれば成功

3. Docker Compose ファイルの修正

- [docker-compose.yml](./../../.devcontainer/docker-compose.yml) の 28 ~ 34 行目のコメントアウトを解除

```yaml
# Use gpu if available
# Uncomment the following lines to enable GPU support
deploy:
  resources:
    reservations:
      devices:
        - driver: nvidia
          count: all
          capabilities: [gpu]
```
