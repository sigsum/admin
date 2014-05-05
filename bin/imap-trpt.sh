#! /bin/sh
ps x | awk '/[0-9]+ openssl s_client.*(imap.adb-centralen.se|kerio.nordu.net)/{print $1;}'
