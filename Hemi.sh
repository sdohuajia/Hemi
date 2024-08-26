#!/bin/bash

# 脚本保存路径
SCRIPT_PATH="$HOME/Hemi.sh"

# 生成密钥函数
generate_key() {
    URL="https://github.com/hemilabs/heminetwork/releases/download/v0.3.2/heminetwork_v0.3.2_linux_amd64.tar.gz"
    FILENAME="heminetwork_v0.3.2_linux_amd64.tar.gz"
    DIRECTORY="heminetwork_v0.3.2_linux_amd64"
    KEYGEN="./keygen"
    OUTPUT_FILE="$HOME/popm-address.json"

    echo "正在下载 $FILENAME..."
    wget -q "$URL" -O "$FILENAME"

    if [ $? -eq 0 ]; then
        echo "下载完成。"
    else
        echo "下载失败。"
        exit 1
    fi

    echo "正在解压 $FILENAME..."
    tar -xzvf "$FILENAME"

    if [ $? -eq 0 ]; then
        echo "解压完成。"
    else
        echo "解压失败。"
        exit 1
    fi

    echo "删除压缩文件..."
    rm "$FILENAME"

    echo "进入目录 $DIRECTORY..."
    cd "$DIRECTORY" || { echo "目录 $DIRECTORY 不存在。"; exit 1; }

    echo "正在生成公钥..."
    $KEYGEN -secp256k1 -json -net="testnet" > "$OUTPUT_FILE"

    echo "公钥生成完成。输出文件：$OUTPUT_FILE"
    echo "正在查看密钥文件内容..."
    cat "$OUTPUT_FILE"

    echo "按任意键返回主菜单栏..."
    read -n 1 -s
}

# 运行节点函数
run_node() {
    DIRECTORY="heminetwork_v0.3.2_linux_amd64"

    echo "进入目录 $DIRECTORY..."
    cd "$HOME/$DIRECTORY" || { echo "目录 $DIRECTORY 不存在。"; exit 1; }

    echo "设置环境变量并启动节点..."

    echo "请替换 <private_key> 为你的实际私钥。"
    echo "POPM_STATIC_FEE 的默认值为 50 (单位：sat/vB)，如果需要其他值，请在脚本中替换。"

    # 设置环境变量（请根据需要替换实际值）
    export POPM_BTC_PRIVKEY="<private_key>"
    export POPM_STATIC_FEE="50"  # 默认费用为 50 sat/vB
    export POPM_BFG_URL="wss://testnet.rpc.hemi.network/v1/ws/public"

    echo "启动节点..."
    ./popmd

    echo "按任意键返回主菜单栏..."
    read -n 1 -s
}

# 主菜单函数
main_menu() {
    while true; do
        clear
        echo "脚本由大赌社区哈哈哈哈编写，推特 @ferdie_jhovie，免费开源，请勿相信收费"
        echo "================================================================"
        echo "节点社区 Telegram 群组: https://t.me/niuwuriji"
        echo "节点社区 Telegram 频道: https://t.me/niuwuriji"
        echo "节点社区 Discord 社群: https://discord.gg/GbMV5EcNWF"
        echo "退出脚本，请按键盘 ctrl + C 退出即可"
        echo "请选择要执行的操作:"
        echo "1. 生成密钥"
        echo "2. 运行节点"
        echo "3. 退出"

        read -p "请输入选项 [1-3]: " option

        case $option in
            1)
                generate_key
                ;;
            2)
                run_node
                ;;
            3)
                echo "退出脚本。"
                exit 0
                ;;
            *)
                echo "无效选项，请重新选择。"
                ;;
        esac
    done
}

# 执行主菜单函数
main_menu
