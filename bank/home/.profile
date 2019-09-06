export EDITOR=/usr/bin/vim
export QT_QPA_PLATFORMTHEME="qt5ct"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export PATH=$PATH:~/dev/scripts/bash:~/dev/tools/rtags/ninja_build/bin

# Change language to polish
setxkbmap pl

# Theme recovery
~/.local/bin/wal -R > /dev/null

# Remove invalid steam path symlink
rm -f ~/.steampath

# Invoke ssh-agent so that I don't need to enter 
# passphrase every time I want to commit
eval $(ssh-agent)
