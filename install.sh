#!/bin/bash
#
# Install draft-review skills into the current directory for Claude Cowork.
#
# Usage:
#   cd /path/to/your/workspace
#   bash <(curl -s https://raw.githubusercontent.com/tomwalczak/claude-cowork-fact-checking-skills/main/install.sh)

set -e

REPO="https://github.com/tomwalczak/claude-cowork-fact-checking-skills.git"
SKILLS_DIR=".skills/skills"
TMP_DIR=$(mktemp -d)

trap "rm -rf $TMP_DIR" EXIT

# If running from inside the repo already, use local files; otherwise clone
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -d "$SCRIPT_DIR/skills" ]; then
  SOURCE_DIR="$SCRIPT_DIR/skills"
else
  echo "Cloning repo..."
  git clone --quiet "$REPO" "$TMP_DIR/repo"
  SOURCE_DIR="$TMP_DIR/repo/skills"
fi

mkdir -p "$SKILLS_DIR"

for skill in "$SOURCE_DIR"/*/; do
  skill_name=$(basename "$skill")
  echo "Installing $skill_name..."
  cp -r "$skill" "$SKILLS_DIR/$skill_name"
done

echo ""
echo "Done. Installed skills:"
ls -1 "$SKILLS_DIR"
echo ""
echo "Open Cowork and select this folder as your workspace."
echo "Then ask Claude to \"review my draft\" and it will handle the rest."
