#!/bin/bash

# GitHubから必要なファイルをダウンロード
REPO_URL="https://raw.githubusercontent.com/cieloarto/operation-client/main"
SERVICE_NAME="radish"
INSTALL_DIR="/usr/local/$SERVICE_NAME"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

# インストールディレクトリの作成
sudo mkdir -p "$INSTALL_DIR"

# 必要なファイルをダウンロード
sudo curl -L "$REPO_URL/service.sh" -o "$INSTALL_DIR/service.sh"
sudo curl -L "$REPO_URL/config.sh" -o "$INSTALL_DIR/config.sh"
sudo curl -L "$REPO_URL/update.sh" -o "$INSTALL_DIR/update.sh"

# 実行権限を付与
sudo chmod +x "$INSTALL_DIR/service.sh"
sudo chmod +x "$INSTALL_DIR/update.sh"

# 設定ファイルの読み込み
source "$INSTALL_DIR/config.sh"

# メインサービスファイルの作成
# SERVICE_FILE="/etc/systemd/system/radish.service"
sudo bash -c "cat <<EOL > $SERVICE_FILE
[Unit]
Description=Radish Operation Client

[Service]
ExecStart=$INSTALL_DIR/service.sh
Restart=always
EOL"

# メインタイマーファイルの作成
TIMER_FILE="/etc/systemd/system/radish.timer"
sudo bash -c "cat <<EOL > $TIMER_FILE
[Unit]
Description=Runs Radish Service every minute

[Timer]
OnCalendar=*:0/1
Persistent=true

[Install]
WantedBy=timers.target
EOL"

# アップデータサービスとタイマーの作成
UPDATE_SERVICE_FILE="/etc/systemd/system/radish-updater.service"
sudo bash -c "cat <<EOL > $UPDATE_SERVICE_FILE
[Unit]
Description=Radish Updater Service
Wants=radish-updater.timer

[Service]
Type=simple
ExecStart=$INSTALL_DIR/update.sh
EOL"

UPDATE_TIMER_FILE="/etc/systemd/system/radish-updater.timer"
sudo bash -c "cat <<EOL > $UPDATE_TIMER_FILE
[Unit]
Description=Runs Radish Updater every day

[Timer]
OnCalendar=hourly
Persistent=true

[Install]
WantedBy=timers.target
EOL"

# サービスの有効化と起動
# sudo systemctl daemon-reload
# sudo systemctl enable "$SERVICE_NAME"
sudo systemctl start "$SERVICE_NAME"
sudo systemctl enable "$SERVICE_NAME.timer"
sudo systemctl start "$SERVICE_NAME.timer"

# アップデータタイマーの有効化と起動
sudo systemctl enable radish-updater.timer
sudo systemctl start radish-updater.timer

echo "Installation completed. Service is running as $SERVICE_NAME."
