#!/bin/bash

#chmod +x newbranch.sh

# Hỏi người dùng tên nhánh cần tạo
read -p "Nhập tên nhánh mới: " BRANCH

# Kiểm tra nếu người dùng không nhập gì
if [ -z "$BRANCH" ]; then
  echo "Lỗi: Tên nhánh không được để trống"
  exit 1
fi

# Tạo nhánh mới
git checkout -b "$BRANCH"

# Kiểm tra nếu lệnh thành công
if [ $? -eq 0 ]; then
  echo "Đã chuyển sang nhánh mới '$BRANCH'"
else
  echo "Không thể tạo nhánh '$BRANCH'"
fi
