#!/bin/bash

# 設定ファイルの読み込み
SERVICE_NAME="radish"
INSTALL_DIR="/usr/local/$SERVICE_NAME"

source "$INSTALL_DIR/config.sh"

SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

# サービスの停止と無効化
echo "Stopping and disabling the service..."
sudo systemctl stop "$SERVICE_NAME"
sudo systemctl disable "$SERVICE_NAME"

# サービスファイルの削除
echo "Removing service file..."
rm -f "$SERVICE_FILE"

# インストールディレクトリの削除
echo "Removing installed files..."
rm -rf "$INSTALL_DIR"

# systemdデーモンのリロード
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Uninstallation completed. $SERVICE_NAME has been removed."
