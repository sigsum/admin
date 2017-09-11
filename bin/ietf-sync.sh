#! /bin/sh
DELETE="--delete-excluded --delete"
EXCLUDE="--exclude '*.p7s' --exclude '*.xml' --exclude '*.pdf'"
rsync -az $EXCLUDE $DELETE $1 server.nordu.net:/a/ftp/in-notes ~/usr/share/ietf/
rsync -az $EXCLUDE $DELETE $1 server.nordu.net:/a/ftp/internet-drafts ~/usr/share/ietf/
