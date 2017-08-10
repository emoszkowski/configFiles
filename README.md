# configFiles

.bashrc, .emacs, .tmux.conf, etc.

## Setup

When cloning this repo to a new server, run `setup.sh` to install
packages (ESS, Julia Emacs mode, etc) and to set up symlinks from my
home directory to the local copy of this repo.

You will need to copy each file in `tex/latex/` into its own directory
of the same name in your local texmf directory (the place where Emacs
searches for your local .sty and .cls files). You can do this as follows:

``` bash
TEXMF=$(kpsewhich -var-value=TEXMFHOME)
cd TEXMF
mkdir -R tex/latex/{mystyle,mybeamer,myarticle}
cp /path/to/configFiles/tex/latex/mystyle.sty $TEXMF/tex/latex/mystyle
cp /path/to/configFiles/tex/latex/myarticle.sty $TEXMF/tex/latex/myarticle
cp /path/to/configFiles/tex/latex/mybeamer.sty $TEXMF/tex/latex/mybeamer
```

## Attribution

Thanks to Matt Cocci, Micah Smith, and Pearl Li for the majority of the useful stuff here.
