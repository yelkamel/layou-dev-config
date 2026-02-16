#!/bin/bash
INPUT=$(cat)
BRANCH=$(git branch --show-current 2>/dev/null || echo "-")
DIRTY=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
PRAYER=$("$HOME/Tech/layou-dev-config/next-prayer.sh" 2>/dev/null || echo "🕌 --")

# Time of day emoji
HOUR=$(date +%H)
if   [ "$HOUR" -ge 5  ] && [ "$HOUR" -lt 7  ]; then TOD="🌅"
elif [ "$HOUR" -ge 7  ] && [ "$HOUR" -lt 12 ]; then TOD="☀️"
elif [ "$HOUR" -ge 12 ] && [ "$HOUR" -lt 17 ]; then TOD="🌤️"
elif [ "$HOUR" -ge 17 ] && [ "$HOUR" -lt 21 ]; then TOD="🌆"
else TOD="🌙"
fi

echo "$INPUT" | jq -r --arg branch "$BRANCH" --arg dirty "$DIRTY" --arg prayer "$PRAYER" --arg tod "$TOD" '
  def bar(pct):
    ((pct / 10) | floor) as $f |
    ("█" * $f) + ("░" * (10 - $f));

  (.context_window.used_percentage // 0) as $pct |
  ((.cost.total_duration_ms // 0) / 1000 | floor) as $secs |
  ($secs / 60 | floor) as $mins |
  ($secs % 60) as $s |
  (.cost.total_lines_added // 0) as $added |
  (.cost.total_lines_removed // 0) as $removed |

  "[\(.model.display_name // "?")] 📁 \(.workspace.project_dir // .cwd | split("/") | last) | 🌿 \($branch) | ✎ \($dirty)\n\(bar($pct)) \($pct)% | +\($added) -\($removed) | \($tod) \($mins)m | \($prayer)"
'
