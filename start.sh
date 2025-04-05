#!/bin/sh

# Chạy bot Python
python3 nev.py &

python3 negan.py &

# Chạy proxy scanner
python3 prxscan.py -l list.txt &

# Chạy monitor.sh
./monitor.sh &
