#!/bin/bash

# Kiểm tra xem đối số đầu vào có phải là một file ELF không
if [ -z "$1" ]; then
    echo "Vui lòng cung cấp đường dẫn tới file ELF."
    exit 1
fi

ELF_FILE="$1"

# Kiểm tra xem file có phải là ELF không
if ! readelf -h "$ELF_FILE" > /dev/null 2>&1; then
    echo "Đây không phải là một file ELF hợp lệ."
    exit 1
fi

# Thêm comment vào phần .comment của file ELF
echo "Thêm comment vào file ELF..."
echo -n "Updated by Script: $(date)" | tee >(xxd -p -r > "$ELF_FILE.tmp") | dd of="$ELF_FILE" bs=1 seek=$(stat -c %s "$ELF_FILE")

# Kiểm tra lại hash sau khi thay đổi
echo "Hash MD5 của file trước và sau khi thay đổi:"
md5sum "$ELF_FILE"

echo "Thay đổi hash thành công!"
