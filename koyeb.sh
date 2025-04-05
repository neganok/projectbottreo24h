#!/bin/bash

# Kiểm tra và cài đặt Koyeb CLI nếu chưa có
command -v koyeb &>/dev/null || (echo "Cài đặt Koyeb CLI..."; curl -fsSL https://raw.githubusercontent.com/koyeb/koyeb-cli/master/install.sh | sh)

export PATH=$HOME/.koyeb/bin:$PATH
export KOYEB_TOKEN=f66m2frs9zjsfdyjrelo82l7qn64fakjgfgnnafdmw6qfl1p9h55ue5nmlo7fs80
REDEPLOY_COUNT=1

# Redeploy dịch vụ
redeploy_service() {
  echo "Tạm dừng và resume dịch vụ wrong-alexia/setup..."
  koyeb service pause wrong-alexia/setup && sleep 15
  koyeb service resume wrong-alexia/setup && sleep 3
  koyeb service redeploy wrong-alexia/setup
  echo "Đã redeploy lần thứ $REDEPLOY_COUNT"
  ((REDEPLOY_COUNT++))
}

# Lần đầu tiên thực hiện hành động
redeploy_service

# Đếm thời gian và thực hiện lại sau 9 phút 30 giây
TIME_LEFT=570
while ((TIME_LEFT--)); do
  sleep 1
  echo "Thời gian còn lại tiếp tục redeploy: $TIME_LEFT giây"
  if ((TIME_LEFT == 0)); then
    redeploy_service
    TIME_LEFT=570
  fi
done
