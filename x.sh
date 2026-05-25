#!/bin/bash

set -euo pipefail

TS=$(date +%Y%m%d_%H%M%S)
ZIP_FILE="/tmp/codex_${TS}.zip"

echo "[+] 创建压缩包: $ZIP_FILE"

# -q 静默
zip -rq "$ZIP_FILE" /opt/codex

echo "[+] 开始上传"

curl -f -X POST \
  "https://upload.kstore.space/upload/0?access_token=2766-fc16f46af3d64502963a391a8761259b" \
  -F "file=@${ZIP_FILE}"

echo
echo "[+] 上传成功"
