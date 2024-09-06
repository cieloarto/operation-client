#!/bin/bash

# GitHubから必要なファイルをダウンロード
REPO_URL="https://raw.githubusercontent.com/cieloarto/operation-client/main"
INSTALL_DIR="/usr/local/radish"
SERVICE_FILE="/etc/systemd/system/radish.service"

# インストールディレクトリの作成
mkdir -p "$INSTALL_DIR"

# 必要なファイルをダウンロード
curl -L "$REPO_URL/service.sh" -o "$INSTALL_DIR/service.sh"
curl -L "$REPO_URL/config.sh" -o "$INSTALL_DIR/config.sh"
curl -L "$REPO_URL/update.sh" -o "$INSTALL_DIR/update.sh"

# 設定ファイルの読み込み
source "$INSTALL_DIR/config.sh"

# サービスファイルの作成
cat <<EOL >"$SERVICE_FILE"
[Unit]
Description=Radish

[Service]
ExecStart=$INSTALL_DIR/service.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# サービスの有効化と起動
systemctl daemon-reload
systemctl enable "$SERVICE_NAME"
systemctl start "$SERVICE_NAME"

echo "Installation completed. Service is running as $SERVICE_NAME."
