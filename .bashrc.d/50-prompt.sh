if [ $UID = 0 ]; then PROMPTCHAR="#"; else PROMPTCHAR="%"; fi
PS1="\h:\W$PROMPTCHAR "; export PS1
