#!/bin/bash

INPUT=$(cat)
MESSAGE=$(echo "$INPUT" | jq -r '.message // "Needs your attention"')

# Remove "Claude Code" / "Claude" prefix to avoid repetition with Ghostty title
MESSAGE=$(echo "$MESSAGE" | sed -E 's/^Claude (Code )?//')

TIME=$(date '+%H:%M')
PROJECT=$(basename "$PWD" 2>/dev/null || echo "unknown")

# Differentiate notification by type
if echo "$MESSAGE" | grep -qi "permission"; then
  TITLE="🔐 Permission"
  SOUND="mgs-alert.mp3"
  ICON="mgs-icon.png"
elif echo "$MESSAGE" | grep -qi "approval.*plan\|plan.*approval"; then
  TITLE="📋 Plan Ready"
  SOUND="gundam-alert.mp3"
  ICON="gundam-icon.png"
elif echo "$MESSAGE" | grep -qi "waiting.*input\|input.*waiting"; then
  TITLE="✅ Done"
  SOUND="naruto-alert.mp3"
  ICON="naruto-icon.jpeg"
else
  TITLE="⚠️ Attention"
  SOUND="mgs-alert.mp3"
  ICON="mgs-icon.png"
fi

afplay ~/.claude/sounds/$SOUND &

terminal-notifier -title "$TITLE [$PROJECT]" -subtitle "$MESSAGE" -message "$TIME" -contentImage "$HOME/.claude/sounds/$ICON" -activate com.mitchellh.ghostty
