#! /bin/sh

[ $# -lt 1 ] && { echo "usage: $0 map"; exit 1; }
map=$1
setxkbmap -option caps:ctrl_modifier $map
