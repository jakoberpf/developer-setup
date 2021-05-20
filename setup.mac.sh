#!/bin/bash

print_header() {
  echo
  echo "                             __           _                       "
  echo "                            / _|         | |                      "
  echo "          __ _ _ __   ___  | |_ __ _  ___| |_ ___  _ __ _   _     "
  echo "         / _' | '_ \ / _ \ |  _/ _' |/ __| __/ _ \| '__| | | |    "
  echo "        | (_| | |_) |  __/ | || (_| | (__| || (_) | |  | |_| |    "
  echo "         \__,_| .__/ \___| |_| \__,_|\___|\__\___/|_|   \__, |    "
  echo "              | |                                        __/ |    "
  echo "              |_|                                       |___/     "
  echo
  echo
}

print_title() {
  printf '%s\n\e[1m %s \e[m\n%s\n' "${DIVIDER}" "${1}" "${DIVIDER}"
}

print_done() {
  printf '\e[1;32mDone.\e[m\n%s\n' "${DIVIDER}"
}

print_message() {
  printf "%s \e[1m%s\e[m\n" "${1}" "${2}"
}

print_green() {
  printf '\e[1;32m%s\e[m\n' "${1}"
}

print_red() {
  printf '\e[1;31m%s\e[m\n' "${1}"
}

print_bold() {
  printf '\e[1m%s\e[m\n' "${1}"
}


print_header

# move to script folder
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

ANSIBLE_VERSION=3.1.0 # < 2.10.4 has broken brew collection
# TODO check that installed version is at least ANSIBLE_VERSION

function check_ansible {
  if command -v ansible-playbook  >/dev/null 2>&1; then
    echo
    print_message "[setup] ansible-playbook is already installed (skipped)"
  else
    print_message "[setup] installing ansible-playbook  ..."
    sudo -H pip3 install ansible==${ANSIBLE_VERSION}
    print_green "[setup] ansible-playbook  is installed"
  fi
  echo
}

# print_bold "[prep] Downloading all roles"
# sh roles/roles.sh # 

print_bold "[setup] Running ansible provisioning... "
check_ansible

ansible-playbook setup.yaml --ask-become-pass

echo
print_bold "[setup] Your mac is setup"
print_bold "[setup] You can now close this terminal to get the ENV VAR in the next session "
