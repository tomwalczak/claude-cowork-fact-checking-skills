#!/bin/bash
#
# Install draft-review skills into a Cowork workspace.
#
# Usage:
#   cd /path/to/your/workspace
#   /path/to/install.sh
#
# Or as a one-liner after cloning:
#   git clone https://github.com/tomwalczak/claude-cowork-fact-checking-skills.git /tmp/draft-review-skills && /tmp/draft-review-skills/install.sh && rm -rf /tmp/draft-review-skills

set -e

# Where Cowork looks for skills
SKILLS_DIR=".skills/skills"

# The repo's skills payload (relative to this script)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/skills"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Could not find skills directory at $SOURCE_DIR"
  exit 1
fi

# Create the target directory if it doesn't exist
mkdir -p "$SKILLS_DIR"

# Copy each skill
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
