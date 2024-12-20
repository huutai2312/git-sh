#!/bin/bash

# Màu sắc cho output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Bắt đầu cập nhật các dependencies...${NC}"

# Kiểm tra và cập nhật Composer packages
if [ -f "composer.json" ]; then
    echo -e "${GREEN}Đang cập nhật Composer packages...${NC}"
    composer update
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Lỗi: Không thể cập nhật Composer packages${NC}"
        exit 1
    fi
    
    # Tối ưu autoload
    echo -e "${GREEN}Đang tối ưu autoload...${NC}"
    composer dump-autoload
else
    echo -e "${YELLOW}Không tìm thấy file composer.json${NC}"
fi

# Kiểm tra và cập nhật NPM packages
if [ -f "package.json" ]; then
    echo -e "${GREEN}Đang cập nhật NPM packages...${NC}"
    
    # Kiểm tra xem có node_modules chưa
    if [ ! -d "node_modules" ]; then
        echo -e "${YELLOW}Thư mục node_modules không tồn tại. Đang cài đặt...${NC}"
        npm install
    fi
    
    # Cập nhật các packages
    npm update
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Lỗi: Không thể cập nhật NPM packages${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}Không tìm thấy file package.json${NC}"
fi

# Xóa cache Laravel nếu có
if [ -f "artisan" ]; then
    echo -e "${GREEN}Đang xóa cache Laravel...${NC}"
    php artisan cache:clear
    php artisan config:clear
    php artisan route:clear
    php artisan view:clear
fi

echo -e "${GREEN}Hoàn tất cập nhật tất cả dependencies!${NC}"
