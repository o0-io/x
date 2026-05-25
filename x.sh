#!/usr/bin/env bash
set -euo pipefail

# export_codex_cloud_files.sh
# 用途：打包 Codex Cloud 当前工作区的项目文件
# 默认排除敏感文件、依赖目录、缓存和构建产物

OUT_DIR="${OUT_DIR:-/tmp/codex-export}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
ARCHIVE_NAME="${ARCHIVE_NAME:-codex_workspace_${TIMESTAMP}.tar.gz}"
MANIFEST_NAME="${MANIFEST_NAME:-codex_workspace_${TIMESTAMP}_manifest.txt}"

# 默认导出当前目录
ROOT="${1:-$(pwd)}"

mkdir -p "$OUT_DIR"

ARCHIVE_PATH="$OUT_DIR/$ARCHIVE_NAME"
MANIFEST_PATH="$OUT_DIR/$MANIFEST_NAME"

echo "Workspace root: $ROOT"
echo "Output archive: $ARCHIVE_PATH"
echo "Manifest: $MANIFEST_PATH"

cd "$ROOT"

# 生成文件清单：排除常见敏感/无用内容
find . \
  -path './.git' -prune -o \
  -path './node_modules' -prune -o \
  -path './vendor' -prune -o \
  -path './.venv' -prune -o \
  -path './venv' -prune -o \
  -path './__pycache__' -prune -o \
  -path './.cache' -prune -o \
  -path './dist' -prune -o \
  -path './build' -prune -o \
  -path './target' -prune -o \
  -path './.next' -prune -o \
  -path './coverage' -prune -o \
  -path './.turbo' -prune -o \
  -path './.pytest_cache' -prune -o \
  -path './.mypy_cache' -prune -o \
  -name '.env' -prune -o \
  -name '.env.*' -prune -o \
  -name '*secret*' -prune -o \
  -name '*token*' -prune -o \
  -name '*key*' -prune -o \
  -name '*.pem' -prune -o \
  -name '*.key' -prune -o \
  -name 'id_rsa' -prune -o \
  -name 'id_ed25519' -prune -o \
  -type f -print | sort > "$MANIFEST_PATH"

# 根据清单打包
tar -czf "$ARCHIVE_PATH" -T "$MANIFEST_PATH"

echo
echo "Done."
echo "Archive:"
ls -lh "$ARCHIVE_PATH"

echo
echo "Manifest:"
ls -lh "$MANIFEST_PATH"

echo
echo "File count:"
wc -l "$MANIFEST_PATH"
