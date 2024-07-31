#!/usr/bin/env bash

TOP_DIR=$(cd $(dirname "$0") && pwd);
CURRENT_SHELL=$(echo $SHELL | awk -F '/' '{print $NF}');

if [ $CURRENT_SHELL = "bash" ]; then
	ln -s $TOP_DIR/.core.sh $HOME/.bashrc;
elif [ $CURRENT_SHELL = "zsh" ]; then
	ln -s $TOP_DIR/.core.sh $HOME/.zshrc;
else
	echo "Unsupported shell: $CURRENT_SHELL";
	exit 1;
fi;
