#!/bin/bash

# GitHubリポジトリのURL
REPO_URL="https://github.com/cieloarto/operation-client"
SERVICE_NAME="radish"
INSTALL_DIR="/usr/local/$SERVICE_NAME" # 必要に応じて設定
VERSION_FILE="$INSTALL_DIR/version"

# 現在のバージョンを読み込む
if [ -f "$VERSION_FILE" ]; then
  CURRENT_VERSION=$(cat "$VERSION_FILE")
else
  CURRENT_VERSION="v0.0.0" # 初回インストール時のデフォルトバージョン
fi

# 最新バージョンを取得
LATEST_VERSION=$(curl -s "https://api.github.com/repos/cieloarto/operation-client/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ "$LATEST_VERSION" != "$CURRENT_VERSION" ]; then
  echo "New version available: $LATEST_VERSION. Updating..."

  # 最新バージョンをダウンロードして解凍
  curl -L "$REPO_URL/archive/$LATEST_VERSION.tar.gz" -o "$INSTALL_DIR/$LATEST_VERSION.tar.gz"

  # エラーチェック
  if [ $? -ne 0 ]; then
    echo "Error: Failed to download the latest version."
    exit 1
  fi

  # ファイルを解凍
  tar -xzf "$INSTALL_DIR/$LATEST_VERSION.tar.gz" -C "$INSTALL_DIR"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to extract the latest version."
    exit 1
  fi

  # スクリプトの置き換え（必要なファイルのみをコピー）
  cp -r "$INSTALL_DIR/operation-client-$LATEST_VERSION/"* "$INSTALL_DIR/"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to copy new files."
    exit 1
  fi

  # バージョンファイルの更新
  echo "$LATEST_VERSION" >"$VERSION_FILE"

  # サービスの再起動
  sudo systemctl restart "$SERVICE_NAME"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to restart the service."
    exit 1
  fi

  echo "Update completed to version $LATEST_VERSION."
else
  echo "No updates available. Current version: $CURRENT_VERSION."
fi
