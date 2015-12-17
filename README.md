# configFiles

.bashrc, .emacs, .tmux.conf, etc.

## Setup

When cloning this repo to a new server, I use symlinks to redirect the
system to these files. This allows me to update this file on one
system, commit, and pull from another machine without worrying about
copy/pasting. 

To set up symlinks, see the example below:

```bash
cd 
ln -s /path/to/configFiles/.tmux.conf .tmux.conf
```

## Attribution

Thanks to Micah Smith and Matt Cocci for the majority of the useful stuff here.
