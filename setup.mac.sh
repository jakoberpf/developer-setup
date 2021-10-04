#!/bin/bash

print_header() {
  echo
  echo "                            __        "
  echo "                          / _|        "
  echo "         ___  _ __ _ __  | |_         "
  echo "        / _ \| '__| '_ \ |  _/        "
  echo "       |  __/| |  | |_) || |          "
  echo "        \___||_|  | .__/ |_|          "
  echo "                  | |                 "
  echo "                  |_|                 "
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

# create virtual python3 enviroment
python3 -m venv .venv

# switch to cli to virtual python3 enviroment
source .venv/bin/activate

# set ansible version to use
ANSIBLE_VERSION=3.1.0 # NOTE: < 2.10.4 has broken brew collection # TODO check that installed version is at least ANSIBLE_VERSION

# xcode-select --install
# If python makes problem try reinstalling pip. curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py

function check_ansible {
  if command -v ansible-playbook  >/dev/null 2>&1; then
    echo
    print_message "[setup] ansible-playbook is already installed (skipped)"
  else
    print_message "[setup] installing ansible-playbook  ..."
    sudo -H pip3 install --upgrade pip
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
