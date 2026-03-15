#!/usr/bin/env bash
#
#        Title:      tmux-quick-start
#        Brief:      Inicializa uma sessão tmux com layout fixo para monitoramento do portage.
#        Path:       /home/jkyon/.config/awesome/scripts/tmux-quick-start.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-03-15
#        Updated:    2026-03-15
#        Notes:      Cria 2 panes na esquerda vazias e 3 panes na direita com comandos.
#

set -euo pipefail

SESSION_NAME="${TMUX_QUICK_START_SESSION:-portage-panel}"
WINDOW_NAME="${TMUX_QUICK_START_WINDOW:-main}"
ATTACH_ON_START="${TMUX_QUICK_START_ATTACH:-1}"

RIGHT_TOP_COMMAND="nice --adjustment=19 watch --color --interval 1 genlop -ci"
RIGHT_MIDDLE_COMMAND="nice --adjustment=19 env DISTCC_DIR=/var/tmp/portage/.distcc distccmon-text 1"
RIGHT_BOTTOM_COMMAND="nice --adjustment=19 watch --interval 3 --differences df -h /efi /boot/ /"

require_tmux() {
	if ! command -v tmux >/dev/null 2>&1; then
		echo "Erro: tmux nao esta instalado ou nao esta no PATH." >&2
		exit 1
	fi
}

session_exists() {
	tmux has-session -t "$SESSION_NAME" 2>/dev/null
}

attach_session() {
	if [[ "$ATTACH_ON_START" != "1" ]]; then
		return 0
	fi

	exec tmux attach-session -t "$SESSION_NAME"
}

start_command_in_pane() {
	local pane_id="$1"
	local command="$2"

	tmux respawn-pane -k -t "$pane_id" "$command"
}

create_layout() {
	local left_top
	local right_top
	local right_middle
	local right_bottom

	tmux new-session -d -s "$SESSION_NAME" -n "$WINDOW_NAME"

	left_top="$(tmux display-message -p -t "${SESSION_NAME}:${WINDOW_NAME}.0" '#{pane_id}')"
	right_top="$(tmux split-window -h -t "$left_top" -P -F '#{pane_id}')"
	right_middle="$(tmux split-window -v -t "$right_top" -P -F '#{pane_id}')"
	right_bottom="$(tmux split-window -v -t "$right_middle" -P -F '#{pane_id}')"
	tmux split-window -v -t "$left_top" >/dev/null

	start_command_in_pane "$right_top" "$RIGHT_TOP_COMMAND"
	start_command_in_pane "$right_middle" "$RIGHT_MIDDLE_COMMAND"
	start_command_in_pane "$right_bottom" "$RIGHT_BOTTOM_COMMAND"

	tmux select-pane -t "$left_top"
}

main() {
	require_tmux

	if session_exists; then
		attach_session
	fi

	create_layout
	attach_session
}

main "$@"
