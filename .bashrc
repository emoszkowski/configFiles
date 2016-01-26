# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Additions to path
source ~/.paths

# Aliases to machine-specific paths
source ~/.aliases

# User specific aliases and functions
alias ..='cd ..'
alias ...='cd ../..'
alias dropbox='cd ~/Dropbox'

# Run emacs in the terminal
alias emacs='emacs -nw'

# Change what ls displays
alias ls='\ls --color'
alias l='\ls -AF --color'
alias l1='\ls -AF1 --color'
alias ll='\ls -AhlF --color'
alias lsd='\ls -d1 --color */'
alias lld='\ls -dhl --color */'

# Colorize PS1, and add git branch. See https://github.com/jimeh/git-aware-prompt.
export GITAWAREPROMPT=~/.bash/git-aware-prompt 
source "${GITAWAREPROMPT}/main.sh" 2>/dev/null 
# export PS1="\[$(tput setaf 4)\][\[$(tput setaf 4)\]\u\[$(tput setaf 4)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 2)\]\W\[$(tput setaf 4)\] \[$ "
export PS1="\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "


#Better log viewing in Git, from Henry and Micah
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

# Access nth most recent modified file.
latestn(){
  \ls -t | head -n $1 | tail -n 1  
}

# The names of the n most recently modified files in this directory and all
# subdirectories. See http://stackoverflow.com/a/4561987/2514228
latestr(){
  find . -type f -printf '%T@ %p\n' | sort -n | tail -n $1 | cut -f2 -d" "
}

# Zsh-like cd + list the files in the directory
cl(){
  c "$*" && ls
}
unset SSH_ASKPASS

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

