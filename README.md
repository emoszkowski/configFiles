# configFiles

.bashrc, .zshrc, .emacs, .tmux.conf, ghostty, zellij, etc.

## Setup

When cloning this repo to a new machine, run `setup.sh /path/to/configFiles`
to install packages (Homebrew, ESS, Julia/MATLAB/YAML Emacs modes, oh-my-zsh,
...) and to symlink the config files into your home directory:

``` bash
git clone git@github.com:emoszkowski/configFiles.git ~/configFiles
cd ~/configFiles
./setup.sh ~/configFiles
```

Symlinks created:

| Repo file            | Links to                       |
|----------------------|--------------------------------|
| `.bashrc`            | `~/.bashrc`                    |
| `.zshrc`             | `~/.zshrc`                     |
| `.emacs`             | `~/.emacs`                     |
| `.tmux.conf`         | `~/.tmux.conf`                 |
| `.gitconfig`         | `~/.gitconfig`                 |
| `.gitignore_global`  | `~/.gitignore_global`          |
| `ghostty/config`     | `~/.config/ghostty/config`     |
| `zellij/config.kdl`  | `~/.config/zellij/config.kdl`  |

`setup.sh` will not clobber an existing regular file -- if a config already
exists at the destination as a real file, merge it into the repo copy and
delete it before re-running.

## Shell

`.zshrc` assumes [oh-my-zsh](https://ohmyz.sh/) (installed by `setup.sh`) and
uses the `git`, `z`, and `virtualenv` plugins. The git prompt and completions
come from oh-my-zsh, so there is no hand-rolled prompt config here.

## Machine-specific config (not in this repo)

`.zshrc` sources these if they exist. Keep anything machine-specific or secret
in them rather than in this repo:

| File               | For                                        |
|--------------------|--------------------------------------------|
| `~/.paths`         | `PATH` entries and env vars for this box   |
| `~/.aliases`       | Aliases that only make sense on this box   |
| `~/.anthropic_env` | Anthropic / Claude API key                 |

## LaTeX

Copy each file in `tex/latex/` into its own directory of the same name in your
local texmf directory (where TeX searches for local .sty and .cls files):

``` bash
TEXMF=$(kpsewhich -var-value=TEXMFHOME)
mkdir -p $TEXMF/tex/latex/{mystyle,mybeamer,myarticle}
cp tex/latex/mystyle.sty   $TEXMF/tex/latex/mystyle
cp tex/latex/myarticle.sty $TEXMF/tex/latex/myarticle
cp tex/latex/mybeamer.sty  $TEXMF/tex/latex/mybeamer
```

## Emacs modes

`setup.sh` clones these into `~/.emacsconfig/` (not into this repo): ESS,
julia-emacs, julia-repl, anaphora, markdown-mode, matlab-mode, yaml-mode.

## Attribution

Thanks to Matt Cocci, Micah Smith, and Pearl Li for the majority of the useful stuff here.
