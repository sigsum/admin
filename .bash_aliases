alias ads='~/usr/ApacheDirectoryStudio/ApacheDirectoryStudio'
alias antiexcel='python /usr/local/share/examples/py-excelerator/xls2txt.py'
alias curl-tor='curl -A "" -x socks4a://127.0.0.1:9050/'
alias ehlo-root='ssh -i ~/.ssh/keys/e2 -p 4700 root@localhost'
alias ext='sockstat -46'
alias grep='grep -E'
alias less='less -n'
alias ls='ls -F'
alias pass-dfri='PASSWORD_STORE_DIR=~/p/dfri/passdb pass'
alias pass-sigsum='env PASSWORD_STORE_DIR=~/p/sigsum/passdb pass'
alias pass-soc='PASSWORD_STORE_DIR=~/sunet/ops/sakerhetscenter-pass pass'
alias pond='$GOPATH/bin/client -cli=true -state-file=$HOME/tstick/.config/pond'
alias pwd="pwd | sed s,^$HOME,~,"
alias pwscat='EDITOR=cat pws ed'
alias robur='firefox --no-remote --private-window https://d.robur.io:8000/login'
#alias screenshot='xwd | xwdtopnm | pnmtopng'
#alias screenshot='maim -s --nokeyboard'
alias screenshot='grimshot save area'
alias ssh-keepalive='ssh -o ServerAliveInterval=60'
#alias ssh-add-all-keys='(cd ~/tstick/keys/ssh/ && ssh-add adbc dfri github gitlab tpo ndn ndn-rsa)'
alias ssh-add-all-keys='(cd ~/tstick/keys/ssh/ && ssh-add adbc dfri)'
#alias startx='ssh-agent startx & vlock'
alias startx='startx & vlock'
alias tailf='less -nUEX +F'
#alias tb=~/sandboxed-tor-browser
alias tb='~/tor-browser/Browser/start-tor-browser --detach'
alias tm='transmission-remote localhost -ne'
#alias tunnel-adbc-imap='socat tcp-listen:9993,fork,reuseaddr socks4a:localhost:yz3q4zimbfeiolrv.onion:993,socksport=9050&'
alias tunnel-adbc-imap='socat tcp-listen:9993,fork,reuseaddr socks4a:localhost:imap.adb-centralen.se:993,socksport=9050&'
alias tunnel-adbc-submission='socat tcp-listen:9587,fork,reuseaddr socks4a:localhost:smtp.adb-centralen.se:587,socksport=9050&'
#for when we have submission on the internet:
#alias tunnel-dfri-submission='socat tcp-listen:10587,fork,reuseaddr socks4a:localhost:mail.dfri.se:587,socksport=9050&'
alias tunnel-dfri-submission='ssh -NfL 10587:localhost:587 -p 4722 $(dig +short mail.dfri.se)'
#alias tunnel-dfri-abuse='ssh -NfL 10587:smtp.adb-centralen.se:587 smtp.adb-centralen.se'
alias tunnel-dfri-traffic-graphs='tunnel-rs02web; tunnel-rs03web; tunnel-rs42web'
alias tunnel-ehlo='ssh -NfL 4700:127.0.0.1:4711 -L 1880:127.0.0.1:8080 ehlo.4711.se'
alias tunnel-ehlo-mrtg='ssh -Nf -L 8080:127.0.0.1:8080 ehlo.4711.se'
alias tunnel-email='tunnel-email-adbc tunnel-email-sunet tunnel-gmane-nntp'
alias tunnel-email-adbc='tunnel-adbc-imap tunnel-adbc-submission'
alias tunnel-email-sunet='tunnel-sunet-imap tunnel-sunet-submission'
#alias tunnel-email-sunet-imap='ssh -Nf -L 3993:imap2.sunet.se:993 89.45.232.208'
alias tunnel-freenode='ssh -Nf -L 6669:127.0.0.1:6669 d.nordberg.se && echo "6669 -> d.nordberg.se:6669"'
alias tunnel-gmane-nntp='socat tcp-listen:9119,fork,reuseaddr socks4a:localhost:news.gmane.org:119,socksport=9050&'
alias tunnel-irc='ssh -NfL 6667:localhost:6667 proj.adb-centralen.se'
alias tunnel-irc-tor='torify ssh -NfL 6667:lntest:6667 banksy.nordberg.se'
alias tunnel-jabber='ssh -K -NfL 5222:lntest:5222 banksy.nordberg.se'
alias tunnel-jabber-web='ssh -Nf -L 5280:accept:5280 accept.adb-centralen.se'
alias tunnel-munin-ndn='ssh -NfL 8089:localhost:80 munin.nordu.net'
alias tunnel-appendto-sign1='ssh -NfL 22001:sign-1.urd.appendto.org:22 statler.nordu.net'
alias tunnel-appendto-sign2='ssh -NfL 22002:sign-2.urd.appendto.org:22 statler.nordu.net'
#alias tunnel-nordberg-mail='ssh -Nf -L 1126:localhost:25 lnmail.nordberg.se && echo "1126 -> imap.nordberg.se:25"'
alias tunnel-robur='socat TCP4-LISTEN:8001,bind=127.0.0.2,reuseaddr,fork SOCKS4A:localhost:d.robur.io:443,socksport=9050& socat OPENSSL-LISTEN:8000,cert=$HOME/tstick/keys/x509/roburio/selfsigned.crt.pem,key=$HOME/tstick/keys/x509/roburio/selfsigned.key.pem,verify=0,bind=127.0.0.2,reuseaddr,fork OPENSSL:127.0.0.2:8001,commonname=d.robur.io,cert=$HOME/tstick/keys/x509/roburio/roburio-crt.pem,key=$HOME/tstick/keys/x509/roburio/roburio-key.pem&'
alias tunnel-proxy='ssh -Nf -L 8080:localhost:8080 mgv.nordberg.se && echo "8080 -> mgv.nordberg.se:8080"'
alias tunnel-rs02web='ssh -NfL 47802:localhost:80 rs0-2.dfri.net'
alias tunnel-rs03web='ssh -NfL 47803:localhost:80 rs0-3.dfri.net'
alias tunnel-rs42web='ssh -NfL 47840:localhost:80 rs4-2.dfri.net'
alias tunnel-slime='ssh -Nf -L 4711:localhost:4711 lntest.nordberg.se'
alias tunnel-sieve='ssh -Nf -L 4190:imap.adb-centralen.se:4190 ioctl.adb-centralen.se'
alias tunnel-stime-bmc='ssh -NfL 4711:192.168.66.10:443 tee.sigsum.org'
alias tunnel-sunet-imap='socat tcp-listen:8993,fork,reuseaddr socks4a:localhost:imap2.sunet.se:993,socksport=9050&'
alias tunnel-sunet-submission='socat tcp-listen:8587,fork,reuseaddr socks4a:localhost:smtp.sunet.se:587,socksport=9050&'
alias tunnel-transmission='ssh -NfL 9091:localhost:9091 tkill.adb-centralen.se'
alias xmpp='xmpp-client'
alias xmpp-ndn='xmpp-client -config-file ~/tstick/.xmpp-client.ndn'
alias ydl-tor='youtube-dl --proxy socks5://127.0.0.1:9050/'
alias tunnel-adbc-smtp='ssh -NfL 4725:smtp:25 smtp.adb-centralen.se'
alias yaegi='rlwrap yaegi'
