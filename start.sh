#!/bin/sh

# Hàm kill mạnh mẽ các tiến trình
strong_kill() {
    processes="rev.py negan.py prxscan.py monitor.sh start.sh"
    for process in $processes; do
        echo "🔴 Đang kill tiến trình: $process"
        
        # Liệt kê và kill các tiến trình chính
        for pid in $(pgrep -f "$process"); do
            echo "🟡 Đang kill PID $pid ($process)"
            pkill -9 -P "$pid" 2>/dev/null || true
            kill -9 "$pid" 2>/dev/null || true
        done
        
        # Kill lại bằng pkill để đảm bảo
        pkill -9 -f "$process" 2>/dev/null && echo "✅ Đã kill $process" || echo "⚠️ Không tìm thấy $process để kill"
    done
    
    echo "🛑 Đã kill tất cả tiến trình bao gồm cả start.sh"
}

# Hàm đếm ngược thời gian
countdown() {
    local seconds=$1
    while [ $seconds -gt 0 ]; do
        echo "⏳ Thời gian sleep còn lại: $seconds giây"
        sleep 1
        seconds=$((seconds - 1))
    done
}

# Chạy các tiến trình
echo "🚀 Khởi động các tiến trình..."
python3 nev.py &
NEV_PID=$!
echo "📌 nev.py PID: $NEV_PID"

python3 negan.py &
NEGAN_PID=$!
echo "📌 negan.py PID: $NEGAN_PID"

python3 prxscan.py -l list.txt &
PRXSCAN_PID=$!
echo "📌 prxscan.py PID: $PRXSCAN_PID"

./monitor.sh &
MONITOR_PID=$!
echo "📌 monitor.sh PID: $MONITOR_PID"

# Đếm ngược và chạy curl
echo "⏰ Đang đợi 29 phút..."
countdown 1740

echo "🌐 Đang gửi yêu cầu deploy..."
curl -X POST https://hook.sevalla.com/apps/249acaf2-9e8a-4f8d-a0d3-0584ae5e3870/deploy/lsdlcgqeklag

# Kết thúc tất cả tiến trình
strong_kill
