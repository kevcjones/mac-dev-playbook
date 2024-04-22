<img src="https://raw.githubusercontent.com/geerlingguy/mac-dev-playbook/master/files/Mac-Dev-Playbook-Logo.png" width="250" height="156" alt="Mac Dev Playbook Logo" />

# Mac Dev Playbook

Forked from [Jamies setup](Rooster212/mac-dev-ansible-setup) inspired by [His Mac Dev Playbook repo](https://github.com/geerlingguy/mac-dev-playbook) i decided to get this done finally with a new Mac incoming.

## Quick install

If you'd like to start with my default list of tools and apps (see Included Apps/Config below), then simply install with;

`sh -c "$(curl -fsSL https://raw.githubusercontent.com/kevcjones/mac-dev-playbook/master/install.sh)"`

You can always customize the install after-the-fact (see below), and re-run the playbook. It will skip over any installed apps.

## Custom install

1. Run the quick install script but you can cancel it when asked for sudo.
1. Change into the `mac-dev-playbook` directory.
1. Edit the `main.yml` file to include your desired apps and configuration.
1. Run `ansible-playbook playbook.yml -i hosts --ask-sudo-pass -vvvv`

## Ansible Galaxy roles/collections used:

- Oh My Zsh installation role from @ctorgalson: https://galaxy.ansible.com/ctorgalson/oh-my-zsh
- OSX Command Line tools installation role from @elliotweiser: https://galaxy.ansible.com/elliotweiser/osx-command-line-tools
- Mac roles collection from @geerlingguy: https://galaxy.ansible.com/geerlingguy/mac
- Dotfiles installation role from @geerlingguy: https://galaxy.ansible.com/geerlingguy/dotfiles
- Ansible role (to install Ansible on the Mac!): https://github.com/geerlingguy/ansible-role-ansible

## Tests

We run an integration test in CI. This was heavily inspired by @geerlingguy's Ansible collection tests (which is used in this repo as well!) - https://github.com/geerlingguy/ansible-collection-mac

## Manual steps

Some things I can't automate (boo)

- `sudo` TouchID support in iTerm 2 - you need to set `Preferences` -> `Advanced` -> `Allow sessions to survive logging out` to `no`.
