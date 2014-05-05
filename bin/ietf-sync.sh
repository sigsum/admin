#! /bin/sh
rsync -az $1 server.nordu.net:/a/ftp/in-notes ~/usr/share/ietf/
rsync -az $1 server.nordu.net:/a/ftp/internet-drafts ~/usr/share/ietf/

