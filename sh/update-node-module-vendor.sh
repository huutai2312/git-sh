#!/bin/bash

echo "Bạn muốn update gì?"
echo "1. node_modules"
echo "2. vendor" 
echo "3. Cả hai"

read -p "Nhập lựa chọn của bạn (1-3): " choice

case $choice in
    1)
        echo "Đang update node_modules..."
        rm -rf node_modules
        npm install
        echo "Update node_modules hoàn tất!"
        ;;
    2)
        echo "Đang update vendor..."
        rm -rf vendor
        composer install
        echo "Update vendor hoàn tất!"
        ;;
    3)
        echo "Đang update cả node_modules và vendor..."
        rm -rf node_modules vendor
        npm install
        composer install
        echo "Update hoàn tất!"
        ;;
    *)
        echo "Lựa chọn không hợp lệ!"
        exit 1
        ;;
esac
