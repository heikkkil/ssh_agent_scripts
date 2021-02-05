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
  
# Functions

## sshs
Start ssh-agent.  

Usage: `sshs [private_key ...]`  

private_key is the name of the file which will be appended to the default key directory path. By default the private key directory path is set to `$HOME/.ssh/`. The default path can be changed by editing the function's variable PKPATH value. The given keys will be added to the ssh-agent with ssh-add. Multiple private keys can be given.  

If no private key arguments were give, the ssh-agent will be started with no added keys. The function won't start new ssh-agent processes if there is an existing one. 
  
## sshe
End ssh-agent.  
  
Usage: `sshe`  
  
todo  
  
## sshk
Kill all ssh-agents.  
  
Usage: `sshk`  
  
todo  
  
## sshkill  
Just kill regardless of the ssh-agent's existance.  
  
Usage: `sshkill`  
  
todo  
  
## hangssh  
Check for hanging ssh sockets.
  
Usage: `hangssh`  
  
todo  

## rmhangssh  
Prompt for removing hanging ssh sockets.  
  
Usage: `rmhangssh`  
  
todo
  
  
# TODO:  
- Fix randomly occuring [process exited with code 1] (something to do with subshells?)
- readme
