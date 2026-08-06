#!/usr/bin/env bash
# Map Claude Code / Grok hook events to tmux window @ai for the tree view.
# wait = needs you, busy = running, idle = finished (opportunity), unset = none.
# busy turns monitor-activity off so status/tree don't go red on every tool line.
#
# Usage (hook command):
#   ai-state.sh busy|wait|idle|clear
#   ai-state.sh stop          # stdin: hook JSON — idle unless background work
#   ai-state.sh notification  # stdin: wait only for known need-you types
set -eu

action=${1:-}

set_ai() {
	local state=$1
	[ -n "${TMUX_PANE:-}" ] || return 0
	if [ "$state" = clear ]; then
		tmux set -uw -t "$TMUX_PANE" @ai 2>/dev/null || true
		tmux set -w -t "$TMUX_PANE" monitor-activity on 2>/dev/null || true
	else
		tmux set -w -t "$TMUX_PANE" @ai "$state" 2>/dev/null || true
		if [ "$state" = busy ]; then
			tmux set -w -t "$TMUX_PANE" monitor-activity off 2>/dev/null || true
		else
			tmux set -w -t "$TMUX_PANE" monitor-activity on 2>/dev/null || true
		fi
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
	# Grok: still working if monitors/subagents/shells are in flight.
	# Claude: fields absent → length 0 → idle (correct for a finished turn).
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
	esac
	;;
*)
	echo "usage: $0 busy|wait|idle|clear|stop|notification" >&2
	exit 1
	;;
esac
