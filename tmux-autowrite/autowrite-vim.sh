#! /bin/bash/

# Things we changed:
# - This file
# - better_history.sh
# - casebook2.sh
# - preexec.sh.lib
# - .vim/init/autowrite.vim

source $(dirname $BASH_SOURCE[0])/preexec.sh.lib

# Things that could go wrong:
# √ No vim
# √ Vim is suspended
# √ Multiple vims
# √ A vim doesn't support F-keys
# √ No tmux
# √ Command given to run-shell could return non-zero
# √ No tmux server running
function preexec() {
	read -r -d '' send_write_cmd <<-'SH'
		function tell_vim_to_write() {
			local pane=$1
			local tty=$2
			local pid=$3

			(ps -ostate=,pid= -t $tty | grep -E "\+[[:space:]]*$pid") >/dev/null
			local vim_in_foreground=$?

			if [[ $vim_in_foreground == 0 ]]; then
				tmux send-keys -t $pane ^\\ ^n F19 WriteAll
			fi
		}

		if [[ -n "$VIM_PANES" ]]; then
			(
				local old_ifs=$IFS
				IFS=";"
				for vim_pane in $VIM_PANES; do
					(
						unset IFS
						tell_vim_to_write $vim_pane
					)
				done
			)
		fi
	SH

	tmux run-shell "$send_write_cmd" &>/dev/null
	true
}

# Preexec bug: PROMPT_COMMAND needs to be set to something.
PROMPT_COMMAND="${PROMPT_COMMAND:-true}"
preexec_install

# vim: noexpandtab nolist
