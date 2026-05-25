#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="/opt/codex"
UPLOAD_URL="https://upload.kstore.space/upload/0?access_token=2766-fc16f46af3d64502963a391a8761259b"

ZIP_FILE="/tmp/co_backup.tar.gz"

cd "$SRC_DIR"

tar -czf "$ZIP_FILE" \
  --exclude='./bin' \
  --exclude='./bin/*' \
  --exclude='./mcp' \
  --exclude='./mcp/*' \
  --exclude='./.tmp' \
  --exclude='./.tmp/*' \
  .

echo "压缩完成: $ZIP_FILE"

curl -f -X POST "$UPLOAD_URL" \
  -F "file=@${ZIP_FILE}"

echo
echo "上传完成"

rm -f "$ZIP_FILE"
