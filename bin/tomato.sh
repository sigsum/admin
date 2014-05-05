#! /bin/sh

MSG="Un Pomodoro!"

if [ `which xalarm` ]; then
    xalarm -nowarn -t +0:25 "$MSG" && /bin/date
elif [ `which sanduhr` ]; then
    sanduhr --message="$MSG" "+25 min" & /bin/date
else
    echo "$0: alarm program not found"
fi
