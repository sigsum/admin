if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
alias hd='hexdump -C'
alias ykm-nano='ykman -d 3037390'
alias ykm-5c31='ykman -d 16383131'
alias cdst="cd ~/usr/src/st/core/system-transparency"
alias sshkeyoncard='export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)'
