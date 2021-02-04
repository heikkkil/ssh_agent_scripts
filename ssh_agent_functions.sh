# ssh start
# For other users of the function, define your private key path for ssh-add on line 14.
sshs () {
if [ "$#" -lt 1 ]; then
        if [ ! -S $SSH_AUTH_SOCK ]; then
                eval `ssh-agent`;
        fi
else
        if [ ! -S $SSH_AUTH_SOCK ]; then
                eval `ssh-agent`;
        fi
        for key in $@
        do
                ssh-add ~/.ssh/$key
        done
fi
}

# ssh end
sshe () {
if [ -S $SSH_AUTH_SOCK ]; then
        sshk
fi
}

# Just kill regardless of the existing agent
sshkill () { eval `ssh-agent -k`; }

# ssh kill
sshk () (
        searchkill () (
                #export SSH_AGENT_PID=$(pidof ssh-agent | awk '{print $1;}')
                export SSH_AGENT_PID=$1
                eval `ssh-agent -k`;
                echo "ssh agent killed"
        )
        PSCOUNT=$(pgrep -f ssh-agent | wc -l)
        if [ $PSCOUNT -ne 0 ]; then
                #for i in {1..$PSCOUNT} #not working
                for AGENT in $(pidof ssh-agent | awk '{print $0;}'); do
                        searchkill $AGENT &
                        sleep .5
                        kill $! >/dev/null 2>&1
                done
        fi
        unset SSH_AGENT_PID
        unset SSH_AUTH_SOCK
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
)
