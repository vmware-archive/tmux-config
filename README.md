# OVERVIEW

This plugin contains configuration and tools to use tmux with VIM.
It contains:

* tmux.conf -- Good default tmux config
* Vim cursors -- Cursor type distinguishes between Vim modes. 
* Vim autosave -- Automatically save all Vim buffers before any terminal command is executed.

## Installation as a Vim Plugin:
If using Pathogen:

    git submodule add git://github.com/pivotal/tmux-config.git bundle/tmux-config
    git submodule update --init

## tmux.conf Installation
If you have installed this repo as a Vim plugin:

    ln -s ~/.vim/bundle/tmux-config/tmux.conf ~/.tmux.conf

Otherwise symlink, copy the file, or copy its contents to ~/.tmux.conf

## Autosave: 
This adds Vim auto-saving support when running within tmux.
When any command is run on the command line, be it `ls` or 
even just hitting ENTER, all Vim sessions running within
all tmux sessions (of this tmux server) will be written.

### Autosave Installation 
To enable VIM autosaving, add the following to your .bash\_profile, .bashrc, or .profile:

    source ~/.vim/bundle/tmux-config/tmux-autowrite/autowrite-vim.sh


# ACKNOWLEDGEMENTS

Thanks go out to the Casecommons team for developing this 
autosave solution. Please see the original files at
https://github.com/Casecommons/vim-config
and 
https://github.com/Casecommons/casecommons_workstation
