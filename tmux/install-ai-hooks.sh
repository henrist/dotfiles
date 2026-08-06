#!/usr/bin/env bash
# Install tmux @ai hooks for Claude Code and Grok (shared ai-state.sh).
# Opt-in, re-run to upgrade. Requires jq. Claude side needs ~/.claude/settings.json.
#
# Grok loads both ~/.grok/hooks/ and Claude settings (compat); the shared script
# is idempotent so double-firing is fine.
set -eu

root=$(cd "$(dirname "$0")" && pwd)
script=$root/ai-state.sh
chmod +x "$script"

if ! command -v jq >/dev/null; then
	echo "jq is required" >&2
	exit 1
fi

tmp=
cleanup() {
	if [ -n "${tmp:-}" ]; then
		rm -f "$tmp"
	fi
}
trap cleanup EXIT

settings=$HOME/.claude/settings.json
if [ -e "$settings" ]; then
	tmp=$(mktemp "$settings.XXXXXX")
	jq --arg s "$script" '
		def h($cmd): {matcher: "", hooks: [{type: "command", command: $cmd, async: true}]};
		def ours: ((.command? // "") | tostring) | test("ai-state\\.sh|@ai");
		def strip: map(if (.hooks | type) == "array" then .hooks |= map(select(ours | not)) else . end)
		         | map(select((.hooks | type) != "array" or (.hooks | length) > 0));
		.hooks |= (. // {} | with_entries(.value |= strip))
		| .hooks.UserPromptSubmit += [h(($s) + " busy")]
		| .hooks.SubagentStart += [h(($s) + " busy")]
		| .hooks.PreToolUse += [h(($s) + " busy")]
		| .hooks.PermissionRequest += [h(($s) + " wait")]
		| .hooks.Elicitation += [h(($s) + " wait")]
		| .hooks.Notification += [h(($s) + " notification")]
		| .hooks.Stop += [h(($s) + " stop")]
		| .hooks.SessionEnd += [h(($s) + " clear")]
	' "$settings" >"$tmp"
	if cmp -s "$tmp" "$settings"; then
		echo "Claude Code hooks already up to date"
		rm -f "$tmp"
	else
		mv "$tmp" "$settings"
		echo "Installed Claude Code hooks → $settings"
	fi
	tmp=
else
	echo "Skip Claude Code: no $settings"
fi

grok_dir=$HOME/.grok/hooks
grok_file=$grok_dir/tmux-ai-state.json
mkdir -p "$grok_dir"
tmp=$(mktemp "$grok_file.XXXXXX")
jq -n --arg s "$script" '
	{
		hooks: {
			UserPromptSubmit: [{hooks: [{type: "command", command: ($s + " busy")}]}],
			SubagentStart: [{hooks: [{type: "command", command: ($s + " busy")}]}],
			PreToolUse: [{hooks: [{type: "command", command: ($s + " busy")}]}],
			Notification: [{hooks: [{type: "command", command: ($s + " notification")}]}],
			Stop: [{hooks: [{type: "command", command: ($s + " stop")}]}],
			SessionEnd: [{hooks: [{type: "command", command: ($s + " clear")}]}]
		}
	}
' >"$tmp"
if [ -e "$grok_file" ] && cmp -s "$tmp" "$grok_file"; then
	echo "Grok hooks already up to date"
	rm -f "$tmp"
else
	mv "$tmp" "$grok_file"
	echo "Installed Grok hooks → $grok_file"
fi
tmp=

echo "ai-state.sh: $script"
