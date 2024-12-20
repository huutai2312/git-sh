#!/bin/bash

# Kiểm tra và cấp quyền thực thi cho các file script
check_and_chmod() {
    local script=$1
    if [ ! -x "$script" ]; then
        echo "Đang cấp quyền thực thi cho $script..."
        chmod +x "$script"
    fi
}

# Hiển thị menu
show_menu() {
    echo "=== QUẢN LÝ GIT ==="
    echo "1. Tạo nhánh mới (tạo nhánh mới)"
    echo "2. Merge code (merge nhánh hiện tại vào develop)" 
    echo "3. Migration (migrate db và seeding dữ liệu)"
    echo "4. Merge code develop vào master (merge nhánh develop và master)"
    echo "5. Changelog (tạo changelog từ nhánh develop)"
    echo "6. Update node_modules và vendor (update các module và vendor)"
    echo "0. Thoát"
    echo "================="
}

# Xử lý lựa chọn của người dùng
handle_choice() {
    case $1 in
        1)
            check_and_chmod "sh/newbranch.sh"
            read -p "Nhập tên nhánh mới: " branch_name
            sh/newbranch.sh "$branch_name"
            ;;
        2)
            check_and_chmod "sh/merge.sh"
            sh/merge.sh
            ;;
        3)
            check_and_chmod "sh/migrate.sh"
            sh/migrate.sh
            ;;  
        4)
            check_and_chmod "sh/devtomas.sh"
            sh/devtomas.sh
            ;;
        5)
            check_and_chmod "sh/changelog.sh"
            sh/changelog.sh
            ;;
        6)
            check_and_chmod "sh/update-node-module-vendor.sh"
            sh/update-node-module-vendor.sh
            ;;
        0)
            echo "Tạm biệt!"
            exit 0
            ;;
        *)
            echo "Lựa chọn không hợp lệ!"
            ;;
    esac
}

# Main loop
while true; do
    show_menu
    read -p "Nhập lựa chọn của bạn: " choice
    handle_choice $choice
    echo # Thêm dòng trống
    read -p "Nhấn Enter để tiếp tục..."
    clear
done
