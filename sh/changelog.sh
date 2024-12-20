#!/bin/bash

# Màu sắc cho output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Lấy ngày hiện tại
CURRENT_DATE=$(date +"%Y-%m-%d")
CHANGELOG_FILE="CHANGELOG.md"

echo -e "${GREEN}Đang tạo changelog từ nhánh develop...${NC}"

# Kiểm tra xem đang ở trong git repository không
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Lỗi: Không phải git repository"
    exit 1
fi

# Tạo hoặc cập nhật file CHANGELOG.md
if [ ! -f $CHANGELOG_FILE ]; then
    echo "# Changelog" > $CHANGELOG_FILE
    echo "" >> $CHANGELOG_FILE
fi

# Lấy hash của commit cuối cùng được ghi trong CHANGELOG
LAST_COMMIT=$(grep -m 1 "Commit:" $CHANGELOG_FILE | cut -d' ' -f2 || echo "")

# Tạo nội dung changelog mới
echo -e "${BLUE}Đang phân tích lịch sử commit...${NC}"

# Tạo changelog tạm thời
TEMP_LOG=$(mktemp)

# Header cho changelog mới
echo "## [$CURRENT_DATE]" > $TEMP_LOG
echo "" >> $TEMP_LOG

if [ -z "$LAST_COMMIT" ]; then
    # Nếu chưa có commit nào được ghi, lấy tất cả commit từ develop
    git log develop --pretty=format:"### %s%n- Tác giả: %an%n- Ngày: %ad%n- Commit: %H%n%n%b%n" --date=format:"%Y-%m-%d %H:%M:%S" > $TEMP_LOG
else
    # Lấy các commit mới từ commit cuối cùng đã ghi
    git log $LAST_COMMIT..develop --pretty=format:"### %s%n- Tác giả: %an%n- Ngày: %ad%n- Commit: %H%n%n%b%n" --date=format:"%Y-%m-%d %H:%M:%S" > $TEMP_LOG
fi

# Kiểm tra xem có commit mới không
if [ ! -s $TEMP_LOG ]; then
    echo -e "${YELLOW}Không có commit mới để tạo changelog${NC}"
    rm $TEMP_LOG
    exit 0
fi

# Thêm changelog mới vào đầu file
echo -e "${GREEN}Đang cập nhật file changelog...${NC}"
if [ -f $CHANGELOG_FILE ]; then
    # Lưu nội dung cũ
    mv $CHANGELOG_FILE $CHANGELOG_FILE.bak
    # Gộp nội dung mới và cũ
    cat $TEMP_LOG $CHANGELOG_FILE.bak > $CHANGELOG_FILE
    rm $CHANGELOG_FILE.bak
else
    cat $TEMP_LOG > $CHANGELOG_FILE
fi

# Xóa file tạm
rm $TEMP_LOG

echo -e "${GREEN}Đã tạo changelog thành công!${NC}"
echo -e "${BLUE}File changelog: $CHANGELOG_FILE${NC}"

# Hiển thị changelog mới
echo -e "${YELLOW}Changelog mới:${NC}"
head -n 20 $CHANGELOG_FILE
