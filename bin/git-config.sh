#! /usr/bin/bash
set -eu

project=; [ $# -gt 0 ] && { project="$1"; shift; }

if [ -z "$project" ]; then
    # Try to guess project
    project="$(basename $PWD)"
fi

case "$project" in
    glasklar|sigsum|st)
	email='linus.nordberg@glasklarteknik.se'
	as="~/usr/src/$project/allowed_signers"
	[ -r "$as" ]
	git config gpg.ssh.allowedSignersFile "$as"
	git config user.email "$email"
	git config commit.gpgSign true
	git config tag.gpgSign true
	;;
    linus)
	email='linus@nordberg.se'
	as="~/allowed_signers"
	git config gpg.ssh.allowedSignersFile "$as"
	git config user.email "$email"
	git config commit.gpgSign true
	git config tag.gpgSign true
	;;
    *)
	echo "$0: $project: unknown project"
	exit 1
esac
