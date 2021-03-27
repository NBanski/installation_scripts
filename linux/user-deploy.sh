#!/bin/bash
if test "$#" -lt "1" || test "$1" = "--help" || test "$1" = "-h"; then
  echo "user-deploy.sh [username] [ssh]"
  echo "username, new user's name"
  echo "ssh, if present, root ssh keys are copied"
  exit 1
fi

adduser --gecos GECOS $1
usermod -aG sudo $1

if test "$2" = ssh; then
  mkdir /home/$1/.ssh
  cp ~/.ssh/authorized_keys /home/$1/.ssh/authorized_keys
  chown --recursive $1:$1 /home/$1/.ssh
  echo "SSH keys copied."
fi
