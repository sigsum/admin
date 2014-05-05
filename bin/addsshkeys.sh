#! /bin/sh

ssh-add -t 5m ~/.ssh/id_dsa
ssh-add -t 4h ~/.ssh/jails ~/.ssh/linus@torproject.org
ssh-add -t 10h ~/.ssh/linus.nordu.net
