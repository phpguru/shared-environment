# Shared Environment (shenv)

## Overview

The shared environment consists of 

- Bash shortcuts - aliases and custom functions
- Docker shortcuts - aliases and custom functions
- Git completion - to make common git commands faster in terminal
- Git prompt - to make git branch name tab completion and bash prompt better

## Usage

1. Clone the repository to ~/.shenv, 
1. Set the DOCKER_HOME environment variable to /home/<YOUR-USER>/Projects/AdviNow/docker-development
1. Add the below code to your ~/.bashrc (Linux) or ~/.bash_profile (Mac)
1. Reload your terminal or `source ~/.bashrc`

```
for file in ~/.shenv/*.sh;
do
    source $file
done
```

## VPN Shortcuts

1. Make sure you are using [openvpn3](https://openvpn.net/cloud-docs/openvpn-3-client-for-linux/)
1. Run `mkdir -p ~/.openvpn3`
1. Download your VPN profile from [here](https://cloudconnect.advinow.net:943/)
1. Save it into `~/.openvpn3` folder and name it `advinow.conf`
1. Edit `~/.openvpn3/advinow.conf`
1. Add the following line `auth-user-pass auth.txt` around line 42
1. Create the file `~/.openvpn3/auth.txt` and inside it make line 1 your VPN username and line 2 your VPN password
1. You should now be able to use the following shortcuts

```
vpnu   // VPN Up
vpnd   // VPN Down
vpnr   // VPN reset
vpns   // VPN Status
vpnk   // VPN Kill
```

