#!/bin/zsh

# Ensure every command passed as an argument is installed
ensure_installed () {
	for cmd in "$@"; do
		if ! command -v $cmd &> /dev/null; then
			echo "$cmd not installed"
			exit 1
		fi
	done
}
