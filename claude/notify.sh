#!/bin/bash

INPUT=$(cat)
MESSAGE=$(echo "$INPUT" | jq -r '.message // "Needs your attention"')

# Remove "Claude Code" / "Claude" prefix to avoid repetition with Ghostty title
MESSAGE=$(echo "$MESSAGE" | sed -E 's/^Claude (Code )?//')

# MGS1 alert notification
afplay ~/.claude/sounds/mgs-alert.mp3 &
TIME=$(date '+%H:%M')
terminal-notifier -title "Claude Code" -subtitle "$MESSAGE" -message "$TIME"
