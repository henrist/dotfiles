#!/bin/bash
set -eu

# Opt-in, run by hand: Claude Code writes @ai for the tree view.
# wait = needs you, busy = running (incl. subagent/monitor), idle = finished
# opportunity, unset = no agent. Re-running replaces our hooks (upgrade path).

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

# wait is an allowlist: only real user-input events. Anything else (idle_prompt,
# auth_success, agent_completed, unknown) must not paint red — monitors and
# subagents are still "working". SubagentStart / Monitor keep busy while those run.
jq '
    def setai($s): "tmux set -w -t \"$TMUX_PANE\" @ai " + $s + " 2>/dev/null; true";
    def clearai: "tmux set -uw -t \"$TMUX_PANE\" @ai 2>/dev/null; true";
    def hook($cmd): {matcher: "", hooks: [{type: "command", command: $cmd, async: true}]};
    def mhook($m; $cmd): {matcher: $m, hooks: [{type: "command", command: $cmd, async: true}]};
    def state($s): hook(setai($s));
    def clear: hook(clearai);
    def ours: ((.command? // "") | tostring) | test("-t \"\\$TMUX_PANE\" @ai");
    def strip: map(if (.hooks | type) == "array" then .hooks |= map(select(ours | not)) else . end)
             | map(select((.hooks | type) != "array" or (.hooks | length) > 0));
    .hooks |= (. // {} | with_entries(.value |= strip))
    | .hooks.UserPromptSubmit += [state("busy")]
    | .hooks.SubagentStart += [state("busy")]
    | .hooks.PreToolUse += [mhook("Monitor"; setai("busy"))]
    | .hooks.PermissionRequest += [state("wait")]
    | .hooks.Elicitation += [state("wait")]
    | .hooks.Notification += [mhook(
        "permission_prompt|elicitation_dialog|agent_needs_input";
        setai("wait")
      )]
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
