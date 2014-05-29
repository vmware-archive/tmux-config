autoload -U add-zsh-hook

# Things that could go wrong:
# √ No vim
# √ Vim is suspended
# √ Multiple vims
# √ A vim doesn't support F-keys
# √ No tmux
# √ Command given to run-shell could return non-zero
# √ No tmux server running
function send_to_vim {
  local pane=$1
  local tty=$2
  local pid=$3

  shift 3  # Remaining arguments are keys to send

  (ps -ostate=,pid= -t $tty | grep "S \+$pid") >/dev/null 2>&1
  local vim_in_foreground=$?

  if [[ $vim_in_foreground == 0 ]]; then
    tmux send-keys -t $pane $@
  fi
}

function trigger_vim_function {
  local keys=$1
  local pane_list
  local panes
  pane_list=$(tmux show-environment -g | grep VIM_PANES | cut -f 2 -d =)
  panes=("${(s/;/)pane_list}")
  for vim_pane in $panes; do
    eval send_to_vim $vim_pane $keys
  done
  true
}

function trigger_autosave {
  trigger_vim_function "F19 WriteAll"
}

function trigger_autoreload {
  trigger_vim_function "F19 AutoReload"  
}

add-zsh-hook preexec trigger_autosave
add-zsh-hook precmd  trigger_autoreload
