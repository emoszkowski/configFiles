#!/bin/zsh
# Erica Moszkowski
#
# setup.sh
#   Set up all my configs: Downloads emacs plugins and modes, bash git
#   prompt, and creates symlinks of relevant dot files in home directory
#
#   Usage:
#     ./setup.sh path/to/dotfile/repo

SCRIPTNAME=$(basename $0)
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

### Todo: download brew if on mac and I don't have it already

# Colors
# https://stackoverflow.com/questions/2924697/how-does-one-output-bold-text-in-bash
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)

# define contains function; this is important for later
# usage: contains aList anItem
contains() {
    [[ $1 =~ (^|[[:space:]])$2($|[[:space:]]) ]] && exit(0) || exit(1)
}


# Location of configFiles repo
if [ -z "$1" ]; then
    echo "${red}Run script using ./init.sh path/to/configFiles/repo${normal}"
    exit 1
fi
dotfile_dir=$1

# Check if something is installed
# Usage: not_installed <program>
# https://stackoverflow.com/a/677212
not_installed() {
    return ! command -v $1 &> /dev/null
}

# Make file if it doesn't already exist
# Usage: maybe_touch <path>
maybe_touch() {
    if [ ! -f "$1" ]; then
        touch -p "$1"
        if [ "$?" -eq 0 ]; then
            echo "${green}Created $1${normal}"
        else
            echo "${red}Could not create $1${normal}"
        fi
    fi
}

# Make directory if it doesn't already exist
# Usage: maybe_mkdir <path>
maybe_mkdir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        if [ "$?" -eq 0 ]; then
            echo "${green}Created $1${normal}"
        else
            echo "${red}Could not create $1${normal}"
        fi
    fi
}

# Add to PATH environment variable verbosely
# Usage: try_addpath <dir> <front>
try_addpath() {
    dir=$1
    front=$2 # whether to add dir to front of PATH
    if [ -z "$(grep $dir $HOME/.bashrc-local)" ]; then
        if [ $front -eq 1 ]; then
            echo "export PATH=$dir:\$PATH" >> "$HOME/.bashrc-local"
        else
            echo "export PATH=\$PATH:$dir" >> "$HOME/.bashrc-local"
        fi
        if [ "$?" -eq 0 ]; then
            echo "${green}Added $dir to PATH in $HOME/.bashrc-local${normal}"
        else
            echo "${red}Could not add $dir to PATH in $HOME/.bashrc-local${normal}"
        fi
    else
        echo "${red}Did not add $dir to PATH in $HOME/.bashrc-local: already there${normal}"
    fi
}

# Create symlinks verbosely
# Usage: try_symlink <src> <dst=src>
# Performs: ln -s "$dotfile_dir/$src" "$(pwd)/$dst"
# See https://stackoverflow.com/a/33419280 for reference on bash optional arguments
try_symlink() {
    src=$1
    dst=${2:-$src}
    if [ -L "$dst" ]; then
        echo "${red}Did not link $(pwd)/$dst: symlink already exists${normal}"
    elif [ ! -f "$src" ]; then
        ln -s "$dotfile_dir/$src" "$dst"
        if [ "$?" -eq 0 ]; then
            echo "${green}Linked $(pwd)/$dst -> $dotfile_dir/$src${normal}"
        else
            echo "${red}Could not link $(pwd)/$dst${normal}"
        fi
    else
        echo "${red}Did not link $dst: non-symlink file already exists. Merge $dst into $dotfile_dir/$src first and then delete $dst before retrying${normal}"
    fi
}

# Set environment variable verbosely
# Usage: try_setenv <variable> <value>
try_setenv() {
    var=$1
    val=$2
    if [ -z "$var" ]; then
        echo "export $var=\"$val\"" >> "$HOME/.bashrc-local"
        if [ "$?" -eq 0 ]; then
            echo "${green}Set $var to $val in $HOME/.bashrc-local${normal}"
        else
            echo "${red}Could not set $var to $val in $HOME/.bashrc-local${normal}"
        fi
    else
        echo "${red}Did not set $var to $val in $HOME/.bashrc-local: already has a value${normal}"
    fi
}

# Add to PATH environment variable verbosely
# Usage: try_addpath <dir> <front>
try_addpath() {
    dir=$1
    front=$2 # whether to add dir to front of PATH
    if [ -z "$(grep $dir $HOME/.bashrc-local)" ]; then
        if [ $front -eq 1 ]; then
            echo "export PATH=$dir:\$PATH" >> "$HOME/.bashrc-local"
        else
            echo "export PATH=\$PATH:$dir" >> "$HOME/.bashrc-local"
        fi
        if [ "$?" -eq 0 ]; then
            echo "${green}Added $dir to PATH in $HOME/.bashrc-local${normal}"
        else
            echo "${red}Could not add $dir to PATH in $HOME/.bashrc-local${normal}"
        fi
    else
        echo "${red}Did not add $dir to PATH in $HOME/.bashrc-local: already there${normal}"
    fi
}


# OSX specific installs
case $OSTYPE in
    linux*) # Linux


	mkdir -p ~/local/bin/

	if [ ! -d $HOME/local/bin/julia-1.9.2/ ]
	    wget https://julialang-s3.julialang.org/bin/linux/x64/1.9/julia-1.9.2-linux-x86_64.tar.gz
	    tar zxvf julia-1.9.2-linux-x86_64.tar.gz -C ~/local/bin/
	    rm julia-1.9.2-linux-x86_64.tar.gz
	fi

	;;

    darwin*) # OS X

	# install brew and other useful things
	#if ! command -v brew >/dev/null 2>&1;
	#if [ ! "$(which brew)" == "/usr/local/bin/brew" ];
	# if [ ! -d "/usr/local/bin/brew" ];

	# if [ ! command -v brew >/dev/null 2>&1 ];
	if ! command -v brew >/dev/null 2>&1;
	then
	    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	    # add brew to path
	    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/ericamoszkowski/.zprofile
    	    eval "$(/opt/homebrew/bin/brew shellenv)"

            # key packages
            brew install coreutils
	    brew install emacs
	    brew install git
            brew install pandoc
            brew install python
	    brew install rename
	    brew install r
            brew install rsync
            brew install tmux
	    brew install wget

	    brew install --cask julia
            brew install --cask lyx
            brew install --cask mactex
            brew install --cask meld
            brew install --cask rstudio
            brew install --cask skim
	    brew install --cask typora

            # The following are easier to build using Brew than in Julia
            brew install gcc   # HDF5.jl
            brew install cmake # Polynomials.jl


        fi

	#emacs_version="$(emacs --version | head -n 1 | awk '{print $NF}')"
	#bad_emacs_version="22."
	#if [ emacs_version == *"$bad_emacs_version"* ];
	#then
	#    # remove old version of emacs
	#    sudo rm /usr/bin/emacs
	#    sudo rm -rf /usr/share/emacs

	    # install new version of emacs
	#    brew cask install emacs
	#fi

        # Set environment variables
        try_addpath "/Library/TeX/texbin" 0

	casks="$(brew list --cask)"

	# LaTeX and LaTeX software
	#if [ ! contains casks mactex ];
	#then
	#    brew cask install mactex
	#fi
	#if [ ! contains casks lyx ];
	#then
	#   brew cask install lyx
	#fi
	# if [ ! -d $HOME/ ]
	#    git clone https://github.com/ShiroTakeda/econ-bst.git $HOME/Library/Fonts/FiraSans
	# fi



	# Dropbox
	if [ ! contains casks dropbox ]
	then
	    brew cask install dropbox
	fi

	# Julia
	#if [ ! contains casks julia ]
	#then
	#    brew install --cask julia
	#fi

	# R
	#if brew ls --versions r > /dev/null; then
	#    # The package is installed
	#else
	    # The package is not installed
	#    brew install r
	#fi

	#if [ ! contains casks rstudio ]
	#then
	#    brew install --cask rstudio
	#fi

	# Meld
	#if [ ! contains casks meld ]
	#then
	#    brew install --cask caskroom/cask/meld
	#fi


	# Tmux
	#if brew ls --versions tmux > /dev/null; then
	#    # The package is installed
	#else
	#    # The package is not installed
	#    brew install tmux
	#fi

	# Font for Beamer
	if [ ! -d $HOME/Library/Fonts/FiraSans/ ]
	then
	   git clone https://github.com/bBoxType/FiraSans.git $HOME/Library/Fonts/FiraSans
	fi

	# Python

	if [ ! -d ~/usr/local/bin/ipython ]; then

	   brew install ipython3
	   brew install pip3
	   pip3 install numpy
	   pip3 install scipy
	   pip3 install ipython
	   pip3 install statsmodels
	   pip3 install seaborn
	   pip3 install pandas
	   pip3 install matplotlib

	fi
	;;
esac

### Emacs setup

# Setup julia-emacs mode
if [ ! -d ~/.emacsconfig/julia-emacs ];
then
    mkdir -p ~/.emacsconfig/julia-emacs
    git clone https://github.com/JuliaLang/julia-emacs.git ~/.emacsconfig/julia-emacs
 else
     echo "$SCRIPTNAME: julia-emacs mode already installed"
fi

# Get anaphora (upon which julia-repl depends)
if [ ! -d ~/.emacsconfig/anaphora ];
then
    mkdir -p ~/.emacsconfig/anaphora
    git clone https://github.com/rolandwalker/anaphora.git ~/.emacsconfig/anaphora
 else
     echo "$SCRIPTNAME: julia-repl minor mode already installed"
fi

# Setup julia-repl minor mode to have a julia terminal within emacs
if [ ! -d ~/.emacsconfig/julia-repl ];
then
    mkdir -p ~/.emacsconfig/julia-repl
    git clone https://github.com/tpapp/julia-repl.git ~/.emacsconfig/julia-repl
 else
     echo "$SCRIPTNAME: julia-repl minor mode already installed"
fi

# Setup matlab mode
if [ ! -d ~/.emacsconfig/matlab-mode ];
then
    mkdir -p ~/.emacsconfig/matlab-mode
    git clone git://git.code.sf.net/p/matlab-emacs/src matlab-mode
else
    echo "$SCRIPTNAME: matlab-mode already installed"
fi

# Get yaml mode
if [ ! -d ~/.emacsconfig/yaml-mode ];
then
    mkdir -p ~/.emacsconfig/yaml-mode
    git clone https://github.com/yoshiki/yaml-mode
 else
     echo "$SCRIPTNAME: emacs yaml-mode already installed"
fi

# Get MATLAB packages I like
if [ ! -d ~/.matlabconfig/latexTable];
then
    mkdir -p ~/.matlabconfig/latexTable
    git clone https://github.com/eliduenisch/latexTable.git
else
    echo "$SCRIPTNAME: matlab latexTable already installed"
fi

# ESS setup

if [ ! -d ~/.emacsconfig/ESS ];
then
    mkdir -p ~/.emacsconfig/ESS
    git clone git://github.com/emacs-ess/ESS.git ~/.emacsconfig/ESS

    # move to that directory and make all
    mydir="$( pwd)"
    cd ~/.emacsconfig/ESS
    make all
    cd $mydir
 else
    echo "$SCRIPTNAME: ESS already installed"
fi

# markdown mode
if [ ! -d ~/.emacsconfig/markdown-mode ];
then
    mkdir -p ~/.emacsconfig/markdown-mode
    git clone https://github.com/jrblevin/markdown-mode.git ~/.emacsconfig/markdown-mode
fi
# Grip


### Bash setup

# Setup git-aware-prompt
if [ ! -d ~/.bash/git-aware-prompt ];
then
    mkdir -p ~/.bash/git-aware-prompt
    git clone https://github.com/jimeh/git-aware-prompt.git ~/.bash/git-aware-prompt
 else
     echo "$SCRIPTNAME: git-aware-prompt already installed"
fi

# Setup zsh git-aware-prompt
if [ ! -d ~/zsh-git-prompt ];
then
    mkdir -p ~/zsh-git-prompt
    git clone https://github.com/zsh-git-prompt/zsh-git-prompt.git ~/zsh-git-prompt
 else
     echo "$SCRIPTNAME: zsh-git-prompt already installed"
fi


# Setup Jawn
if [ ! -d ~/Jawn ];
then
    mkdir -p ~/Jawn
    git clone https://github.com/MattCocci/Jawn.git ~/Jawn
 else
    echo "$SCRIPTNAME: Jawn already installed"
fi


### Dotfiles
for FILE in .bashrc .emacs .tmux.conf .gitconfig .gitignore_global;
do
    echo $FILE
    if [ ! -h "$HOME/$FILE" ];
    then
        # ln --symbolic --target-directory $HOME $SCRIPTDIR/$FILE
	ln -s $SCRIPTDIR/$FILE $HOME
    else
        echo "$SCRIPTNAME: $FILE already linked"
    fi
done


### TeX
cd $dotfile_dir
texfiles=$(find tex/latex -name "*.cls" -o -name "*.sty")
bstfiles=$(find bibtex/bst -name "*.bst")

if not_installed kpsewhich; then
    echo "${red}Didn't link TeX files: make sure /Library/TeX/texbin is in PATH and re-run init.sh${normal}"
else
    texdir=$(kpsewhich -var-value=TEXMFHOME)
    maybe_mkdir "$texdir"

    # Style and class files
    maybe_mkdir "$texdir/tex/latex"
    cd "$texdir"
    for file in $texfiles; do
	echo "style and class files"
        echo "$file"
	echo "source: $texdir/tex/latex/"
        try_symlink "$texdir/tex/latex" "$file"
    done

fi

### Beamer Template
# See https://github.com/matze/mtheme for instructions
if [ ! -d "$HOME/mtheme" ];
then
    git clone https://github.com/matze/mtheme.git $HOME/mtheme/
    cwd=$(pwd)
    cd $HOME/mtheme
    make sty
    make install

    cd $cwd

fi
