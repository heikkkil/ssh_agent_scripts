#!/bin/bash

# ssh start
sshs () {
        # Absolute path to private keys
        PKPATH="$HOME/.ssh"
        if [ "$#" -lt 1 ]; then
                if [ ! -e $SSH_AUTH_SOCK ] || [ -z ${SSH_AUTH_SOCK+x} ]; then
                        eval `ssh-agent`;
		else
			echo "ssh-agent already running"
		fi
        else
                if [ ! -e $SSH_AUTH_SOCK ] || [ -z ${SSH_AUTH_SOCK+x} ]; then
                        eval `ssh-agent`;
                fi
                for KEY in $@
                do
                        ssh-add $PKPATH$KEY
                done
        fi
}

# ssh end
sshe () {
        if [ -e $SSH_AUTH_SOCK ]; then
                sshk
        fi
        hangssh
}

# Just kill regardless of the existing agent
sshkill () { eval `ssh-agent -k`; }

# Kill all ssh agents
sshk () (
	# Kill currently iterated pid
        searchkill () (
                export SSH_AGENT_PID=$1
                eval `ssh-agent -k`;
                echo "ssh agent killed"
        )
	# Count of ssh-agent processes
	PSCOUNT=$(pgrep -f ssh-agent | wc -l)
        if [ $PSCOUNT -ne 0 ]; then
                for AGENT in $(pidof ssh-agent | awk '{print $0;}'); do
                        searchkill $AGENT &
                        sleep .5
                        kill $! >/dev/null 2>&1
                done
        fi
)

# Check for hanging ssh sockets
hangssh () {
	# System's tmp directory
	SOCKTMPDIR="$(dirname $(mktemp -u))/"
	# Count of ssh-agent processes
        PSCOUNT=$(pgrep -f ssh-agent | wc -l)
	# Number of ssh sockets
	SOCKN=$(($(ls -l $SOCKTMPDIR | grep ssh-* | wc -l)-$PSCOUNT))

	if [ $PSCOUNT -gt 1 ]; then
		echo "Warning: $PSCOUNT ssh-agent(s) running, $(($PSCOUNT-1)) \
will propably be left hanging."
	fi

	# Path for warning message file
	WMSGFPATH="$HOME/HANGING_SSH"

	if [ $SOCKN -gt 0 ]; then
		# Generate a warning message and a warning message file
		WMSG="Warning: $SOCKN hanging socket(s) at $SOCKTMPDIR"
                touch $WMSGFPATH
                echo $WMSG > $WMSGFPATH
                echo $WMSG
		# Prompt for ssh socket removal
		rmhangssh
        else
		# Remove warning message file
                if [ -f $WMSGFPATH ]; then
                        rm $WMSGFPATH
                fi
        fi
}

# Remove all ssh sockets
rmhangssh () (
	# System's tmp directory
	SOCKTMPDIR="$(dirname $(mktemp -u))/"
	# Pattern for ssh-socket directory
	SSHSOCKDPATT="ssh-*"

	rmsockets() (
		if [ ! -e $SSH_AUTH_SOCK ] || [ -z ${SSH_AUTH_SOCK+x} ]; then
			rm -rf $SOCKTMPDIR$SSHSOCKDPATT;
		else
			ACTIVESOCK=$(echo $SSH_AUTH_SOCK | awk -F '[/]' \
				'{print $3}')
			mv $SOCKTMPDIR$ACTIVESOCK active_ssh_socket_backup;
			rm -rf $SOCKTMPDIR$SSHSOCKDPATT;
			mv active_ssh_socket_backup $SOCKTMPDIR$ACTIVESOCK;
		fi
	)
	# Prompt y/n for removal, defaults to y
	while true; do
		read -p "Do you wish to remove all hanging ssh sockets at \
$TMPDIR? [Y/n] " yn
		case "${yn:-Y}" in
			[Yy]* ) rmsockets; break;;
			[Nn]* ) return 0 ;;
			* ) echo; ;;
		esac
	done

	# Verify removal
	if [ $(ls -l $SOCKTMPDIR | grep $SSHSOCKDPATT | wc -l) -eq 0 ]; then
		echo "Done"
	else
		if [ ! -e $SSH_AUTH_SOCK ] || [ -z ${SSH_AUTH_SOCK+x} ]; then
			echo "Couldn't remove ssh sockets from $SOCKTMPDIR"
		else
			echo "done"
		fi
	fi
)
