#!/bin/bash

INPUT=$(cat)
MESSAGE=$(echo "$INPUT" | jq -r '.message // "Needs your attention"')

# Remove "Claude Code" / "Claude" prefix to avoid repetition with Ghostty title
MESSAGE=$(echo "$MESSAGE" | sed -E 's/^Claude (Code )?//')

TIME=$(date '+%H:%M')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')
GIT_ROOT=$(cd "$CWD" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null)
if [ -n "$GIT_ROOT" ] && [ "$CWD" != "$GIT_ROOT" ]; then
  # Monorepo: show repo/subdir (e.g. X/ios)
  REPO=$(basename "$GIT_ROOT")
  SUBDIR=$(echo "$CWD" | sed "s|$GIT_ROOT/||")
  PROJECT="$REPO/$SUBDIR"
elif [ -n "$CWD" ]; then
  PROJECT=$(basename "$CWD")
else
  PROJECT="Claude Code"
fi

# Differentiate notification by type
if echo "$MESSAGE" | grep -qi "permission"; then
  TITLE="🔐 claude [$PROJECT]"
  SOUND="soubhanallah-alert.mp3"
  # ICON="mgs-icon.png"
elif echo "$MESSAGE" | grep -qi "approval.*plan\|plan.*approval"; then
  TITLE="📋 claude [$PROJECT]"
  SOUND="bismillah-alert.mp3"
  # ICON="gundam-icon.png"
elif echo "$MESSAGE" | grep -qi "waiting.*input\|input.*waiting"; then
  TITLE="✅ claude [$PROJECT]"
  SOUND="alhamdulillah-alert.mp3"
  # ICON="naruto-icon.jpeg"
else
  TITLE="⚠️ claude [$PROJECT]"
  SOUND="allahouakbar-alert.mp3"
  # ICON="mgs-icon.png"
fi

afplay ~/.claude/sounds/$SOUND &

GROUP_ID="claude-$PPID"
# Pour ajouter une image: -contentImage "$HOME/.claude/sounds/$ICON"
terminal-notifier -title "$TITLE" -subtitle "$MESSAGE" -message "$TIME" -activate com.mitchellh.ghostty -group "$GROUP_ID"
