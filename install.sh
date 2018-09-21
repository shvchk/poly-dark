#! /usr/bin/env bash

THEME='poly-dark'
LANG='English'
TMP_FILE="/tmp/${THEME}-master.zip"
TMP_DIR="/tmp/${THEME}-master"

# Pre-authorise sudo
sudo echo

# Select language, optional
declare -A LANGS=(
    [Chinese]=zh_CN
    [English]=EN
    [French]=FR
    [German]=DE
    [Norwegian]=NO
    [Portuguese]=PT
    [Russian]=RU
    [Spanish]=ES
    [Ukrainian]=UA
)

LANG_NAMES=($(echo ${!LANGS[*]} | tr ' ' '\n' | sort -n))

PS3='Please select language #: '
select l in "${LANG_NAMES[@]}"
do
    if [[ -v LANGS[$l] ]]
    then
        LANG=$l
        break
    else
        echo 'No such language, try again'
    fi
done < /dev/tty

# Detect distro and set GRUB location and update method
GRUB_DIR='grub'
UPDATE_GRUB=''

if [ -e /etc/os-release ]; then

    source /etc/os-release

    if [[ "$ID" =~ (debian|ubuntu|solus) || \
          "$ID_LIKE" =~ (debian|ubuntu) ]]; then

        UPDATE_GRUB='update-grub'

    elif [[ "$ID" =~ (arch|gentoo) || \
            "$ID_LIKE" =~ (archlinux|gentoo) ]]; then

        UPDATE_GRUB='grub-mkconfig -o /boot/grub/grub.cfg'

    elif [[ "$ID" =~ (centos|fedora|opensuse) || \
            "$ID_LIKE" =~ (fedora|rhel|suse) ]]; then
            
        GRUB_DIR='grub2'
        UPDATE_GRUB='grub2-mkconfig -o /boot/grub2/grub.cfg'
    fi
fi

echo "Downloading theme archive to temp. file ${TMP_FILE}"
wget -O ${TMP_FILE} https://github.com/shvchk/${THEME}/archive/master.zip

if [ ! -f ${TMP_FILE} ]; then
    echo 'ERROR: Failed to download theme archive. Cannot continue.'
    exit 1
fi

echo "Unpacking theme to temp. directory ${TMP_DIR}"
unzip ${TMP_FILE}

if [ ! -d ${TMP_DIR} ]; then
    echo 'ERROR: Failed to extract theme assets. Cannot continue.'
    exit 2
fi

if [[ "$LANG" != "English" ]]
then
    echo "Changing language to ${LANG}"
    sed -i -r -e '/^\s+# EN$/{n;s/^(\s*)/\1# /}' \
              -e '/^\s+# '"${LANGS[$LANG]}"'$/{n;s/^(\s*)#\s*/\1/}' ${TMP_DIR}/theme.txt
fi

echo 'Creating GRUB themes directory'
sudo mkdir -p /boot/${GRUB_DIR}/themes/${THEME}

echo 'Copying theme to GRUB themes directory'
sudo cp -r ${THEME}-master/* /boot/${GRUB_DIR}/themes/${THEME}

echo 'Removing other themes from GRUB config'
sudo sed -i '/^GRUB_THEME=/d' /etc/default/grub

echo 'Making sure GRUB uses graphical output'
sudo sed -i 's/^\(GRUB_TERMINAL\w*=.*\)/#\1/' /etc/default/grub

echo 'Removing empty lines at the end of GRUB config' # optional
sudo sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' /etc/default/grub

echo 'Adding new line to GRUB config just in case' # optional
echo | sudo tee -a /etc/default/grub

echo 'Adding theme to GRUB config'
echo "GRUB_THEME=/boot/${GRUB_DIR}/themes/${THEME}/theme.txt" | sudo tee -a /etc/default/grub

echo 'Removing temp. theme installation files'
rm -rf ${TMP_FILE} ${TMP_DIR}

echo 'Updating GRUB'
if [[ $UPDATE_GRUB ]]; then
    eval sudo "$UPDATE_GRUB"
else
    cat << '    EOF'
    --------------------------------------------------------------------------------
    Cannot detect your distro, you will need to run `grub-mkconfig` (as root) manually.

    Common ways:
    - Debian, Ubuntu, Solus and derivatives: `update-grub` or `grub-mkconfig -o /boot/grub/grub.cfg`
    - RHEL, CentOS, Fedora, SUSE and derivatives: `grub2-mkconfig -o /boot/grub2/grub.cfg`
    - Arch, Gentoo and derivatives: `grub-mkconfig -o /boot/grub/grub.cfg`
    --------------------------------------------------------------------------------
    EOF
fi
