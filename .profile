# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

unset LESSHISTFILE              # don't want less to store history

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

GOPATH=$HOME/usr/go; export GOPATH
PATH=$HOME/bin:$HOME/usr/bin:$HOME/.local/bin:$GOPATH/bin:$PATH; export PATH

WORKON_HOME=$HOME/.virtualenvs; export WORKON_HOME
PROJECT_HOME=$HOME/p/python; export PROJECT_HOME
#. /usr/share/virtualenvwrapper/virtualenvwrapper.sh

GNUPGHOME=$HOME/.gnupg; export GNUPGHOME

# OPAM configuration
. /home/linus/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

[ -d "$HOME/.cache/rebar3/bin" ] && PATH="$PATH:$HOME/.cache/rebar3/bin"
export PATH

PATH=$PATH:$HOME/usr/games; export PATH

export PATH="$HOME/.cargo/bin:$PATH"
