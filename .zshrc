# .zshrc

### Source other files

source ~/.paths          # Additions to path
source ~/.aliases        # Aliases to machine-specific paths


# Source global definitions
if [ -f /etc/zshrc ]; then
    . /etc/zshrc
fi

# Disable Apple's flaky auto-title updater
unset -f update_terminal_cwd 2>/dev/null
precmd_functions=(${precmd_functions:#update_terminal_cwd})
chpwd_functions=(${chpwd_functions:#update_terminal_cwd})
update_terminal_cwd() { :; }

### Use anaconda instead of default python
#export PATH="$HOME/anaconda3/bin:$PATH"
export PATH=/usr/local/anaconda3/bin:$PATH
export PATH=/opt/homebrew/anaconda3/bin:$PATH
#export PATH=/usr/local/anaconda3/bin:$PATH
export PYTHONPATH="~Dropbox/Research/Data/Willie Swett and Co/business-list/:$PYTHON"

### Display

# When evince is being stupid, exit tmux and run cache_display,
# reattach and run parse_display. May need to do this for every pane.

# cache DISPLAY environment variable from outside tmux
cache_display() {
    echo "$DISPLAY" > ~/.DISPLAY
    echo "DISPLAY cached as $DISPLAY"
}

# parse cached DISPLAY enviroment variable within tmux
parse_display() {
    DISPLAY_OLD="$DISPLAY"
    export DISPLAY="$(cat ~/.DISPLAY)"
    echo "DISPLAY updated from $DISPLAY_OLD to $DISPLAY"
}


### Editor
EDITOR="emacs"           # Set default editor for command-line programs
alias emacs='emacs -nw'  # Run emacs in the terminal

# Make emacs syntax highlighting work properly.
# DO NOT set to cygwin, or emacs display gets messed up...
export TERM="xterm-256color"


### Make terminal play nice
stty -ixon       # Disable <C-s> that hangs terminal

# Hide files from ls
hide="--hide='*.aux' --hide='*.bbl' --hide='*.blg' --hide='*.fls' --hide='*.log' --hide='*.nav' --hide='*.out' --hide='*.snm' --hide='*.thm' --hide='*.toc' --hide='*~' --hide='*.cov'"

# Read CSVs in bash
lookcsv () { sed 's/,,/, ,/g;s/,,/, ,/g' $1 | column -s , -t | less;}

# OS-specific aliases
case $OSTYPE in
  cygwin*)
    alias ls="ls --color=auto --sort=extension --group-directories-first $hide"
    ;;
  darwin*) # OS X
    alias ls="ls -G"
    ;;
  linux*)
    alias ls="ls --color=auto --sort=extension --group-directories-first $hide"
    ;;
  *) ;;
esac

### User-specific aliases and functions
alias ..='cd ..'
alias ...='cd ../..'
alias l='ls -AF --color'
alias l1='ls -AF1 --color'
alias ll='ls -AhlF --color'
alias lsd='ls -d1 --color */'
alias lld='ls -dhl --color */'
alias e='emacs -nw'
alias ev='evince'
alias mv='mv -i'                  # Warn me before I overwrite files
alias cp='cp -i'                  # Warn me before I overwrite files
alias mytop="top -u $USER"        # Top just for my stuff


# Access nth most recent modified file.
latestn(){
  \ls -t | head -n $1 | tail -n 1
}

# The names of the n most recently modified files in this directory and all
# subdirectories. See http://stackoverflow.com/a/4561987/2514228
latestr(){
  find . -type f -printf '%T@ %p\n' | sort -n | tail -n $1 | cut -f2 -d" "
}

# Jawn from Matt Cocci; see https://github.com/MattCocci/Jawn
function j()
{
  if [ -d $1 ]
  then
      cd $1
  else
      python jawn.py $1
  fi
}

# Zsh-like cd + list the files in the directory
cl(){
  c "$*" && ls
}

### Git

# Colorize PS1, and add git branch. See https://github.com/jimeh/git-aware-prompt.
#export GITAWAREPROMPT=~/.bash/git-aware-prompt
#source "${GITAWAREPROMPT}/main.sh" 2>/dev/null
# export PS1="\[$(tput setaf 4)\][\[$(tput setaf 4)\]\u\[$(tput setaf 4)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 2)\]\W\[$(tput setaf 4)\] \[$ "
#export PS1="\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "

autoload -Uz compinit && compinit

# colorize
autoload -U colors && colors
PS1="%{$fg[yellow]%}%n%{$reset_color%}@%{$fg[cyan]%}%m %{$fg[magenta]%}%~ %{$reset_color%}%% "

# git aware prompt for zsh (from https://github.com/zsh-git-prompt/zsh-git-prompt)
source ~/zsh-git-prompt/zshrc.sh
# an example prompt
PROMPT='%B%m%~%b$(git_super_status) %# '


# Aliases
alias gs='git status'
alias ga='git add'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gg='git grep'
alias gd='git diff'

# Better log viewing, from Henry and Micah
alias githist='git log --graph --all --full-history --color --format=oneline --branches --abbrev-commit'
alias gitlogp='git log --graph --all --full-history --color --pretty=format:"%h%x09%d%x20%s"'

# See which files are tracked by Git
alias gitfiles='git ls-tree -r --name-only'
alias allgitfiles='git log --pretty=format: --name-only --diff-filter=A | sort - | sed '/^$/d''

function gittree {
  local branch
  if [ -z $1 ]
  then
    branch="master"
  else
    branch="$1"
  fi
  printf "BRANCH: $branch\n\n"
  git ls-tree -r $branch --name-only
  printf "\nBRANCH: $branch\n"
}

# So the display doesn't come up for git
unset SSH_ASKPASS

# Source any local overrides
#source ~/.zshrc_local
