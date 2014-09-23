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
LC_CTYPE=sv_SE.ISO8859-15; export LC_TYPE
LC_PAPER=$LC_CTYPE; export LC_PAPER
LC_MEASUREMENT=$LC_CTYPE; export LC_MEASUREMENT

[ -f "${HOME}/.gpg-agent-info" ] && . "${HOME}/.gpg-agent-info"
export GPG_TTY=$(tty)

#function dmalloc { eval `command dmalloc -b $*`; }

#alias ehlo='ssh -L 8080:127.0.0.1:8080 -i ~/ustick/.ssh/keys/e -p 7000 localhost'
alias ehlo-root='ssh -i ~/.ssh/keys/e2 -p 4700 root@localhost'
alias ext='sockstat -46'
#alias ext='netstat -n --inet --inet6 | egrep ESTABLISH'
alias grep='grep -E'
alias ls='ls -F'
alias pond='$GOPATH/bin/client -cli=true -state-file=$HOME/tstick/.config/pond'
alias pwd="pwd | sed s,^$HOME,~,"
alias screenshot='xwd | xwdtopnm | pnmtopng'
#alias ssh-agent='ssh-agent -s | grep -v ^echo | tee ~/ssh-agent.sh; . ~/ssh-agent.sh'
alias ssh-keepalive='ssh -o ServerAliveInterval=60'
alias startx='ssh-agent startx & vlock'
#alias tunnel-ehlo='ssh -Nf -L 7000:ehlo.4711.se:22 banksy.nordberg.se'
alias tunnel-dfri-abuse='torsocks ssh -NfL 10587:smtp.adb-centralen.se:587 smtp.adb-centralen.se'
alias tunnel-ehlo='ssh -NfL 4700:127.0.0.1:4711 -L 1880:127.0.0.1:8080 ehlo.4711.se'
alias tunnel-ehlo-mrtg='ssh -Nf -L 8080:127.0.0.1:8080 ehlo.4711.se'
alias tunnel-email='ssh -Nf -L 1993:imap.adb-centralen.se:993 -L 2993:kerio.nordu.net:993 -L 1587:smtp.adb-centralen.se:587 -L 2587:kerio.nordu.net:587 -L 10119:news.gmane.org:119 smtp.adb-centralen.se'
alias tunnel-freenode='ssh -Nf -L 6669:127.0.0.1:6669 d.nordberg.se && echo "6669 -> d.nordberg.se:6669"'
alias tunnel-irc='ssh -NfL 6667:localhost:6667 proj.adb-centralen.se'
alias tunnel-irc-tor='torify ssh -NfL 6667:lntest:6667 banksy.nordberg.se'
alias tunnel-jabber='ssh -K -NfL 5222:lntest:5222 banksy.nordberg.se'
alias tunnel-jabber-web='ssh -Nf -L 5280:accept:5280 accept.adb-centralen.se'
#alias tunnel-nordberg-mail='ssh -Nf -L 1243:localhost:143 -L 1126:localhost:25 lnmail.nordberg.se && echo "(1243, 1126) -> imap.nordberg.se:(143, 25)"'
alias tunnel-nordberg-mail='ssh -Nf -L 1126:localhost:25 lnmail.nordberg.se && echo "1126 -> imap.nordberg.se:25"'
alias tunnel-proxy='ssh -Nf -L 8080:localhost:8080 mgv.nordberg.se && echo "8080 -> mgv.nordberg.se:8080"'
alias tunnel-rs0='ssh -NfL 7001:10.3.3.1:22 mm.adb-centralen.se'
alias tunnel-rs0web='ssh -NfL 4780:localhost:4780 rs0.dfri.net; fixme'
alias tunnel-slime='ssh -Nf -L 4711:localhost:4711 lntest.nordberg.se'
alias tunnel-sieve='ssh -Nf -L 2000:lnmail:2000 banksy.nordberg.se && echo "2000 -> lnmail.nordberg.se:2000"'
#alias whois='whois -h geektools.com'
alias xlock='xlock -mode blank'
alias antiexcel='python /usr/local/share/examples/py-excelerator/xls2txt.py'

## pastebin
#sprunge () {
#    printf '%s%s\n' "$(curl -sF 'sprunge=<-' http://sprunge.us/)" "${*:+?$*}"
#}
