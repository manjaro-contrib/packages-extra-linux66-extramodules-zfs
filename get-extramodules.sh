#!/bin/bash

path=$(pwd)
modules=${path##*/}
kernel=$(echo $modules | cut -d- -f1)

## setup for ssh use
#start_agent(){
#    echo "Initializing SSH agent..."
#    ssh-agent | sed 's/^echo/#echo/' > "$1"
#    chmod 600 "$1"
#    . "$1" > /dev/null
#    ssh-add
#}
#
#ssh_add(){
#    local ssh_env="/home/$(whoami)/.ssh/environment"
#
#    if [ -f "${ssh_env}" ]; then
#         . "${ssh_env}" > /dev/null
#         ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
#            start_agent ${ssh_env};
#        }
#    else
#        start_agent ${ssh_env};
#    fi
#}
#
#ssh_add
#_git=ssh://git@gitlab.manjaro.org:22277/packages/extra
## end of ssh setup

echo ">> Receive modules.list ..."
wget -qN https://gitlab.manjaro.org/packages/core/$kernel/-/raw/master/modules.list

## setup for https use
printf "gitlab-user: "
read user
printf "password: "
read -s passwd
printf "\n"
_git=https://$user:"$passwd"@gitlab.manjaro.org/packages/extra
## end of https setup

for m in $(cat modules.list); do
    if [ ! -e $m/.git >/dev/null ]; then
        echo ""
        git clone $_git/$modules/$m.git
    else printf "\n[$m] already exists.\n"
    fi
done
