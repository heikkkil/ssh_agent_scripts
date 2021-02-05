#!/bin/bash

# ssh start
sshs () {
        # Absolute path to private keys
        PKPATH="$HOME/.ssh"
        if [ "$#" -lt 1 ]; then
                if [ ! -e $SSH_AUTH_SOCK ] || [ -z ${SSH_AUTH_SOCK+x} ]; then
                        eval `ssh-agent`;
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
        searchkill () (
                export SSH_AGENT_PID=$1
                eval `ssh-agent -k`;
                echo "ssh agent killed"
        )
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
        SOCKN=$(ls -l /tmp/ | grep ssh-* | wc -l)
        WMSGFPATH="$HOME/HANGING_SSH"
        if [ $SOCKN -gt 0 ]; then
                WMSG="Warning: $SOCKN hanging sockets at /tmp/"
                touch $WMSGFPATH
                echo $WMSG > $WMSGFPATH
                echo $WMSG
        else
                if [ -f $WMSGFPATH ]; then
                        rm $WMSGFPATH
                fi
        fi
}
