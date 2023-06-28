# git at times has trouble finding SSL certs
os=$(uname)
case $os in
    Linux) crtfile=/etc/ssl/certs/ca-certificates.crt ;;
    FreeBSD) crtfile=/usr/local/share/certs/ca-root-nss.crt ;;
esac
[ -f $crtfile ] && export GIT_SSL_CAINFO=$crtfile
