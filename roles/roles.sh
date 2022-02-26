#!/bin/bash
echo "[setup] Download the ansible roles from github."

GIT_ROOT=$(git rev-parse --show-toplevel)
GIT_URL="https://github.com"
GIT_USERNAME="jakoberpf"
GIT_REPO_PREFIX="ansible-role-setup"

declare -a roles
# aws
roles+=("tooling")
roles+=("bash")
roles+=("zsh")
roles+=("rvm")
roles+=("gvm")
roles+=("nvm")
roles+=("jenv")
# ... add addtional

for role in "${roles[@]}";
do
    git clone $GIT_URL/$GIT_USERNAME/$GIT_REPO_PREFIX-jenv.git jenv $GIT_ROOT/roles/$role
done
