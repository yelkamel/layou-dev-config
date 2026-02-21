#!/bin/bash

INPUT=$(cat)
MESSAGE=$(echo "$INPUT" | jq -r '.message // "Needs your attention"')

# Remove "Claude Code" / "Claude" prefix to avoid repetition with Ghostty title
MESSAGE=$(echo "$MESSAGE" | sed -E 's/^Claude (Code )?//')

printf '\e]9;%s\a' "$MESSAGE"
