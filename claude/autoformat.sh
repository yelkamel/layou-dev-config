#!/bin/bash

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Skip if no file path
[ -z "$FILE_PATH" ] && exit 0
[ ! -f "$FILE_PATH" ] && exit 0

# Get file extension
EXT="${FILE_PATH##*.}"

case "$EXT" in
  js|jsx|ts|tsx|css|scss|json|md|html|vue|svelte)
    if command -v prettier &>/dev/null; then
      prettier --write --silent "$FILE_PATH" 2>/dev/null
    elif command -v npx &>/dev/null; then
      npx prettier --write --silent "$FILE_PATH" 2>/dev/null
    fi
    ;;
  py)
    if command -v black &>/dev/null; then
      black --quiet "$FILE_PATH" 2>/dev/null
    elif command -v ruff &>/dev/null; then
      ruff format --quiet "$FILE_PATH" 2>/dev/null
    fi
    ;;
  swift)
    if command -v swiftformat &>/dev/null; then
      swiftformat --quiet "$FILE_PATH" 2>/dev/null
    fi
    ;;
  go)
    if command -v gofmt &>/dev/null; then
      gofmt -w "$FILE_PATH" 2>/dev/null
    fi
    ;;
esac

exit 0
