" Makes vim automatically write before executing a bash command in another
" tmux window.
"
" Add some documentation here so it's easy to set up.

augroup Autowrite
  au!
  " Record the TMUX_PANE for this pane
  au VimEnter * call s:AddVimPane()
  " Erase the record of the TMUX_PANE for this pane
  au VimLeave * call s:RemoveVimPane()
augroup END

function! s:AddVimPane()
  let existing_vim_panes = split(s:chomp(system('tmux show-environment -g | grep VIM_PANES | cut -f 2 -d =')), ";")
  let new_vim_panes = existing_vim_panes + [s:CurrentVimPane()]
  call system('tmux set-environment -g VIM_PANES "'.join(new_vim_panes, ";").'"')
endfunction

function! s:RemoveVimPane()
  let existing_vim_panes = split(s:chomp(system('tmux show-environment -g | grep VIM_PANES | cut -f 2 -d =')), ";")
  let remaining_vim_panes = filter(existing_vim_panes, 'v:val != s:CurrentVimPane()')
  call system('tmux set-environment -g VIM_PANES "'.join(remaining_vim_panes, ";").'"')
endfunction

function! s:CurrentVimPane()
  return join([s:chomp(system('echo $TMUX_PANE')), s:chomp(system('ps $$ -otty=')), getpid()], " ")
endfunction

function! s:chomp(string)
  return substitute(a:string, "\n", "", "")
endfunction

" Add tmux's higher F-key capabilities
if &term == "screen-256color"
  set t_F3=[25~
  set t_F4=[26~
  set t_F5=[28~
  set t_F6=[29~
  set t_F7=[31~
  set t_F8=[32~
  set t_F9=[33~
endif

map <silent> <F19>WriteAll :silent! wall<CR>
