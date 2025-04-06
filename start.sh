#!/bin/sh

strong_kill() {
    processes="rev.py negan.py prxscan.py monitor.sh start.sh"
    for process in $processes; do
        echo "🔴 Đang xử lý tiến trình: $process"
        
        # Kiểm tra và liệt kê PID trước khi kill
        pids=$(pgrep -f "$process" || true)
        
        if [ -z "$pids" ]; then
            echo "ℹ️ $process không chạy hoặc không tìm thấy"
            continue
        fi

        for pid in $pids; do
            # Bỏ qua PID 1 (start.sh chính) nếu là tiến trình hiện tại
            if [ "$pid" -eq $$ ] && [ "$process" = "start.sh" ]; then
                echo "⚠️ Bỏ qua tự kill start.sh (PID $$)"
                continue
            fi
            
            echo "🟡 Đang kill PID $pid ($process)"
            kill -9 "$pid" 2>/dev/null || true
            pkill -9 -P "$pid" 2>/dev/null || true
        done
        
        # Xác minh
        if pgrep -f "$process" >/dev/null; then
            echo "❌ Không thể kill $process"
        else
            echo "✅ $process đã được dừng"
        fi
    done
}

countdown() {
    local seconds=$1
    while [ $seconds -gt 0 ]; do
        printf "⏳ Thời gian còn lại: %02d:%02d:%02d\r" \
               $((seconds/3600)) $(( (seconds%3600)/60 )) $((seconds%60))
        sleep 1
        seconds=$((seconds - 1))
    done
    echo
}

# Chạy các tiến trình
echo "🚀 Khởi động các tiến trình..."
python3 nev.py &
python3 negan.py &
python3 prxscan.py -l list.txt &
./monitor.sh &

# Đếm ngược
echo "⏰ Đang đợi 29 phút..."
countdown 1740

echo "🌐 Đang gửi yêu cầu deploy..."
curl -sS -X POST https://hook.sevalla.com/apps/249acaf2-9e8a-4f8d-a0d3-0584ae5e3870/deploy/lsdlcgqeklag

# Kết thúc
strong_kill
exit 0
