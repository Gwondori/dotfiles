#!/usr/bin/env bash

TOP_DIR=$(cd $(dirname "$0") && pwd);
CURRENT_SHELL=$(echo $SHELL | awk -F '/' '{print $NF}');

if [ $CURRENT_SHELL = "bash" ]; then
	if [ -f $HOME/.bashrc ]; then
		mv $HOME/.bashrc $HOME/.bashrc.$(date +%Y%m%d%H%M%S);
	fi;
	ln -s $TOP_DIR/scripts/core.sh $HOME/.bashrc;
elif [ $CURRENT_SHELL = "zsh" ]; then
	if [ -f $HOME/.zshrc ]; then
		mv $HOME/.zshrc $HOME/.zshrc.$(date +%Y%m%d%H%M%S);
	fi;
	ln -s $TOP_DIR/scripts/core.sh $HOME/.zshrc;
else
	echo "Unsupported shell: $CURRENT_SHELL";
	exit 1;
fi;

PATH_MY_NVIM_CONFIG="$TOP_DIR/configs/nvim";

## If exists neovim, use neovim
if [ ! -x "$(command -v nvim)" ]; then
	## Install neovim
	if [ -x "$(command -v apt-get)" ]; then
		sudo apt-get install -y neovim;
	elif [ -x "$(command -v dnf)" ]; then
		sudo dnf install -y neovim;
	elif [ -x "$(command -v yum)" ]; then
		sudo yum install -y neovim;
	elif [ -x "$(command -v brew)" ]; then
		brew install neovim;
	else
		echo "Unsupported package manager";
		exit 1;
	fi;
fi;

## Install VimPlug
if [ ! -f $HOME/.config/nvim/autoload/plug.vim ]; then
	curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim;
fi;

if [ -d $HOME/.config/nvim ]; then
	mv $HOME/.config/nvim $HOME/.config/nvim.$(date +%Y%m%d%H%M%S);
fi;

ln -s $PATH_MY_NVIM_CONFIG $HOME/.config/nvim;

echo "Install successfully! Please restart your shell.";

