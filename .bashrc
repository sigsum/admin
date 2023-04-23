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

## TODO: move all below into ~/.bashrc.d

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
# if ! shopt -oq posix; then
#   if [ -f /usr/share/bash-completion/bash_completion ]; then
#     . /usr/share/bash-completion/bash_completion
#   elif [ -f /etc/bash_completion ]; then
#     . /etc/bash_completion
#   fi
# fi

####################
# Linus stuff
if [ $UID = 0 ]; then PROMPTCHAR="#"; else PROMPTCHAR="%"; fi
PS1="\h:\W$PROMPTCHAR "; export PS1

# git at times has trouble finding SSL certs
os=$(uname)
case $os in
    Linux) crtfile=/etc/ssl/certs/ca-certificates.crt ;;
    FreeBSD) crtfile=/usr/local/share/certs/ca-root-nss.crt ;;
esac
[ -f $crtfile ] && export GIT_SSL_CAINFO=$crtfile

# With LC_CTYPE set, I can paste swedish characters in xterm+bash.
#LC_CTYPE=sv_SE.ISO8859-15; export LC_TYPE
# Update 2023-01-26: Not needed for pasting Swedish characters in foot+bash. 
#LC_PAPER=$LC_CTYPE; export LC_PAPER
#LC_MEASUREMENT=$LC_CTYPE; export LC_MEASUREMENT

# With LC_TIME=C I fix AM/PM ("Thu 26 Jan 2023 04:42:57 PM CET")
LC_TIME=C; export LC_TIME

#function dmalloc { eval `command dmalloc -b $*`; }
## pastebin
#sprunge () {
#    printf '%s%s\n' "$(curl -sF 'sprunge=<-' http://sprunge.us/)" "${*:+?$*}"
#}

# This effectively makes gpg-agent the only ssh-agent. Not so good.
#export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# pinentry uses this:
#export GPG_TTY=$(tty)

# TODO: move this secret out of this file
export TR_AUTH=transmission:QlYnyQvUbpziM3qMIrMsBQHuEfceYDCl

# For pass(1), on Wayland+Sway+foot. Default xclip "selection" is
# clipboard but that clipboard is not the same clipboard as what
# Wayland (or Sway, or foot) is using. Using primary makes it possible
# to paste with middle mouse button though and that will have to do.
#export PASSWORD_STORE_X_SELECTION=primary

export GOPATH="$HOME/usr/go"
export WORKON_HOME="$HOME/.virtualenvs"
export GNUPGHOME="$HOME/.gnupg"
export EDITOR=/usr/bin/emacs

[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/usr/bin" ] && export PATH="$HOME/usr/bin:$PATH"
[ -d "$HOME/.local/bin" ] &&  PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/usr/games" ] && export PATH="$PATH:$HOME/usr/games" # For gtetrinet
[ -d "$HOME/.cache/rebar3/bin" ] && export PATH="$PATH:$HOME/.cache/rebar3/bin"
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"
[ -d "$GOPATH/bin" ] && export PATH="$GOPATH/bin:$PATH"
[ -r "$HOME/.opam/opam-init/init.sh" ] && source "$HOME/.opam/opam-init/init.sh" > /dev/null 2> /dev/null || true

case $OS_ID in
    debian)
	[ -d "/usr/lib/go-1.19/bin" ] && export PATH="$PATH:/usr/lib/go-1.19/bin"
	;;
esac

