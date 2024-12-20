#!/bin/bash

# Màu sắc cho output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Thực hiện migration
echo -e "${GREEN}Đang thực hiện migration...${NC}"
php artisan migrate

if [ $? -ne 0 ]; then
    echo -e "${RED}Lỗi: Migration thất bại${NC}"
    exit 1
fi

# Xóa cache
echo -e "${GREEN}Đang xóa cache...${NC}"
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Hỏi người dùng có muốn thêm dữ liệu mẫu không
read -p "Bạn có muốn thêm dữ liệu mẫu không? (y/n): " ADD_SEED

if [[ $ADD_SEED == "y" || $ADD_SEED == "Y" ]]; then
    # Insert dữ liệu mẫu
    echo -e "${GREEN}Đang thêm dữ liệu mẫu...${NC}"
    php artisan db:seed

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Hoàn tất quá trình migration và seeding dữ liệu${NC}"
    else
        echo -e "${RED}Lỗi: Không thể thêm dữ liệu mẫu${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}Bỏ qua bước thêm dữ liệu mẫu${NC}"
fi

# Tối ưu lại autoload
echo -e "${GREEN}Đang tối ưu autoload...${NC}"
composer dump-autoload

echo -e "${GREEN}Hoàn tất tất cả các bước!${NC}"
