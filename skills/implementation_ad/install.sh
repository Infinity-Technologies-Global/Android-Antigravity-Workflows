#!/bin/bash
# Antigravity Skill Installer for implementation_ad

SKILL_NAME="implementation_ad"
SKILL_DIR="$HOME/.gemini/antigravity/skills/$SKILL_NAME"

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║   🚀 Antigravity Skill Installer: $SKILL_NAME         ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

mkdir -p "$SKILL_DIR"
echo "✅ Skill Path: $SKILL_DIR"

echo "⏳ Installing skill files..."

# Check if running from within the skill directory
if [ -f "SKILL.md" ]; then
    cp -R . "$SKILL_DIR"
    echo "✅ Copied files to $SKILL_DIR"
else
    echo "❌ Error: Please run this script from the '$SKILL_NAME' root directory."
    exit 1
fi

echo ""
echo "🎉 Skill '$SKILL_NAME' has been installed globally."
echo ""
