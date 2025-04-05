#!/bin/bash

# Kiểm tra và cài đặt Koyeb CLI nếu chưa có
command -v koyeb &>/dev/null || (echo "Cài đặt Koyeb CLI..."; curl -fsSL https://raw.githubusercontent.com/koyeb/koyeb-cli/master/install.sh | sh)

export PATH=$HOME/.koyeb/bin:$PATH
export KOYEB_TOKEN=f66m2frs9zjsfdyjrelo82l7qn64fakjgfgnnafdmw6qfl1p9h55ue5nmlo7fs80
REDEPLOY_COUNT=1

# Redeploy dịch vụ
redeploy_service() {
  echo "Tạm dừng và resume dịch vụ wrong-alexia/setup..."
  koyeb service pause wrong-alexia/setup && sleep 20
  koyeb service resume wrong-alexia/setup && sleep 5
  # Chỉ thực hiện redeploy từ lần 1 trở đi
  if ((REDEPLOY_COUNT > 1)); then
    koyeb service redeploy wrong-alexia/setup
    echo "Đã redeploy lần thứ $REDEPLOY_COUNT"
  else
    echo "Chỉ thực hiện pause và resume lần đầu."
  fi
  ((REDEPLOY_COUNT++))
}

# Lần đầu tiên thực hiện hành động (chỉ pause và resume)
redeploy_service

# Đếm thời gian và thực hiện lại sau 9 phút 30 giây
TIME_LEFT=570
while ((TIME_LEFT--)); do
  sleep 1
  echo "Thời gian còn lại tiếp tục redeploy: $TIME_LEFT giây"
  if ((TIME_LEFT == 0)); then
    # Thực hiện lại redeploy sau khi thời gian đếm ngược hoàn tất
    redeploy_service
    TIME_LEFT=570
  fi
done
