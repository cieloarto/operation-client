#!/bin/bash

# GitHubから必要なファイルをダウンロード
REPO_URL="https://raw.githubusercontent.com/cieloarto/operation-client/main"
INSTALL_DIR="/usr/local/myservice"
SERVICE_NAME="radish"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

# インストールディレクトリの作成
sudo mkdir -p "$INSTALL_DIR"

# 必要なファイルをダウンロード
sudo curl -L "$REPO_URL/service.sh" -o "$INSTALL_DIR/service.sh"
sudo curl -L "$REPO_URL/config.sh" -o "$INSTALL_DIR/config.sh"
sudo curl -L "$REPO_URL/update.sh" -o "$INSTALL_DIR/update.sh"

# 設定ファイルの読み込み
source "$INSTALL_DIR/config.sh"

# サービスファイルの作成
sudo bash -c "cat <<EOL > $SERVICE_FILE
[Unit]
Description=Radish Operation Client

[Service]
ExecStart=$INSTALL_DIR/service.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOL"

# サービスの有効化と起動
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl start "$SERVICE_NAME"

echo "Installation completed. Service is running as $SERVICE_NAME."
