#!/bin/sh

# Hàm xử lý tín hiệu dừng
handle_exit() {
    echo "Nhận tín hiệu dừng. Đang dừng script mà không chạy sleep và setup.sh..."
    strong_kill
    exit 1
}

# Đăng ký hàm xử lý tín hiệu dừng
trap handle_exit TERM INT

# Hàm kill mạnh mẽ các tiến trình
strong_kill() {
    processes="rev.py negan.py prxscan.py monitor.sh start.sh"  # Danh sách các tiến trình cần kill
    for process in $processes; do
        echo "Đang kill tiến trình: $process"

        # Kill tiến trình chính
        pkill -9 -f "$process" 2>/dev/null || true

        # Kill các tiến trình con (nếu có)
        for pid in $(pgrep -f "$process"); do
            echo "Đang kill tiến trình con của $process (PID: $pid)"
            pkill -9 -P "$pid" 2>/dev/null || true
        done

        if pgrep -f "$process" > /dev/null; then
            echo "Không thể kill tiến trình $process."
        else
            echo "Đã kill tiến trình $process thành công."
        fi
    done

    echo "Đang kill tất cả các tiến trình liên quan bằng killall..."
    killall -9 -q $processes 2>/dev/null || true

    for process in $processes; do
        if pgrep -f "$process" > /dev/null; then
            echo "Cảnh báo: Tiến trình $process vẫn đang chạy."
        else
            echo "Xác nhận: Tiến trình $process đã bị kill."
        fi
    done
}

# Hàm đếm ngược thời gian
countdown() {
    local seconds=$1
    while [ $seconds -gt 0 ]; do
        echo "Thời gian sleep còn lại: $seconds giây"
        sleep 1
        seconds=$((seconds - 1))
    done
}

# Chạy bot Python
python3 nev.py &
NEV_PID=$!

python3 negan.py &
NEGAN_PID=$!

# Chạy proxy scanner
python3 prxscan.py -l list.txt &
PRXSCAN_PID=$!

# Chạy monitor.sh
./monitor.sh &
MONITOR_PID=$!

# -----------------------------
# ✅ Đổi countdown 9 phút thành 29 phút và chạy curl sau khi đếm xong
echo "Đang đợi 29 phút..."
countdown 1740 &
COUNTDOWN_PID=$!

# Đợi countdown hoàn thành
if wait $COUNTDOWN_PID 2>/dev/null; then
    if kill -0 $$ 2>/dev/null; then
        echo "Đang gửi yêu cầu deploy..."
        curl -X POST https://hook.sevalla.com/apps/249acaf2-9e8a-4f8d-a0d3-0584ae5e3870/deploy/lsdlcgqeklag
        strong_kill
    else
        echo "Script bị kill đột ngột."
        strong_kill
        exit 1
    fi
else
    echo "Countdown bị gián đoạn."
    strong_kill
    exit 1
fi
