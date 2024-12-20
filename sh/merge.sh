#!/bin/bash

# Lấy nhánh hiện tại
CURRENT_BRANCH=$(git branch --show-current)

# Hỏi người dùng về branch
echo "Nhánh hiện tại là: $CURRENT_BRANCH"
read -p "Bạn muốn sử dụng nhánh này không? (y/n): " USE_CURRENT
if [[ $USE_CURRENT == "y" || $USE_CURRENT == "Y" ]]; then
    BRANCH=$CURRENT_BRANCH
else
    read -p "Nhập tên nhánh: " BRANCH
fi

# Hỏi nội dung commit
read -p "Nhập nội dung commit: " MESSAGE

# Code xong rồi thì commit và merge
git add .
git commit -m "$MESSAGE"
git push origin $BRANCH
git checkout develop
git merge $BRANCH
git push origin develop