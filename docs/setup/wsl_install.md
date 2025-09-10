# WSL 2 のインストール

このドキュメントでは、Windows Subsystem for Linux (WSL) 2, Ubuntu LTS のインストール手順を説明します。

## 公式

- http://learn.microsoft.com/ja-jp/windows/wsl/install

## 前提条件

いずれかを満たしている必要があろます

- Windows 10 バージョン 2004 以降 (ビルド 19041 以降)
- Windows 11

## インストール手順

1. PowerShell を管理者として実行

```powershell
PS > wsl --install
```

- 上記コマンドを実行し、再起動

2. ディストリビューションのインストール

```powershell
# インストール可能ディストリビューションの確認
PS > wsl --list --online

# インストール（Ubuntu LTS）
PS > wsl --install -d Ubuntu
```

3. インストールしたディストリビューションをメニューから起動

- 起動するとユーザ名とパスワードを聞かれるので設定

4. パッケージの更新

- 起動したディストリビューション内で以下コマンドを実行

```bash
sudo apt update
sudo apt upgrade -y
```
