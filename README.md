# ssh_agent_functions.sh
Bash functions for easier ssh_agent handling.  
  
While ssh-agent being a great tool for handling public key authentication for your sessions it can sometimes be problematic if used incorrectly. Especially, at exit the ssh-agent can remain hanging with the private keys loaded in your system's temporary files directory if it isn't killed accordingly. Proper usage requires quite a lot of extra typing on the keyboard afterall.  
However, this collection of functions will help you semi-automate most of the steps required for proper ssh-agent usage while reducing the amount of typing on the keyboard and yet doing it error-proofly.  
  
The script includes functions for ssh-agent starting with private key loading, ending and hanging socket cleanup.  
  
Tested on Debian 10 on WSL2 with GNU bash, version 5.0.3(1)-release (x86_64-pc-linux-gnu).  
  
  
## Prequisites  
- ssh client (includes the ssh-agent)  
  `sudo apt install openssh-client`  
- bash  
  `sudo apt install bash`  
  
## Installation  
Download the ssh_agent_functions.sh script file directly or clone the repository.  
`git clone https://github.com/heikkkil/ssh_agent_scripts.git`  
  
Source the script file at your .bashrc file. E.g:  
`echo "source path_to_script_file/ssh_agent_functions.sh" >> $HOME/.bashrc`  
  
## Uninstall  
Remove the ssh_agent_functions.sh file and it's sourcing from your .bashrc file. Also, remove any related function call from other script files if used.
  
  
# Usage  
The functions of the sourced ssh_agent_functions.sh can be used independently or by calling them in appropriate bash or session control files.  

For example, lets assume you've got two ssh private keys and they reside at $HOME/.ssh/ directory and they are called gh and pi4.  
  
To start the ssh-agent and load your private key(s) to it, call:  
`sshs gh pi4`  
A plain call for for sshs without arguments will just start an ssh-agent process without any keys loaded in. To change the default path of the private keys edit the function's *PKPATH* value in the ssh_agent_functions.sh file.  
  
To end the ssh-agent with automatic check for any hanging ssh sockets and possibly prompt for their removal, call:  
`sshe`  
A handy way is to call the sshe function at the optional .bash_logout (or similar) bash script file which will be ran at bash logout.  
  
To just kill all ssh-agent processes accordingly (even the ones which are not bound to ssh socket), call:  
`sshk`  
This is used by the sshe function.  
  
To just kill the *currently running* ssh-agent accordingly, call:  
`sshkill`
  
To check for hanging ssh sockets separately, call:  
`hangssh`  
If any hanging sockets are found, it prompts you for their removal while leaving a possibly active socket untouched.  
  
To just remove all hanging ssh sockets from the system's temporary file directory, call:  
`rmhangssh`  
  
# Function documentation

## sshs
Start ssh-agent.  

Usage: `sshs [private_key ...]`  

The private_key parameters are the names of the private key files which will be appended to the default key directory path. By default the private key directory path is set to $HOME/.ssh/. The default path can be changed by editing the function's variable PKPATH value. The given keys will be added to the ssh-agent with ssh-add. Multiple private keys can be given.  

If no private key arguments were give, the ssh-agent will be started with no added keys. The function won't start new ssh-agent processes if there is an existing one. In that case a notification will be echoed to stdout.  
  
The existing ssh-agent is tested against the ssh-socket's existance pointed by SSH_AUTH_SOCK variable. Also, during startup ssh-agent is considered not to exist if the SSH_AUTH_SOCK variable is empty. Therefore, unsetting the SSH_AUTH_SOCK variable despite a running ssh-agent can lead to faulty behaviour. For future, additional test for running ssh-agent processes should be added.  
  
## sshe
End ssh-agent.  
  
Usage: `sshe`  
  
If ssh-socket pointed by SSH_AUTH_SOCK variable exists, the sshk function will be called to kill all running ssh-agents accordingly. Wheter ssh-agents killed or not, hangssh function will be called to check for hanging ssh-sockets with a possible prompt for their removal. Yet again, unsetting the SSH_AUTH_SOCK variable despite a running ssh-agent can lead the process to fall through the hanging socket check. For future, additional test for running ssh-agent processes should be added.  
  
## sshk
Kill all ssh-agents.  
  
Usage: `sshk`  
  
Extracts all ssh-agent processes and iterates throught them to export their pids to the SSH_AGENT_PID in order to kill them correctly. Succesful kill for each process will be echoed to stdout. However, if the number of ssh-agent processes are 0 nothing will be done and nothing will be echoed.  
  
## sshkill  
Just kill current ssh-agent regardless of it's existance.  
  
Usage: `sshkill`  
  
Simple wrapper function for the eval \`ssh-agent -k\` command.  
  
## hangssh  
Check for hanging ssh sockets and prompt for their removal.  
  
Usage: `hangssh`  
  
Checks for all hanging ssh sockets directories at your system's temporary file directory and informs by echoing to stdout if any were found. In addition to the warning message a warning message file called HANGING_SSH will be created to $HOME directory as a reminder. Then rmhangssh function will be called to prompt for the possible removal of the hanging ssh sockets. The prompt defaults to yes (remove hangning ssh sockets). In this case the warning message file will be removed automatically without a separate notice if no hangning ssh sockets are found remaining after their removal.  
  
The check counts all hanging ssh socket directories against a pattern. A possibly active ssh socket will remain uncounted and in case of removal, it will also remain. The method for removing all but the active ssh socket directories makes a temporary backup of the active socket directory and rolls it back after removing the others. This method didn't seem to interrup any idle connections. Still the function should be used with caution (don't use) if any traffic is happening via ssh at the moment.  
  
Also, a warning is echoed to stdout about potentially to-be-hanged ssh-agent processes will be given if number of ssh-agent processes is over one.  
  
## rmhangssh  
Prompt for removing hanging ssh sockets.  
  
Usage: `rmhangssh`  
  
Basic y/n prompt for removing all hanging ssh socket directories from yout system's temporary file directory. The prompt defaults to yes. The function doesn't remove a possibly active ssh-socket.  
  
The function is meant to be used in the end of the hangssh function and thereby it isn't aware of the actual ssh-socket directory count.  
  
