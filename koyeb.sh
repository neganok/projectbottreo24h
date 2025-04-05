#!/bin/bash

# Kiểm tra và cài đặt Koyeb CLI nếu chưa có
command -v koyeb &>/dev/null || (echo "Cài đặt Koyeb CLI..."; curl -fsSL https://raw.githubusercontent.com/koyeb/koyeb-cli/master/install.sh | sh)

export PATH=$HOME/.koyeb/bin:$PATH
export KOYEB_TOKEN=f66m2frs9zjsfdyjrelo82l7qn64fakjgfgnnafdmw6qfl1p9h55ue5nmlo7fs80

# Đếm số lần pause và resume
COUNT=1

# Tạm dừng và resume dịch vụ
pause_resume_service() {
  echo "Lần thứ $COUNT: Tạm dừng và resume dịch vụ wrong-alexia/setup..."
  koyeb service pause wrong-alexia/setup && sleep 20
  koyeb service resume wrong-alexia/setup && sleep 10
  ((COUNT++))
}

# Lần đầu tiên thực hiện hành động (pause và resume)
pause_resume_service

# Đếm thời gian và thực hiện lại sau 9 phút 30 giây
TIME_LEFT=570
while ((TIME_LEFT--)); do
  sleep 1
  echo "Thời gian còn lại tiếp tục pause và resume: $TIME_LEFT giây"
  if ((TIME_LEFT == 0)); then
    # Thực hiện lại pause và resume sau khi thời gian đếm ngược hoàn tất
    pause_resume_service
    TIME_LEFT=570
  fi
done 
