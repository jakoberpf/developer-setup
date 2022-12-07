#!/bin/bash

abort() {
  printf "%s\n" "$@"
  exit 1
}

while getopts u:a:f: flag
do
    case "${flag}" in
        v)    VERBOSE=${OPTARG};;
        gu)   OPS_GITHUB_USERNAME=${OPTARG};;
        gt)   OPS_GITHUB_TOKEN=${OPTARG};;
        grs)  OPS_GITHUB_REPO_SETUP=${OPTARG};;
        grh)  OPS_GITHUB_REPO_HOME=${OPTARG};;
    esac
done

# Fail fast with a concise message when not using bash
# Single brackets are needed here for POSIX compatibility
if [ -z "${BASH_VERSION:-}" ]
then
  abort "[error] Bash is required to interpret this script."
fi

# Fail fast if running as root
# Single brackets are needed here for POSIX compatibility
if [ "${EUID}" == 0 ]
then
  abort "[error] Running this script as root is not supported and dangerous."
fi

# Check if script is run non-interactively (e.g. CI)
# If it is run non-interactively we should not prompt for passwords.
if [[ ! -t 0 || -n "${CI-}" ]]
then
  NONINTERACTIVE=1
fi

print_header() {
  echo
  echo "             _                _                                     _                       "
  echo "            | |              | |                                   | |                      "
  echo "          __| | _____   _____| | ___  _ __   ___ _ __      ___  ___| |_ _   _ _ __          "
  echo "         / _  |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \ '__|____/ __|/ _ \ __| | | | '_ \         "
  echo "        | (_| |  __/\ V /  __/ | (_) | |_) |  __/ | |_____\__ \  __/ |_| |_| | |_) |        "
  echo "         \__,_|\___| \_/ \___|_|\___/| .__/ \___|_|       |___/\___|\__|\__,_| .__/         "
  echo "                                     | |                                     | |            "
  echo "                                     |_|                                     |_|            "
  echo "                                                                                            "
  echo
}

print_header

# Check the OS.
OS="$(uname)"
if [[ "${OS}" != "Linux" && "${OS}" != "Darwin" ]]
then
  abort "[error] The developer-setup is only supported on macOS and Linux."
fi

# Check the environment variables
if [ -n "$OPS_GITHUB_USERNAME" ]; then
  GITHUB_USERNAME=$OPS_GITHUB_USERNAME
elif [ ! -n "$GITHUB_USERNAME" ]; then
  echo "Enter your Github Username: "
  read GITHUB_USERNAME
fi

function authenticated_by_ssh() {
  # Set the ssh key to try with
  ssh_key="~/.ssh/id_rsa"
  # Attempt to ssh to GitHub
  ssh -T git@github.com &>/dev/null
  # Get username from response | cut -d ' ' -f2 | tr -d '!'
  RET=$?
  echo "$RET"
  if [ $RET == 1 ]; then
    # user is authenticated, but fails to open a shell with GitHub 
    return 0
  elif [ $RET == 255 ]; then
    # user is not authenticated
    return 1
  else
    echo "Unknown exit code in attempt to ssh into git@github.com"
  fi
  return 2
}


if [ authenticated_by_ssh ]; then
  # User is authenticated by ssh, so no token is necessary
  GIT_AUTH="sshkey"
elif [ -n "$OPS_GGITHUB_TOKEN" ]; then
  GITHUB_TOKEN=$OPS_GITHUB_TOKEN
elif [ ! -n "$GITHUB_TOKEN" ]; then
  echo "Enter Your Github Token: "
  read GITHUB_TOKEN
fi

# GITHUB_TOKEN=""
GITHUB_REPO_SETUP="my-setup"
GITHUB_REPO_HOME="my-home"

LOCALREPO_SETUP=".setup"
LOCALREPO_HOME=".home"

# Show settings
# if [ -v VERBOSE ]
# then
#   echo "[log] "
# fi

# Clone or pull setup repository
echo "[setup] Downloading the setup repository from github."
if [ ! -d ~/$LOCALREPO_SETUP/.git ]
then
    git clone https://$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$GITHUB_REPO_SETUP.git ~/$LOCALREPO_SETUP
else
    cd ~/$LOCALREPO_SETUP
    git pull
fi

# Clone or pull configuration repository
echo "[setup] Downloading the configuration repository from github."
if [ ! -d ~/$LOCALREPO_HOME/.git ]
then
    git clone https://$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$GITHUB_REPO_HOME.git ~/$LOCALREPO_HOME
else
    cd ~/$LOCALREPO_HOME
    git pull
fi

if [[ "${OS}" == "Darwin" ]]
then
  echo "[setup] Running setup for macOS."
  if [[ `uname -m` == 'arm64' ]]; then
    echo "[setup] AppleSilicon detected, will install Rosetta."
    sudo softwareupdate --install-rosetta --agree-to-license
  fi
  ~/$LOCALREPO_HOME/bin/config.sh ~/$LOCALREPO_SETUP
elif [[ "${OS}" == "Linux" ]]
then
  echo "[setup] Running setup for Ubuntu/Linux."
fi