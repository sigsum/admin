#! /usr/bin/env bash

#
# A simple script that downloads sigsum's ms and db pads periodcally.
# Downloaded pads that are older than $age_days are silently removed.
#
# It is assumed that both pads contain the pattern $match.  You may want
# to keep an eye on the resulting log file.  It should always be empty.
#
# Crontab at the 16th minute every three hours:
#
#     16 */3 * * * /path/to/savepads.sh /path/to/download/dir >>/some/log/file 2>&1
#

set -eu
trap EXIT

prefix="https://pad.sigsum.org/p"
suffix="export/txt"
age_days=30

dir="$1"; shift
pads="sigsum-ms sigsum-db"
match="This pad describes"

function main() {
	for pad in $pads; do
		src=$prefix/$pad/$suffix
		dst=$dir/$(date "+%y%m%d-%H%M%S")_$pad
		curl "$src" > "$dst" 2>/dev/null ||
			die_with_error "must fetch $pad"

		grep "$match" "$dst" ||
			die_with_error "expected \"$match\" to be in $src"

		find "$dir" -type f -mtime +$age_days -regextype posix-extended -regex "^.*[0-9]{6}-[0-9]{6}_$pad$" -delete
	done
}

function die_with_error(){
	echo "$(date \"+%y-%m-%d %H:%M:%S %Z\") [FATA]" "$@" >&2
	exit 1
}

main
