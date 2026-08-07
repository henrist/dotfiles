#!/usr/bin/env bash
# Map Claude Code / Grok hook events to pane-scoped @ai for the tree view.
# wait = needs you, busy = running, idle = finished (opportunity), unset = none.
# busy turns monitor-activity off so status/tree don't go red on every tool line.
# Pane-scoped so two AIs in one window don't fight and a moved pane can't leave
# its state behind; the tree aggregates panes and hides dots when no AI runs.
#
# Hooks must be synchronous: async spawn order is not guaranteed and busy/wait
# fire ~50ms apart around permission prompts (PreToolUse comes BEFORE the
# dialog, not after the grant — PostToolUse is what restores busy).
# Known gap (Claude Code 2.1.224): no hook fires on Esc interrupt or dialog
# cancel, so the last state sticks until the next real event.
#
# Usage (hook command):
#   ai-state.sh busy|wait|idle|clear
#   ai-state.sh stop          # stdin: hook JSON — idle unless background work
#   ai-state.sh notification  # stdin: wait only for known need-you types
#   ai-state.sh sessionstart  # stdin: clear stale state, except mid-turn compact
set -eu

action=${1:-}

set_ai() {
	local state=$1 monitor=on
	[ -n "${TMUX_PANE:-}" ] || return 0
	[ "$state" = busy ] && monitor=off
	# set -uw drops window-scoped @ai left by the pre-pane-scoped scheme.
	if [ "$state" = clear ]; then
		tmux set -up -t "$TMUX_PANE" @ai \; \
			set -uw -t "$TMUX_PANE" @ai \; \
			set -w -t "$TMUX_PANE" monitor-activity on 2>/dev/null || true
	else
		tmux set -p -t "$TMUX_PANE" @ai "$state" \; \
			set -uw -t "$TMUX_PANE" @ai \; \
			set -w -t "$TMUX_PANE" monitor-activity "$monitor" 2>/dev/null || true
	fi
}

# Hooks pipe JSON on stdin. Skip when interactive so a manual invoke does not hang.
read_input() {
	if [ -t 0 ]; then
		return 0
	fi
	cat 2>/dev/null || true
}

case "$action" in
busy | wait | idle | clear)
	set_ai "$action"
	;;
stop)
	input=$(read_input)
	# Grok fires an observe-only Stop at session end — leave the last real state.
	reason=$(printf '%s' "$input" | jq -r '.reason // empty' 2>/dev/null || true)
	if [ -n "$reason" ] && [ "$reason" != end_turn ]; then
		exit 0
	fi
	n=$(printf '%s' "$input" | jq -r '((.backgroundTasks // .background_tasks // []) | length)' 2>/dev/null || echo 0)
	if [ "${n:-0}" -gt 0 ] 2>/dev/null; then
		set_ai busy
	else
		set_ai idle
	fi
	;;
notification)
	input=$(read_input)
	typ=$(printf '%s' "$input" | jq -r '.notification_type // .notificationType // empty' 2>/dev/null || true)
	case "$typ" in
	permission_prompt | elicitation_dialog | agent_needs_input | permission)
		set_ai wait
		;;
	idle_prompt)
		set_ai idle
		;;
	esac
	;;
sessionstart)
	input=$(read_input)
	src=$(printf '%s' "$input" | jq -r '.source // empty' 2>/dev/null || true)
	# Auto-compact restarts the session mid-turn — the AI is still working.
	if [ "$src" != compact ]; then
		set_ai clear
	fi
	;;
*)
	echo "usage: $0 busy|wait|idle|clear|stop|notification|sessionstart" >&2
	exit 1
	;;
esac
