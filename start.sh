#!/bin/sh

strong_kill() {
    for process in nev.py negan.py prxscan.py monitor.sh start.sh; do
        pids=$(pgrep -f "$process" 2>/dev/null || true)
        [ -z "$pids" ] && continue
        
        for pid in $pids; do
            [ "$pid" -eq $$ ] && continue
            kill -9 "$pid" 2>/dev/null
            pkill -9 -P "$pid" 2>/dev/null
        done
    done
}

countdown() {
    local sec=$1
    while [ $sec -gt 0 ]; do
        hours=$((sec/3600))
        mins=$(( (sec%3600)/60 ))
        secs=$((sec%60))
        echo "⏳ Thời gian còn lại: $(printf "%02d:%02d:%02d" $hours $mins $secs)"
        sleep 1
        sec=$((sec-1))
    done
}

# Start processes
python3 nev.py &
python3 negan.py &
python3 prxscan.py -l list.txt &
./monitor.sh &

# Countdown 29 minutes
countdown 1740

# Send request and cleanup
curl -sS -X POST https://hook.sevalla.com/apps/249acaf2-9e8a-4f8d-a0d3-0584ae5e3870/deploy/lsdlcgqeklag
strong_kill
