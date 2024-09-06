#!/bin/bash

# GitHubリポジトリのURL
REPO_URL="https://github.com/cieloarto/operation-client"
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
  tar -xzf "$INSTALL_DIR/$LATEST_VERSION.tar.gz" -C "$INSTALL_DIR"

  # スクリプトの置き換え
  cp -r "$INSTALL_DIR/yourrepo-$LATEST_VERSION/"* "$INSTALL_DIR/"

  # バージョンファイルの更新
  echo "$LATEST_VERSION" >"$VERSION_FILE"

  # サービスの再起動
  systemctl restart "$SERVICE_NAME"

  echo "Update completed."
else
  echo "No updates available."
fi
