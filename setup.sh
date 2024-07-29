#!/usr/bin/env bash

OS=""
WORK_STORAGE_UUID=""
IS_MOUNTED_WORK_STORAGE=0
EXISTS_NVM=0
EXISTS_PYENV=0
EXISTS_JENV=0

function print_i() {
	RED="\033[0;31m";
	YELLOW="\033[0;33m";
	GREEN="\033[0;32m";
	BLUE="\033[0;34m";
	NC="\033[0m";
	echo -e "${BLUE}[I]($LINENO): $@";
}

function print_w() {
	RED="\033[0;31m";
	YELLOW="\033[0;33m";
	GREEN="\033[0;32m";
	BLUE="\033[0;34m";
	NC="\033[0m";
	echo -e "${YELLOW}[W]($LINENO): $@";
}

function print_e() {
	RED="\033[0;31m";
	YELLOW="\033[0;33m";
	GREEN="\033[0;32m";
	BLUE="\033[0;34m";
	NC="\033[0m";
	echo -e "${RED}[E]($LINENO): $@";
}

function print_d() {
	RED="\033[0;31m";
	YELLOW="\033[0;33m";
	GREEN="\033[0;32m";
	BLUE="\033[0;34m";
	NC="\033[0m";
	echo -e "${GREEN}[D]($LINENO): $@";
}

function check_installed_brew() {
	if [ "$OS" = "Mac OS" ]; then
		if [ -x "$(command -v brew)" ]; then
			EXISTS_BREW=1;
		else
			print_w "[Checked] Brew is not installed";
			EXISTS_BREW=0;
		fi;
	else
		print_e "[Checked] Brew is only supported on Mac OS";
		EXISTS_BREW=0;
	fi;
}

function install_brew() {
	if [ $EXISTS_BREW -eq 0 ]; then
		if [ "$OS" = "Mac OS" ]; then
			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
		else
			print_e "[Install] Brew is only supported on Mac OS";
		fi;
	else
		print_w "[Install] Brew is already installed";
	fi;

	# Update
	check_installed_brew;
}

function setup_brew() {
	if [ $EXISTS_BREW -eq 1 ]; then
		if [ "$OS" = "Mac OS" ]; then
			eval "$(/opt/homebrew/bin/brew shellenv)";
		else
			print_e "[Setup] Brew is only supported on Mac OS";
		fi;	
	else
		print_e "[Setup] Brew is not installed";
	fi;
}

function check_installed_nvm() {
	if [ "$OS" = "Mac OS" ]; then
		if [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]; then
			EXISTS_NVM=1;
		else
			print_w "[Checked] NVM is not installed";
			EXISTS_NVM=0;
		fi;
	elif [ "$OS" = "Linux" ]; then
		if [ -s "$HOME/.nvm/nvm.sh" ]; then
			EXISTS_NVM=1;
		else
			print_w "[Checked] NVM is not installed";
			EXISTS_NVM=0;
		fi;
	else
		print_e "[Checked] NVM is only supported on Mac OS and Linux";
		EXISTS_NVM=0;
	fi;
}

function install_nvm() {
	if [ $EXISTS_BREW -ne 0 ] && [ $EXISTS_NVM -eq 0 ]; then
		if [ "$OS" = "Mac OS" ]; then
			brew install nvm;
		elif [ "$OS" = "Linux" ]; then
			curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
		else
			print_e "[Install] NVM is only supported on Mac OS and Linux";
		fi;
	else
		print_e "[Install] NVM is already installed";
	fi;

	check_installed_nvm;
}

function setup_nvm() {
	if [ $EXISTS_NVM -eq 1 ]; then
		if [ "$OS" = "Mac OS" ]; then
			export NVM_DIR="$HOME/.nvm"
			[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
			[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
		elif [ "$OS" = "Linux" ]; then
			export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
			[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
		else
			print_e "[Setup] NVM is only supported on Mac OS and Linux";
		fi;
	else
		print_e "[Setup] NVM is not installed";
	fi;
}

function check_installed_pyenv() {
	if [ "$OS" = "Mac OS" ] || [ "$OS" = "Linux" ]; then
		if [ -s "$HOME/.pyenv" ]; then
			EXISTS_PYENV=1;
		else
			EXISTS_PYENV=0;
			print_w "[Checked] Pyenv is not installed";
		fi;
	else
		EXISTS_PYENV=0;
		print_e "[Checked] Pyenv is only supported on Mac OS and Linux";
	fi;
}

function install_pyenv() {
	if [ "$EXISTS_BREW" -eq 1 ] && [ "$EXISTS_PYENV" -eq 0 ]; then
		if [ "$OS" = "Mac OS" ]; then
			brew install pyenv;
		elif [ "$OS" = "Linux" ]; then
			curl https://pyenv.run | bash
		else
			print_e "[Install] Pyenv is only supported on Mac OS and Linux";
		fi;
	else
		print_e "[Install] Pyenv is already installed";
	fi;

	check_installed_pyenv;
}

function setup_pyenv() {
	if [ $EXISTS_PYENV -eq 1 ]; then
		if [ "$OS" = "Mac OS" ] || [ "$OS" = "Linux" ]; then
			export PYENV_ROOT="$HOME/.pyenv"
			command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
			eval "$(pyenv init -)"
		else
			print_e "[Setup] Pyenv is only supported on Mac OS and Linux";
		fi;
	else
		print_e "[Setup] Pyenv is not installed";
	fi;
}

function check_installed_jenv() {
	if [ "$OS" = "Mac OS" ] || [ "$OS" = "Linux" ]; then
		if [ -s "$HOME/.jenv" ]; then
			EXISTS_JENV=1;
		else
			print_w "[Checked] Jenv is not installed";
			EXISTS_JENV=0;
		fi;
	else
		print_e "[Checked] Jenv is only supported on Mac OS and Linux";
		EXISTS_JENV=0;
	fi;
}

function install_jenv() {
	if [ "$EXISTS_BREW" -eq 1 ] && [ "$EXISTS_JENV" -eq 0 ]; then
		if [ "$OS" = "Mac OS" ]; then
			brew install jenv;
		elif [ "$OS" = "Linux" ]; then
			git clone https://github.com/jenv/jenv.git ~/.jenv;
		else
			print_e "[Install] Jenv is only supported on Mac OS and Linux";
		fi;
	else
		print_e "[Install] Jenv is already installed";
	fi;

	check_installed_jenv;
}

function setup_jenv() {
	if [ $EXISTS_JENV -eq 1 ]; then
		if [ "$OS" = "Mac OS" ] || [ "$OS" = "Linux" ]; then
			export PATH="$HOME/.jenv/bin:$PATH";
			eval "$(jenv init -)";
			jenv add /opt/homebrew/opt/openjdk@*/libexec/openjdk.jdk/Contents/Home > /dev/null
		else
			print_e "[Setup] Jenv is only supported on Mac OS and Linux";
		fi;
	else
		print_e "[Setup] Jenv is not installed";
	fi;
}

function set_my_alias() {
	if [ "$OS" = "Mac OS" ]; then
		alias tar='gtar --exclude ".svn" '
		alias sed='/opt/homebrew/bin/gsed '
		alias patch='/opt/homebrew/bin/patch '
		alias diff='/opt/homebrew/bin/diff '
		alias gcc='/opt/homebrew/bin/gcc-13 '
	elif [ "$OS" = "Linux" ]; then
		alias tar='tar --exclude ".svn" '
	fi;

	# Common alias
	alias ls='ls --color=auto'
	alias grep='grep --color=always'
	alias vi='nvim '
	alias vimdiff='nvim -d '
	alias mysql='mysql --defaults-file=$HOME/.mysql_cred '
	alias mysqldump='mysqldump --defaults-file=$HOME/.mysql_cred '
}

# Check OS
if [ "$(uname)" = "Darwin" ]; then
	OS="Mac OS";
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
	OS="Linux";
elif [ "$(expr substr $(uname -s) 1 10)" = "MINGW32_NT" ]; then
	echo "Windows is not supported";
	exit 1;
fi

echo "OS: $OS"

