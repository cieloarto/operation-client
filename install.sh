#!/bin/bash

# 設定ファイルの読み込み
source "./config.sh"

SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

# インストールディレクトリの作成
mkdir -p "$INSTALL_DIR"

# スクリプトのコピー
cp service.sh "$INSTALL_DIR/service.sh"
cp config.sh "$INSTALL_DIR/config.sh"
cp update.sh "$INSTALL_DIR/update.sh"

# サービスファイルの作成
cat <<EOL >"$SERVICE_FILE"
[Unit]
Description=MyService

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
