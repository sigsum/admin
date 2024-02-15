#! /usr/bin/bash

set -eu

project=st; [ $# -gt 0 ] && { project="$1"; shift; }
email='linus.nordberg@glasklarteknik.se'

case "$project" in
    glasklar|sigsum|st)
	git config gpg.ssh.allowedSignersFile "~/usr/src/$project/allowed_signers"
	git config user.email "$email"
	git config commit.gpgSign true
	git config tag.gpgSign true
	;;
    *)
	echo "$0: $project: unknown project"
	exit 1
esac
