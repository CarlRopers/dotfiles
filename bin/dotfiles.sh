#!/usr/bin/env bash

# easy download and exec:
# source <(wget -qO- https://raw.githubusercontent.com/CarlRopers/dotfiles/main/bin/dotfiles.sh)

###############################################################################################################################
# set
# -x: print all commands for debugging
# -u: error if using variable that is not set
set -u

# Define error handler function
function handle_error() {
    # Get information about the error
    local error_code=$?
    local error_line=${BASH_LINENO[0]}
    local error_command=$BASH_COMMAND

    echo >&2 "Error occurred on line $error_line: $error_command (exit code: $error_code)"

    # unset script conditions
    set +u
    trap - ERR
    return 1
}

# Set the trap for any error (non-zero exit code)
trap handle_error ERR

###############################################################################################################################
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo >&2 "script is not being sourced, run this instead:"
    echo >&2 "source ${BASH_SOURCE[0]}"
    return 1
fi

###############################################################################################################################
current_user=$(whoami)
dotfiles_dir="${HOME}/.dotfiles"
###############################################################################################################################

if [[ $current_user == "root" ]]; then
    echo >&2 "User cannot be root"
    return 1
fi

###############################################################################################################################

if [ ! -f "/usr/bin/git" ]; then
    echo "Installing Git..."
    sudo apt-get update -qq >/dev/null
    sudo apt-get install git -y -qq >/dev/null
fi

if [ ! -d "${dotfiles_dir}" ]; then
    echo "Creating ~/.dotfiles..."
    mkdir "${dotfiles_dir}"
fi

if [ ! -d "${dotfiles_dir}/.git" ]; then
    echo "Cloning git dotfiles..."
    /usr/bin/git clone "https://carlropers@github.com/CarlRopers/dotfiles.git" "${dotfiles_dir}" >/dev/null 2>&1
fi

# make sure items in folder match those on git
echo "Syncing latest changes with git"
/usr/bin/git -C "${dotfiles_dir}" fetch --all >/dev/null 2>&1
/usr/bin/git -C "${dotfiles_dir}" reset --hard origin/main >/dev/null 2>&1
/usr/bin/git -C "${dotfiles_dir}" clean -f >/dev/null 2>&1
/usr/bin/git -C "${dotfiles_dir}" pull >/dev/null 2>&1

chmod +x "${dotfiles_dir}/bin/"*.sh

# create symlinks
shopt -s dotglob # enable hidden files
for file in "${dotfiles_dir}"/.*; do

    # relativename="${file#*}" # .dotfiles/.bashrc
    basename="${file##*/}" # .bashrc

    if [[ "${basename}" == "." || "${basename}" == ".." || "${basename}" == ".git" ]]; then
        continue
    fi

    # echo "${basename}"

    if [[ ! -L "${HOME}/${basename}" ]]; then

        if [[ -f "${HOME}/${basename}" ]]; then
            echo "file exist and is not a link: ${basename}"
            rm "${basename}"

        elif [[ -d "${HOME}/${basename}" ]]; then
            echo "directory exist and is not a link: ${basename}"
            rm -Rf "${basename}"
        fi

    fi

    ln -nsrf "${dotfiles_dir}/${basename}" "${HOME}/${basename}" # s = symlink; r = relative path; f = force; n = no-dereference (else it will create a new dir link)

done
shopt -u dotglob # disable hidden files

# unset script conditions
set +u
trap - ERR

# shellcheck disable=SC1091
source "${HOME}/.bashrc"
# shellcheck disable=SC1091
source "${HOME}/.bash_aliases"
