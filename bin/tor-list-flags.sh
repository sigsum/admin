#! /bin/sh
# usage cat cached-consensus | tor-list-flags.sh
awk '/^r /{r=$2}/^s /{print r,$0}' | sort
