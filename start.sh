#!/bin/sh

strong_kill() {
    echo "🛑 Dừng các tiến trình..."
    for process in nev.py negan.py prxscan.py monitor.sh start.sh; do
        pids=$(pgrep -f "$process" 2>/dev/null)
        if [ -n "$pids" ]; then
            echo "• Đang dừng $process (PIDs: $pids)"
            kill -9 $pids 2>/dev/null
            pkill -9 -P $pids 2>/dev/null
        else
            echo "• $process: không tìm thấy"
        fi
    done
}

countdown() {
    local sec=$1
    while [ $sec -gt 0 ]; do
        echo "⏳ $(date -u -d @$sec +%H:%M:%S)"
        sleep 1
        sec=$((sec-1))
    done
}

# Khởi chạy
echo "🚀 Khởi động các tiến trình"
python3 nev.py &
python3 negan.py &
python3 prxscan.py -l list.txt &
./monitor.sh &

# Chờ
countdown 1740

# Hoàn tất
echo "🌐 Gửi yêu cầu deploy..."
curl -sS -X POST https://hook.sevalla.com/apps/a28e8908-c56e-4d8f-b2d7-81a80eef7da4/deploy/totunqknzsoj

strong_kill
