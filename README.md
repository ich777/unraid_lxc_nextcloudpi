# NextcloudPi LXC container installer for unRAID

<p align="center">
  <img src="https://github.com/nextcloud/nextcloudpi/blob/master/ncp-app/img/app.svg"
       width="120"
       height="85"
       alt="NextcloudPi logo">
</p>

## What this is
This is a helper install script to install NextcloudPi from: https://github.com/nextcloud/nextcloudpi on unRAID

## Prerequisites

- unRAID server
- Properly configured and installed LXC plugin for unRAID
- Basic understanding of command line usage

## Installation
1. Open up a Unraid terminal
2. Execute this command in the terminal:  
```
bash -c "$(wget -qO- https://raw.githubusercontent.com/ich777/unraid_lxc_nextcloudpi/master/nextcloudpi.sh)"
```
3. Follow the on screen prompts
4. When done close the terminal
5. Refresh the LXC page within unRAID
6. Start the container
7. Open up the WebUI by clicking the container Icon and `WebUI`

After everything is done it should leave you with a container looking something like this:
![grafik](https://github.com/user-attachments/assets/ff071bfa-19e7-404c-af50-2a0606a501f5)
