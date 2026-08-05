#!/bin/bash
set -eu

# Opt-in, run by hand: Claude Code writes @ai for the tree view.
# wait = needs you, busy = running, idle = finished (opportunity), unset = no agent.
# Re-running replaces the hooks it installed (upgrade path).

settings=~/.claude/settings.json

if [ ! -e "$settings" ]; then
    echo "No $settings - is Claude Code installed?" >&2
    exit 1
fi

if ! command -v jq >/dev/null; then
    echo "jq is required" >&2
    exit 1
fi

# Same directory so the rename is atomic and cannot truncate the settings.
tmp=$(mktemp "$settings.XXXXXX")
trap 'rm -f "$tmp"' EXIT

# idle_prompt Notification would overwrite Stop's idle with wait — ignore it.
jq '
    def hook($cmd): {matcher: "", hooks: [{type: "command", command: $cmd, async: true}]};
    def state($s): hook("tmux set -w -t \"$TMUX_PANE\" @ai " + $s + " 2>/dev/null; true");
    def clear: hook("tmux set -uw -t \"$TMUX_PANE\" @ai 2>/dev/null; true");
    def ours: ((.command? // "") | tostring) | test("-t \"\\$TMUX_PANE\" @ai");
    def strip: map(if (.hooks | type) == "array" then .hooks |= map(select(ours | not)) else . end)
             | map(select((.hooks | type) != "array" or (.hooks | length) > 0));
    .hooks |= (. // {} | with_entries(.value |= strip))
    | .hooks.UserPromptSubmit += [state("busy")]
    | .hooks.Notification += [hook("[ \"$(jq -r .notification_type 2>/dev/null)\" = idle_prompt ] || tmux set -w -t \"$TMUX_PANE\" @ai wait 2>/dev/null; true")]
    | .hooks.Stop += [state("idle")]
    | .hooks.SessionEnd += [clear]
' "$settings" > "$tmp"

if cmp -s "$tmp" "$settings"; then
    echo "Claude Code tmux hooks already up to date"
    exit 0
fi

mv "$tmp" "$settings"
trap - EXIT
echo "Installed Claude Code tmux state hooks"
