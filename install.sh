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
