#!/bin/bash

# Chuyển về nhánh master
echo "Đang chuyển về nhánh master..."
git checkout master

if [ $? -ne 0 ]; then
    echo "Lỗi: Không thể chuyển về nhánh master"
    exit 1
fi

# Pull những thay đổi mới nhất từ master
echo "Đang cập nhật nhánh master..."
git pull origin master

if [ $? -ne 0 ]; then
    echo "Lỗi: Không thể pull từ master"
    exit 1
fi

# Merge nhánh develop vào master
echo "Đang merge nhánh develop vào master..."
git merge develop

if [ $? -eq 0 ]; then
    echo "Đã merge develop vào master thành công"
    
    # Push các thay đổi lên remote
    echo "Đang push lên remote repository..."
    git push origin master
    
    if [ $? -eq 0 ]; then
        echo "Hoàn tất quá trình merge và push"
    else
        echo "Lỗi: Không thể push lên remote"
    fi
else
    echo "Lỗi: Có conflict khi merge develop vào master"
    echo "Vui lòng giải quyết conflict và thử lại"
fi
