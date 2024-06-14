#!/usr/bin/env bash

alias tt='history | tail -n 100 | grep'
alias update="sudo -- sh -c 'apt-get update; apt-get upgrade -y; apt-get dist-upgrade -y; apt-get autoremove -y; apt-get autoclean -y'"
alias count='ls * | wc -l'
alias cls='clear'
alias rename='mv'
alias dotfiles='source "${HOME}/.dotfiles/bin/dotfiles.sh"'
alias motd='cat /run/motd.dynamic'
alias ports='sudo netstat -tupln'
alias grep='grep --color=auto' # colorize output (good for log files)
alias dotfilesdownload='echo "Command to download dotfiles on a new machine or login:"; echo "source <(wget -qO- https://raw.githubusercontent.com/CarlRopers/dotfiles/main/bin/dotfiles.sh)"'
# get error messages from journalctl
alias errorlogs="journalctl -p 3 -xb"

# show chmod codes
alias lschmod='stat -c "%a %n" .* *'
alias chmodls='stat -c "%a %n" .* *'

# docker compose re-create
alias dc='docker compose up --force-recreate --detach'

# get public ip
alias getpubip='curl ifconfig.me'

# Change dirs
alias ..="cd .."
alias cd..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"

# On move or copy ask to overwrite
alias cp='cp -vi'
alias mv='mv -vi'

# Better copying, see progress while copying
alias cpv='rsync -avh --info=progress2'
