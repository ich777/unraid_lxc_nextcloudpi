# NextcloudPi LXC container archive for unRAID

<p align="center">
  <img src="https://github.com/nextcloud/nextcloudpi/blob/master/ncp-app/img/app.svg"
       width="120"
       height="85"
       alt="NextcloudPi logo">
</p>

## Prerequisites

- unRAID server
- Properly configured and installed LXC plugin for unRAID
- Basic understanding of command line usage

## Container archive contents

- NextcloudPi from https://github.com/nextcloud/nextcloudpi  
  (please refer to the [README.md](https://github.com/nextcloud/nextcloudpi/blob/master/README.md) from NextcloudPi for the exact contents, the container archive is built from the official NextcloudPi installation script that you can review [here](https://raw.githubusercontent.com/nextcloud/nextcloudpi/master/install.sh))

## LXC Distribution Infromation

- debian
- bookworm
- amd64

## Table of Contents

1. [Install container](#step-1-install-container-archive)

## Step 1: Install Container archive

1. ~~Go to the CA App and search for PiHole~~ <- not implemented currently
2. ~~Select the LXC template and install it~~ <- not implemented currently

   
Currently only available by manually downloading and installing the template
1. Open a Unraid terminal and execute `wget -O /tmp/lxc_container_template.xml https://raw.githubusercontent.com/ich777/unraid_lxc_nextcloudpi/master/lxc_container_template.xml`
2. Navigate to `http://<YourunRAIDIP>/LXCAddTemplate`
3. Make your changes if necessary
4. Click Apply
5. Wait for the Done button

After everything is done it should leave you with a container looking something like this:
![grafik](https://github.com/user-attachments/assets/ff071bfa-19e7-404c-af50-2a0606a501f5)
