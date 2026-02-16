#!/bin/bash
# Next Prayer Time - Paris (aladhan.com API, cached daily)
# Emoji urgency: 🟢 chill | 🟡 approaching | 🔴 soon | ✅ NOW

CACHE_DIR="$HOME/Tech/layou-dev-config/cache"
TODAY=$(date +%Y-%m-%d)
CACHE_FILE="$CACHE_DIR/prayers-$TODAY.json"

mkdir -p "$CACHE_DIR"

# Fetch once per day
if [ ! -f "$CACHE_FILE" ]; then
  curl -sfL --max-time 10 "https://api.aladhan.com/v1/timings?latitude=48.8566&longitude=2.3522&method=12" \
    | jq '.data.timings | {Fajr, Dhuhr, Asr, Maghrib, Isha}' > "$CACHE_FILE" 2>/dev/null
  find "$CACHE_DIR" -name "prayers-*.json" ! -name "prayers-$TODAY.json" -delete 2>/dev/null
fi

if [ ! -s "$CACHE_FILE" ]; then
  echo "🕌 --"
  exit 0
fi

NOW_H=$(date +%H)
NOW_M=$(date +%M)
NOW_MINS=$(( 10#$NOW_H * 60 + 10#$NOW_M ))

# Read prayers into arrays
NAMES=()
TIMES=()
while IFS='|' read -r name time; do
  NAMES+=("$name")
  h=$(echo "$time" | cut -d: -f1)
  m=$(echo "$time" | cut -d: -f2)
  TIMES+=( $(( 10#$h * 60 + 10#$m )) )
done < <(jq -r 'to_entries | sort_by(.value) | .[] | "\(.key)|\(.value)"' "$CACHE_FILE")

# Find next prayer
NEXT_NAME=""
REMAINING=0
for i in "${!NAMES[@]}"; do
  diff=$(( TIMES[i] - NOW_MINS ))
  if [ $diff -gt 0 ]; then
    NEXT_NAME="${NAMES[$i]}"
    REMAINING=$diff
    break
  fi
done

# All prayers passed = Fajr tomorrow
if [ -z "$NEXT_NAME" ]; then
  NEXT_NAME="Fajr"
  REMAINING=$(( TIMES[0] + 1440 - NOW_MINS ))
fi

# Format remaining time
if [ $REMAINING -ge 60 ]; then
  TIME_STR="$(( REMAINING / 60 ))h$(printf '%02d' $(( REMAINING % 60 )))"
else
  TIME_STR="${REMAINING}m"
fi

# Emoji based on urgency
if [ $REMAINING -le 0 ]; then
  ICON="✅"
  TIME_STR="NOW"
elif [ $REMAINING -le 15 ]; then
  ICON="🔴"
elif [ $REMAINING -le 45 ]; then
  ICON="🟡"
else
  ICON="🟢"
fi

echo "${ICON} ${NEXT_NAME} ${TIME_STR}"
