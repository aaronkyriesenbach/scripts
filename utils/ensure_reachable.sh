#!/bin/zsh

# Ensure every host passed as an argument is reachable
ensure_reachable () {
	for host in "$@"; do
		ping $host -c 1 &> /dev/null || {
			echo "Unable to reach host $host. Is a VPN connection needed?"
			exit 1
		}
	done
}
