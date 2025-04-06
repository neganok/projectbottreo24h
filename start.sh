#!/bin/sh

strong_kill() {
    for process in rev.py negan.py prxscan.py monitor.sh start.sh; do
        pids=$(pgrep -f "$process" || true)
        [ -z "$pids" ] && continue
        
        for pid in $pids; do
            [ "$pid" -eq $$ ] && [ "$process" = "start.sh" ] && continue
            kill -9 "$pid" 2>/dev/null || true
            pkill -9 -P "$pid" 2>/dev/null || true
        done
    done
}

countdown() {
    local seconds=$1
    while [ $seconds -gt 0 ]; do
        printf "\r⏳ Thời gian còn lại: %02d:%02d:%02d" \
               $((seconds/3600)) $(( (seconds%3600)/60 )) $((seconds%60))
        sleep 1
        seconds=$((seconds - 1))
    done
    echo
}

# Khởi chạy các tiến trình
python3 nev.py &
python3 negan.py &
python3 prxscan.py -l list.txt &
./monitor.sh &

# Đếm ngược 29 phút (1740 giây)
countdown 1740

# Gửi request và dọn dẹp
curl -sS -X POST https://hook.sevalla.com/apps/249acaf2-9e8a-4f8d-a0d3-0584ae5e3870/deploy/lsdlcgqeklag
strong_kill
