# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
#HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
#HISTCONTROL=ignoreboth
HISTIGNORE='&:[ ]*'

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTFILESIZE=10000
HISTSIZE=10000

unset LC_PAPER
unset LC_MEASUREMENT

# Don't want this, set by some part of Debian:
#LESSCLOSE='/usr/bin/lesspipe %s %s'
#LESSOPEN='| /usr/bin/lesspipe %s'
unset LESSOPEN
unset LESSCLOSE

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

EDITOR=vi; export EDITOR
PAGER=less; export PAGER
FTP_PASSIVE_MODE=1; export FTP_PASSIVE_MODE
export GOPATH=$HOME/usr/go

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
LC_PAPER=$LC_CTYPE; export LC_PAPER
LC_MEASUREMENT=$LC_CTYPE; export LC_MEASUREMENT

#function dmalloc { eval `command dmalloc -b $*`; }
## pastebin
#sprunge () {
#    printf '%s%s\n' "$(curl -sF 'sprunge=<-' http://sprunge.us/)" "${*:+?$*}"
#}

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# pinentry uses this:
export GPG_TTY=$(tty)
