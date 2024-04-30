#!/bin/sh


# Be prepared to turn your OSX box into 
# a development beast.
#
# This script bootstraps our OSX laptop to a point where we can run
# Ansible on localhost. It;
#  1. Installs 
#    - xcode
#    - homebrew
#    - ansible (via brew) 
#    - a few ansible galaxy playbooks (zsh, homebrew, cask etc)  
#  2. Kicks off the ansible playbook
#    - main.yml
#
# It will ask you for your sudo password

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

fancy_echo "Boostrapping ..."

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

# Here we go.. ask for the administrator password upfront and run a
# keep-alive to update existing `sudo` time stamp until script has finished
sudo -k
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Ensure Apple's command line tools are installed
if xcode-select -p &>/dev/null; then
  fancy_echo "Xcode already installed. Skipping."
else
  fancy_echo "Installing xcode ..."
  xcode-select --install 
fi

# Unfortunatly, and i loath this xocdebuild will not run without the full xcode installed
# all SO posts to the contrary .. i couldn't make the select of the CL tools work
if [ -d "/Applications/Xcode.app" ]; then
    echo "Full Xcode is installed."
    sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
    sudo xcodebuild -license accept
else
    echo "Full Xcode is not installed. Please install it if needed."
    exit 1
fi


if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null
  echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> $HOME/.zprofile
  eval $(/opt/homebrew/bin/brew shellenv)
else
  fancy_echo "Homebrew already installed. Skipping."
fi

# [Install Ansible](http://docs.ansible.com/intro_installation.html).
if ! command -v ansible >/dev/null; then
  fancy_echo "Installing Ansible ..."
  brew install ansible 
else
  fancy_echo "Ansible already installed. Skipping."
fi

# Clone the repository to your local drive.
if [ -d "./mac-dev-playbook" ]; then
  fancy_echo "mac-dev-plybook repo dir exists. Removing ..."
  rm -rf ./mac-dev-playbook/
fi
fancy_echo "Cloning mac-dev-playbook repo ..."
git clone https://github.com/kevcjones/mac-dev-playbook.git 

fancy_echo "Changing to mac-dev-playbook repo dir ..."
cd mac-dev-playbook

fancy_echo "Agreeing to xcode license ..."
sudo xcodebuild -license

fancy_echo "Installing Ansible Galaxy roles ..."
ansible-galaxy install -r requirements.yml

# Run this from the same directory as this README file. 
fancy_echo "Running ansible playbook ..."
ansible-playbook playbook.yml -i hosts --ask-sudo-pass -vvvv 