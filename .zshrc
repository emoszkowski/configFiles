# .zshrc

### Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git z virtualenv)
source $ZSH/oh-my-zsh.sh

### Source local config (machine-specific, not in repo)
[[ -f ~/.paths ]]   && source ~/.paths    # PATH and env vars
[[ -f ~/.aliases ]] && source ~/.aliases  # Machine-specific aliases
[ -f "$HOME/.anthropic_env" ] && source "$HOME/.anthropic_env"

# System-wide zsh config
[[ -f /etc/zshrc ]] && source /etc/zshrc



### Editor
export EDITOR="emacs"
alias emacs='emacs -nw'
alias e='emacs -nw'

### Shell behavior
stty -ixon   # Disable C-s freeze

### ls aliases (OS-aware)
case $OSTYPE in
  darwin*)
    alias ls="ls -G"
    ;;
  linux*)
    alias ls="ls --color=auto --sort=extension --group-directories-first"
    ;;
esac

# TeX/LaTeX: hide build artifacts from ls on Linux
hide="--hide='*.aux' --hide='*.bbl' --hide='*.blg' --hide='*.fls' --hide='*.log' --hide='*.nav' --hide='*.out' --hide='*.snm' --hide='*.thm' --hide='*.toc' --hide='*~' --hide='*.cov'"

### Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias l='ls -AF'
alias ll='ls -AhlF'
alias mv='mv -i'   # Warn before overwrite
alias cp='cp -i'   # Warn before overwrite

latestn() { \ls -t | head -n $1 | tail -n 1 }
latestr() { find . -type f -printf '%T@ %p\n' | sort -n | tail -n $1 | cut -f2 -d" " }
cl() { cd "$*" && ls }

### Utilities
lookcsv() { sed 's/,,/, ,/g;s/,,/, ,/g' $1 | column -s , -t | less }

### Git (beyond oh-my-zsh git plugin)
alias githist='git log --graph --all --full-history --color --format=oneline --branches --abbrev-commit'
alias gitlogp='git log --graph --all --full-history --color --pretty=format:"%h%x09%d%x20%s"'
alias gitfiles='git ls-tree -r --name-only'
alias allgitfiles='git log --pretty=format: --name-only --diff-filter=A | sort - | sed "/^$/d"'

gittree() {
  local branch=${1:-master}
  printf "BRANCH: $branch\n\n"
  git ls-tree -r $branch --name-only
  printf "\nBRANCH: $branch\n"
}

unset SSH_ASKPASS

### PATH
export PATH="$HOME/.local/bin:$PATH"
