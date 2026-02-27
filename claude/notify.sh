#!/bin/bash

INPUT=$(cat)
MESSAGE=$(echo "$INPUT" | jq -r '.message // "Needs your attention"')

# Remove "Claude Code" / "Claude" prefix to avoid repetition with Ghostty title
MESSAGE=$(echo "$MESSAGE" | sed -E 's/^Claude (Code )?//')

TIME=$(date '+%H:%M')
PROJECT=$(echo "$INPUT" | jq -r '.cwd // empty' | xargs basename 2>/dev/null)
[ -z "$PROJECT" ] && PROJECT=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || echo "Claude Code")

# Differentiate notification by type
if echo "$MESSAGE" | grep -qi "permission"; then
  SOUND="mgs-alert.mp3"
  ICON="mgs-icon.png"
elif echo "$MESSAGE" | grep -qi "approval.*plan\|plan.*approval"; then
  SOUND="gundam-alert.mp3"
  ICON="gundam-icon.png"
elif echo "$MESSAGE" | grep -qi "waiting.*input\|input.*waiting"; then
  SOUND="naruto-alert.mp3"
  ICON="naruto-icon.jpeg"
else
  SOUND="mgs-alert.mp3"
  ICON="mgs-icon.png"
fi

afplay ~/.claude/sounds/$SOUND &

GROUP_ID="claude-$PPID"
terminal-notifier -title "Claude [$PROJECT]" -subtitle "$MESSAGE" -message "$TIME" -contentImage "$HOME/.claude/sounds/$ICON" -activate com.mitchellh.ghostty -group "$GROUP_ID"
