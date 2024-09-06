#!/bin/bash

# 設定ファイルの読み込み
source "$(dirname "$0")/config.sh"

# 自動アップデートチェック
"$INSTALL_DIR/update.sh"

# メイン処理
while true; do
  # 実際の処理をここに記述
  echo "Running main service..."

  # 実行間隔
  sleep "$INTERVAL"
done
