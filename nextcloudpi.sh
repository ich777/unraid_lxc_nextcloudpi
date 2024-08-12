#!/bin/bash
# Check for LXC plugin
if [ ! -f /boot/config/plugins/lxc.plg ]; then
  echo "ERROR: LXC plugin not found!"
  exit 1
fi

# Get LXC path and define container details
LXC_PATH=$(cat /boot/config/plugins/lxc/lxc.conf | grep "lxc.lxcpath" | cut -d '=' -f2)
LXC_STORAGE_TYPE=$(cat /boot/config/plugins/lxc/plugin.cfg | grep "BDEVTYPE" | cut -d '=' -f2)
LXC_CONTAINER_NAME=${1:-NextcloudPi}
LXC_DISTRIBUTION=debian
LXC_RELEASE=bookworm
LXC_ARCH=amd64

# Check if machine uses /mnt/user for LXC
if echo ${LXC_PATH} | grep -q "/mnt/user" ; then
  echo "WARNING: You are using the LXC path /mnt/user, please consider chaning it to the real file path!"
  echo "Continuing in 10 seconds..."
  sleep 10
fi

# Define error check function
error_check() {
  if [ "${1}" == "null" ] || [ -z "${1}" ] ; then
    echo "ERROR: An error at stage: ${2} occured!"
    exit 1
  fi
}

# Get variables from GitHub
GH_RESPONSE="$(wget -qO- https://api.github.com/repos/nextcloud/nextcloudpi/releases/latest)"
error_check "${GH_RESPONSE}" "Github Response"

LAT_V="$(jq -r '.tag_name' <<<"${GH_RESPONSE}")"
error_check "${LAT_V}" "Version Check"

DL_URL="$(jq -r '.assets[].browser_download_url' <<<"${GH_RESPONSE}" | grep 'LXC' | grep 'x86')"
error_check "${DL_URL}" "Download URL"


# Check if LXC container already exists
if lxc-ls --line | grep -q -x "${LXC_CONTAINER_NAME}" ; then
  echo "ERROR: Container ${LXC_CONTAINER_NAME} already exists!"
  exit 1
fi

echo "This script will create a Debian 12 container with the name: \"${LXC_CONTAINER_NAME}\", download and extract NextcloudPi ${LAT_V} from the repository: https://github.com/nextcloud/nextcloudpi to the rootfs from the newly created container." | fold -s -w 80
echo
echo "Please don't interrupt the process after starting!"
echo
echo -n "Start (y/N)? "
read -n 1 answer
echo

if [[ ${answer,,} =~ ^[Yy]$ ]]; then
  echo "Starting, this can take some time..."
else
  echo "Abort!"
  exit 1
fi

# create LXC container
echo "Creating container ${LXC_CONTAINER_NAME}"
lxc-create --name ${LXC_CONTAINER_NAME} \
  --template download -- \
  --dist ${LXC_DISTRIBUTION} \
  --release ${LXC_RELEASE} \
  --arch ${LXC_ARCH}

lxc-stop -n-name ${LXC_CONTAINER_NAME} > /dev/null 2&>1

echo "Removing default rootfs data"
cd ${LXC_PATH}/${LXC_CONTAINER_NAME}
rm -rf ${LXC_PATH}/${LXC_CONTAINER_NAME}/rootfs/.* ${LXC_PATH}/${LXC_CONTAINER_NAME}/rootfs/*

echo "Downloading NextcloudPi ${LAT_V}"
wget -q --show-progress --progress=bar:force:noscroll -O ${LXC_PATH}/${LXC_CONTAINER_NAME}/nextcloudpi.tar.gz "${DL_URL}"

echo "Extracting NextcloudPi ${LAT_V}, please wait, this can take some time..."
tar -C ${LXC_PATH}/${LXC_CONTAINER_NAME}/rootfs/ -xf ${LXC_PATH}/${LXC_CONTAINER_NAME}/nextcloudpi.tar.gz

rm -rf ${LXC_PATH}/${LXC_CONTAINER_NAME}/nextcloudpi.tar.gz

echo "Adding WebUI URL to container config"
echo -e "\n#container_webui=https://[IP]:443" >> ${LXC_PATH}/${LXC_CONTAINER_NAME}/config

echo "Download and install Nextcloud container Logo"
if [ ! -d ${LXC_PATH}/custom-icons ]; then
  mkdir -p ${LXC_PATH}/custom-icons
fi
wget -q -O ${LXC_PATH}/custom-icons/${LXC_CONTAINER_NAME}.png https://raw.githubusercontent.com/ich777/docker-templates/master/ich777/images/nextcloudpi.png

echo "All Done!"
echo "Please refresh your LXC page, the container is now ready to start."
if [ "${LXC_STORAGE_TYPE}" != "dir" ]; then
  echo
  if [ "${LXC_STORAGE_TYPE}" == "btrfs" ]; then
    echo "Since you are using BTRFS as Backing Storage type don't forget to convert the"
    echo "to BTRFS, to do that run the following command:"
    echo
    echo "lxc-dirtobtrfs ${LXC_CONTAINER_NAME}"
  elif [ "${LXC_STORAGE_TYPE}" == "zfs" ]; then
    echo "Since you are using ZFS as Backing Storage type don't forget to convert the"
    echo "to ZFS, to do that run the following command:"
    echo
    echo "lxc-dirtozfs ${LXC_CONTAINER_NAME}"
  fi
fi
