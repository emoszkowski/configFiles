### Bash setup 


# Setup git-aware-prompt 
if [ ! -d ~/.bash/git-aware-prompt ]; 
then 
    mkdir -p ~/.bash/git-aware-prompt 
     git clone https://github.com/jimeh/git-aware-prompt.git ~/.bash/git-aware-prompt 
 else 
     echo "$SCRIPTNAME: git-aware-prompt already installed" 
fi 
