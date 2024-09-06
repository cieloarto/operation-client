#!/bin/bash

# サービス名とインストールディレクトリを手動で設定
SERVICE_NAME="radish"
INSTALL_DIR="/usr/local/$SERVICE_NAME"

# 設定ファイルの確認と読み込み
if [ -f "$INSTALL_DIR/config.sh" ]; then
  source "$INSTALL_DIR/config.sh"
else
  echo "Config file not found, proceeding with default service name and directory."
fi

SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"
TIMER_FILE="/etc/systemd/system/$SERVICE_NAME.timer"
UPDATE_SERVICE_FILE="/etc/systemd/system/radish-updater.service"
UPDATE_TIMER_FILE="/etc/systemd/system/radish-updater.timer"

# サービスの停止と無効化
echo "Stopping and disabling the service..."
sudo systemctl stop "$SERVICE_NAME"
sudo systemctl disable "$SERVICE_NAME"

sudo systemctl stop "$SERVICE_NAME.timer"
sudo systemctl disable "$SERVICE_NAME.timer"

sudo systemctl stop radish-updater.timer
sudo systemctl disable radish-updater.timer

# サービスファイルの削除
echo "Removing service and timer files..."
sudo rm -f "$SERVICE_FILE" "$TIMER_FILE"
sudo rm -f "$UPDATE_SERVICE_FILE" "$UPDATE_TIMER_FILE"

# インストールディレクトリの削除
echo "Removing installed files..."
sudo rm -rf "$INSTALL_DIR"

# systemdデーモンのリロード
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Uninstallation completed. $SERVICE_NAME has been removed."
