# SSH agent scripts
Bash functions for easier ssh_agent handling

Tested on Debian 10 on WSL2 with GNU bash, version 5.0.3(1)-release (x86_64-pc-linux-gnu).
  
  
## Prequisites  
- ssh client (includes the ssh-agent)  
  `sudo apt install openssh-client`  
- bash  
  `sudo apt install bash`  
  
## Installation  
Download the ssh_agent_functions.sh script file directly or clone the repository.  
`git clone https://github.com/heikkkil/ssh_agent_scripts.git`  
  
Source the script file at your .bashrc file.  
`echo "source path_to_script_file/ssh_agent_functions.sh" >> $HOME/.bashrc`  
    
## Uninstall  
Remove the ssh_agent_functions.sh file sourcing from your .bashrc file.  
  
  
# Usage  
TODO  

# Functions

## sshs
Start ssh-agent.  

Usage: sshs [private_key ...]  

private_key is the name of the file which will be appended to the default key directory path. By default the private key directory path is set to `$HOME/.ssh/`. The given keys will be added to the ssh-agent with ssh-add. Multiple private keys can be given.  

If no private key arguments were give, the ssh-agent will be started with no added keys. The function won't start new ssh-agent processes if there is an existing one. 
  
## sshe
  
  
## sshk
  
  
## hangssh  
  
  
## rmhangssh  
  
  
Continues...  
  
# TODO:  
- Fix randomly occuring [process exited with code 1] (something to do with subshells?)
- readme
