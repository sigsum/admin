alias curl-tor='curl -A "" -x socks4a://127.0.0.1:9050/'
alias tb=~/sandbox/sandboxed-tor-browser
alias antiexcel='python /usr/local/share/examples/py-excelerator/xls2txt.py'
alias curl-tor='curl -A "" -x socks4a://127.0.0.1:9050/'
alias ehlo-root='ssh -i ~/.ssh/keys/e2 -p 4700 root@localhost'
alias ext='sockstat -46'
alias grep='grep -E'
alias less='less -n'
alias ls='ls -F'
alias pond='$GOPATH/bin/client -cli=true -state-file=$HOME/tstick/.config/pond'
alias pwd="pwd | sed s,^$HOME,~,"
alias screenshot='xwd | xwdtopnm | pnmtopng'
alias ssh-keepalive='ssh -o ServerAliveInterval=60'
alias ssh-add-all-keys='(cd ~/tstick/keys/ssh/ && ssh-add adbc dfri github gitlab tpo ndn ndn-rsa)'
alias startx='ssh-agent startx & vlock'
alias tailf='less -nUEX +F'
alias tunnel-dfri-abuse='ssh -NfL 10587:smtp.adb-centralen.se:587 smtp.adb-centralen.se'
alias tunnel-ehlo='ssh -NfL 4700:127.0.0.1:4711 -L 1880:127.0.0.1:8080 ehlo.4711.se'
alias tunnel-ehlo-mrtg='ssh -Nf -L 8080:127.0.0.1:8080 ehlo.4711.se'
alias tunnel-email='ssh -Nf -L 2025:smtp.adb-centralen.se:25 -L 1993:imap.adb-centralen.se:993 -L 2993:kerio.nordu.net:993 -L 1587:smtp.adb-centralen.se:587 -L 2587:kerio.nordu.net:587 -L 10119:news.gmane.org:119 smtp.adb-centralen.se'
alias tunnel-email-tor='torsocks ssh -Nf -L 1993:imap.adb-centralen.se:993 -L 2993:kerio.nordu.net:993 -L 1587:smtp.adb-centralen.se:587 -L 2587:kerio.nordu.net:587 -L 10119:news.gmane.org:119 smtp.adb-centralen.se'
alias tunnel-freenode='ssh -Nf -L 6669:127.0.0.1:6669 d.nordberg.se && echo "6669 -> d.nordberg.se:6669"'
alias tunnel-irc='ssh -NfL 6667:localhost:6667 proj.adb-centralen.se'
alias tunnel-irc-tor='torify ssh -NfL 6667:lntest:6667 banksy.nordberg.se'
alias tunnel-jabber='ssh -K -NfL 5222:lntest:5222 banksy.nordberg.se'
alias tunnel-jabber-web='ssh -Nf -L 5280:accept:5280 accept.adb-centralen.se'
alias tunnel-munin-ndn='ssh -NfL 8089:localhost:80 munin.nordu.net'
alias tunnel-appendto-sign1='ssh -NfL 22001:sign-1.urd.appendto.org:22 statler.nordu.net'
alias tunnel-appendto-sign2='ssh -NfL 22002:sign-2.urd.appendto.org:22 statler.nordu.net'
alias tunnel-nordberg-mail='ssh -Nf -L 1126:localhost:25 lnmail.nordberg.se && echo "1126 -> imap.nordberg.se:25"'
alias tunnel-proxy='ssh -Nf -L 8080:localhost:8080 mgv.nordberg.se && echo "8080 -> mgv.nordberg.se:8080"'
alias tunnel-rs0='ssh -NfL 7001:10.3.3.1:22 mm.adb-centralen.se'
alias tunnel-rs0web='ssh -NfL 4780:localhost:80 rs0-1.dfri.net'
alias tunnel-rs3web='ssh -NfL 4783:localhost:80 rs3.dfri.net'
alias tunnel-rs4web='ssh -NfL 4784:localhost:80 rs4.dfri.net'
alias tunnel-slime='ssh -Nf -L 4711:localhost:4711 lntest.nordberg.se'
alias tunnel-sieve='ssh -Nf -L 4190:imap.adb-centralen.se:4190 ioctl.adb-centralen.se'
alias xmpp='xmpp-client'
alias xmpp-ndn='xmpp-client -config-file ~/tstick/.xmpp-client.ndn'
