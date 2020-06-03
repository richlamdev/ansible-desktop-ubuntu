#!/bin/bash
# Quickly import vimrc and customize bash prompt PS1 environment variable.

dconf load / < dconf-settings.ini

cp .vimrc ~/.vimrc
#echo 'export PS1="\A \[\e[31m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\]:[\[\e[33m\]\w\[\e[m\]]\\$ "' >> ~/.bashrc
echo 'export PS1="\A \[$(tput sgr0)\]\[\033[38;5;11m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;12m\]\h\[$(tput sgr0)\]:[\[$(tput sgr0)\]\[\033[38;5;14m\]\w\[$(tput sgr0)\]]\\$\[$(tput sgr0)\]"' >> ~/.bashrc

source ~/.bashrc
