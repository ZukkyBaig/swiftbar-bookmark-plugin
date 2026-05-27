#!/bin/bash

# <xbar.title>Bookmarks</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>zukky</xbar.author>
# <xbar.desc>Quick-access URL bookmarks in the menubar.</xbar.desc>

SCRIPT="$0"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BOOKMARKS_FILE="$SCRIPT_DIR/../bookmarks.txt"

[ -f "$BOOKMARKS_FILE" ] || touch "$BOOKMARKS_FILE"

trim() {
    local s="$1"
    s="${s#"${s%%[![:space:]]*}"}"
    s="${s%"${s##*[![:space:]]}"}"
    printf '%s' "$s"
}

case "$1" in
  add)
    result=$(osascript <<'EOF' 2>/dev/null
try
  set theName to text returned of (display dialog "Bookmark name:" default answer "" with title "Add Bookmark")
  set theURL to text returned of (display dialog "URL:" default answer "https://" with title "Add Bookmark")
  return theName & "§" & theURL
on error
  return ""
end try
EOF
)
    if [ -n "$result" ]; then
      name="${result%%§*}"
      url="${result#*§}"
      name="$(trim "$name")"
      url="$(trim "$url")"
      if [ -n "$name" ] && [ -n "$url" ]; then
        case "$url" in
          http://*|https://*) ;;
          *) url="https://$url" ;;
        esac
        printf '%s | %s\n' "$name" "$url" >> "$BOOKMARKS_FILE"
      fi
    fi
    exit 0
    ;;
  remove)
    target="$2"
    if [ -n "$target" ]; then
      tmp="$(mktemp)"
      awk -F'\\|' -v t="$target" '
        {
          name=$1
          sub(/[[:space:]]+$/, "", name)
          sub(/^[[:space:]]+/, "", name)
          if (name != t) print
        }
      ' "$BOOKMARKS_FILE" > "$tmp"
      mv "$tmp" "$BOOKMARKS_FILE"
    fi
    exit 0
    ;;
esac

echo ":bookmark:"
echo "---"

if [ ! -s "$BOOKMARKS_FILE" ]; then
  echo "No bookmarks yet | color=gray"
else
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    name="$(trim "${line%%|*}")"
    url="$(trim "${line#*|}")"
    [ -z "$name" ] || [ -z "$url" ] && continue
    echo "$name | href=$url"
  done < "$BOOKMARKS_FILE"
fi

echo "---"
echo "Add bookmark… | shell=\"$SCRIPT\" param1=add refresh=true terminal=false"

if [ -s "$BOOKMARKS_FILE" ]; then
  echo "Remove bookmark"
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    name="$(trim "${line%%|*}")"
    [ -z "$name" ] && continue
    echo "-- $name | shell=\"$SCRIPT\" param1=remove param2=\"$name\" refresh=true terminal=false"
  done < "$BOOKMARKS_FILE"
fi

echo "Edit file… | shell=open param1=\"$BOOKMARKS_FILE\" terminal=false"
echo "Refresh | refresh=true"
