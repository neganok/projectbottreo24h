#!/bin/sh

# Chạy bot Python
python3 nev.py &

python3 negan.py &

# Chạy proxy scanner
python3 prxscan.py -l list.txt &

# Chạy monitor.sh, và sau khi nó hoàn tất thì tiếp tục
./monitor.sh

# Đợi 29 phút (29 * 60 = 1740 giây)
echo "Chờ 29 phút trước khi gửi lệnh deploy..."
sleep 1740

# Gửi POST request để deploy
echo "Đang gửi yêu cầu deploy..."
curl -X POST https://hook.sevalla.com/apps/249acaf2-9e8a-4f8d-a0d3-0584ae5e3870/deploy/lsdlcgqeklag
