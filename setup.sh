# Erica Moszkowski
# setup.sh
#   Set up all my configs: Downloads emacs plugins and modes, bash git
#   prompt, and creates symlinks of relevant dot files in home directory

SCRIPTNAME=$(basename $0)
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

### Todo: download brew if on mac and I don't have it already

# define contains function; this is important for later
# usage: contains aList anItem
contains() {
    [[ $1 =~ (^|[[:space:]])$2($|[[:space:]]) ]] && exit(0) || exit(1)
}

# OSX specific installs
case $OSTYPE in
    darwin*) # OS X

	# install brew and other useful things
	if [ ! "$(which brew)" == "/usr/local/bin/brew" ];
	then
	    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

	    brew install wget
	    brew install rename
	fi

	emacs_version="$(emacs --version | head -n 1 | awk '{print $NF}')"
	bad_emacs_version="22."
	if [ emacs_version == *"$bad_emacs_version"* ];
	then
	    # remove old version of emacs
	    sudo rm /usr/bin/emacs
	    sudo rm -rf /usr/share/emacs

	    # install new version of emacs
	    brew cask install emacs
	fi


	casks="$(brew cask list)"

	# LaTeX and LaTeX software
	if [ ! contains casks mactex ];
	then
	    brew cask install mactex
	fi
	if [ ! contains casks lyx ];
	then
	   brew cask install lyx
	fi

	# Dropbox
	if [ ! contains casks dropbox ]
	then
	    brew cask install dropbox
	fi

	# Julia
	if [ ! contains casks julia ]
	then
	    brew cask install julia
	fi

	# R
	if brew ls --versions r > /dev/null; then
	    # The package is installed
	else
	    # The package is not installed
	    brew install r
	fi

	if [ ! contains casks rstudio ]
	then
	    brew cask install rstudio
	fi

	# Meld
	if [ ! contains casks meld ]
	then
	    brew cask install caskroom/cask/meld
	fi


	# Tmux
	if brew ls --versions tmux > /dev/null; then
	    # The package is installed
	else
	    # The package is not installed
	    brew install tmux
	fi

	if [ ! ~/usr/local/bin/ipython ]

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
    if [ ! -h "$HOME/$FILE" ];
    then
        # ln --symbolic --target-directory $HOME $SCRIPTDIR/$FILE
	ln -s $SCRIPTDIR/$FILE $HOME
    else
        echo "$SCRIPTNAME: $FILE already linked"
    fi
done
