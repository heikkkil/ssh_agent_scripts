# SSH agent scripts
Bash functions for easier ssh_agent handling

Tested on Debian 10 on WSL2 with GNU bash, version 5.0.3(1)-release (x86_64-pc-linux-gnu).

# Functions

## sshs
Start ssh-agent.  

Usage: sshs [private_key ...]  

private_key is the name of the file which will be appended to the default key directory path. By default the private key directory path is set to `$HOME/.ssh/`. The given keys will be added to the ssh-agent with ssh-add. Multiple private keys can be given.  

If no private key arguments were give, the ssh-agent will be started with no added keys. The function won't start new ssh-agent processes if there is an existing one. 
  
## sshe


Continues...


# TODO:  
- Fix randomly occuring [process exited with code 1] (something to do with subshells?)
- readme
