# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_ID=$ID
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi
unset rc

####################
# Disabled, kept for reference

#function dmalloc { eval `command dmalloc -b $*`; }
## pastebin
#sprunge () {
#    printf '%s%s\n' "$(curl -sF 'sprunge=<-' http://sprunge.us/)" "${*:+?$*}"
#}

# This effectively makes gpg-agent the only ssh-agent. Not so good.
#export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# pinentry uses this:
#export GPG_TTY=$(tty)

# For pass(1), on Wayland+Sway+foot. Default xclip "selection" is
# clipboard but that clipboard is not the same clipboard as what
# Wayland (or Sway, or foot) is using. Using primary makes it possible
# to paste with middle mouse button though and that will have to do.
#export PASSWORD_STORE_X_SELECTION=primary
