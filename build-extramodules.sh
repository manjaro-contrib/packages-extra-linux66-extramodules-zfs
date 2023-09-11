#!/bin/bash

path=$(pwd)
modules=${path##*/}
kernel=$(echo $modules | cut -d- -f1)
pwd=`pwd`
cmd='makepkg -df --noconfirm'

start_agent(){
    echo "Initializing SSH agent..."
    ssh-agent | sed 's/^echo/#echo/' > "$1"
    chmod 600 "$1"
    . "$1" > /dev/null
    ssh-add
}

ssh_add(){
    local ssh_env="/home/$(whoami)/.ssh/environment"

    if [ -f "${ssh_env}" ]; then
         . "${ssh_env}" > /dev/null
         ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
            start_agent ${ssh_env};
        }
    else
        start_agent ${ssh_env};
    fi
}

if [ "`sudo cat /etc/sudoers | grep pacman`" == "" ] ; then
   echo "please add '`whoami` ALL=NOPASSWD: /usr/bin/pacman' to your /etc/sudoers file"
   exit 1
fi

echo ">> Receive modules.list for [$kernel] ..."
curl -o modules.list https://gitlab.manjaro.org/packages/core/$kernel/-/raw/master/modules.list

echo '  -> cleaning environment ...'
rm -R ${pwd}/*/{src,pkg} -f

echo '  -> building extramodules ...'

for m in $(cat modules.list); do
    if [ ! -d $m ]; then
        echo ">> Clone missing repo [$m] ..."
#        ssh_add
#        _git=ssh://git@gitlab.manjaro.org:22277/packages/extra

## for https use
        if [ -z $user ]; then
          printf "gitlab-user: "
          read user
          printf "password: "
          read -s passwd
        fi
        _git=https://$user:"$passwd"@gitlab.manjaro.org/packages/extra

        git clone $_git/$modules/$m.git
    fi
    cd ${pwd}/*$m && $cmd
    cd ..
done

echo '  -> cleaning up ...'
rm -R ${pwd}/*/{src,pkg} -f

[[ -e $HOME/.makepkg.conf ]] && . $HOME/.makepkg.conf || . /etc/makepkg.conf
cd $PKGDEST
echo 'signing packages'
signpkgs

echo '  -> clean up ...'
rm -R ${pwd}/*/{src,pkg} -f

echo 'done.'
