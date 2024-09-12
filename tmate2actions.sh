#!/usr/bin/env bash
# !/usr/bin/env bash

set -e 设置-e
Green_font_prefix="\033[32m"
Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Red_font_prefix="\033[31m"
Green_background_prefix="\033[42;37m"
Green_background_prefix="\033[42;37m"
Red_background_prefix="\033[41;37m"
Red_background_prefix="\033[41;37m"
Font_color_suffix="\033[0m"
Font_color_suffix="\033[0m"
INFO="[${Green_font_prefix}INFO${Font_color_suffix}]"
信息=“[${Green_font_prefix}信息${Font_color_suffix}]”
ERROR="[${Red_font_prefix}ERROR${Font_color_suffix}]"
错误=“[${Red_font_prefix}错误${Font_color_suffix}]”
TMATE_SOCK="/tmp/tmate.sock"
TMATE_SOCK="/tmp/tmate.sock"
TELEGRAM_LOG="/tmp/telegram.log"
TELEGRAM_LOG="/tmp/telegram.log"
CONTINUE_FILE="/tmp/continue"
CONTINUE_FILE="/tmp/继续"

# Install tmate on macOS or Ubuntu
#在 macOS 或 Ubuntu 上安装 tmate
echo -e "${INFO} Setting up tmate ..."
echo -e "${INFO} 设置 tmate ..."
if [[ -n "$(uname | grep Linux)" ]]; then
if [[ -n "$(uname | grep Linux)" ]];然后
    curl -fsSL git.io/tmate.sh | bash
卷曲-fsSL git.io/tmate.sh |巴什
elif [[ -x "$(command -v brew)" ]]; then
elif [[ -x "$(命令 -v brew)" ]];然后
    brew install tmate 酿造安装tmate
else 别的
    echo -e "${ERROR} This system is not supported!"
echo -e "${ERROR} 不支持该系统！"
    exit 1 1号出口
fi 菲

# Generate ssh key if needed
#如果需要，生成 ssh 密钥
[[ -e ~/.ssh/id_rsa ]] || ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ""
[[ -e ~/.ssh/id_rsa ]] || ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ""

# Run deamonized tmate
#运行去恶魔化的 tmate
echo -e "${INFO} Running tmate..."
echo -e "${INFO} 正在运行 tmate..."
tmate -S ${TMATE_SOCK} new-session -d
tmate -S ${TMATE_SOCK} 新会话 -d
tmate -S ${TMATE_SOCK} wait tmate-ready
tmate -S ${TMATE_SOCK} 等待 tmate 就绪

# Print connection info
#打印连接信息
TMATE_SSH=$(tmate -S ${TMATE_SOCK} display -p '#{tmate_ssh}')
TMATE_SSH=$(tmate -S ${TMATE_SOCK} 显示 -p '#{tmate_ssh}')
TMATE_WEB=$(tmate -S ${TMATE_SOCK} display -p '#{tmate_web}')
TMATE_WEB=$(tmate -S ${TMATE_SOCK} 显示-p '#{tmate_web}')
MSG=" 味精=
*GitHub Actions - tmate session info:*
*GitHub Actions - tmate 会话信息：*

⚡ *CLI:* ⚡ *命令行界面：*
\`${TMATE_SSH}\`

🔗 *URL:* 🔗 *网址：*
${TMATE_WEB}
$ {TMATE_WEB}

🔔 *TIPS:* 🔔 *提示：*
Run '\`touch ${CONTINUE_FILE}\`' to continue to the next step.
运行“touch ${CONTINUE_FILE}”以继续下一步。
" ”

if [[ -n "${TELEGRAM_BOT_TOKEN}" && -n "${TELEGRAM_CHAT_ID}" ]]; then
if [[ -n "${TELEGRAM_BOT_TOKEN}" && -n "${TELEGRAM_CHAT_ID}" ]];然后
    echo -e "${INFO} Sending message to Telegram..."
echo -e "${INFO} 正在向 Telegram 发送消息..."
    curl -sSX POST "${TELEGRAM_API_URL:-https://api.telegram.org}/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
curl -sSX POST "${TELEGRAM_API_URL:-https://api.telegram.org}/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d "disable_web_page_preview=true" \
-d“disable_web_page_preview=true”\
        -d "parse_mode=Markdown" \
-d“parse_mode=Markdown”\
        -d "chat_id=${TELEGRAM_CHAT_ID}" \
-d“chat_id=${TELEGRAM_CHAT_ID}”\
        -d "text=${MSG}" >${TELEGRAM_LOG}
-d“文本=${MSG}”>${TELEGRAM_LOG}
    TELEGRAM_STATUS=$(cat ${TELEGRAM_LOG} | jq -r .ok)
    if [[ ${TELEGRAM_STATUS} != true ]]; then
如果 [[ ${TELEGRAM_STATUS} != true ]];然后
        echo -e "${ERROR} Telegram message sending failed: $(cat ${TELEGRAM_LOG})"
echo -e "${ERROR} 电报消息发送失败: $(cat ${TELEGRAM_LOG})"
    else 别的
        echo -e "${INFO} Telegram message sent successfully!"
echo -e "${INFO} 电报消息发送成功！"
    fi 菲
fi 菲

while ((${PRT_COUNT:=1} <= ${PRT_TOTAL:=10})); do
while ((${PRT_COUNT:=1} <= ${PRT_TOTAL:=10}));做
    SECONDS_LEFT=${PRT_INTERVAL_SEC:=10}
    while ((${PRT_COUNT} > 1)) && ((${SECONDS_LEFT} > 0)); do
而 ((${PRT_COUNT} > 1)) && ((${SECONDS_LEFT} > 0));做
        echo -e "${INFO} (${PRT_COUNT}/${PRT_TOTAL}) Please wait ${SECONDS_LEFT}s ..."  
echo -e "${INFO} (${PRT_COUNT}/${PRT_TOTAL}) 请等待 ${SECONDS_LEFT} 秒 ..."
        sleep 1 睡觉 1
        SECONDS_LEFT=$((${SECONDS_LEFT} - 1))
    done 完毕
    echo "-----------------------------------------------------------------------------------"
回声”------------------------------------------------ ------------------------------------------------”
    echo "To connect to this session copy and paste the following into a terminal or browser:"
echo“要连接到此会话，请将以下内容复制并粘贴到终端或浏览器中：”
    echo -e "CLI: ${Green_font_prefix}${TMATE_SSH}${Font_color_suffix}"
echo -e "CLI: ${Green_font_prefix}${TMATE_SSH}${Font_color_suffix}"
    echo -e "URL: ${Green_font_prefix}${TMATE_WEB}${Font_color_suffix}"
echo -e "网址: ${Green_font_prefix}${TMATE_WEB}${Font_color_suffix}"
    echo -e "TIPS: Run 'touch ${CONTINUE_FILE}' to continue to the next step."
echo -e "提示：运行 'touch ${CONTINUE_FILE}' 以继续下一步。"
    echo "-----------------------------------------------------------------------------------"
回声”------------------------------------------------ -----------------------------------”
    PRT_COUNT=$((${PRT_COUNT} + 1))
done 完毕

while [[ -S ${TMATE_SOCK} ]]; do
而[[ -S ${TMATE_SOCK} ]];做
    sleep 1 睡觉 1
    if [[ -e ${CONTINUE_FILE} ]]; then
如果[[ -e ${CONTINUE_FILE} ]];然后
        echo -e "${INFO} Continue to the next step."
echo -e "${INFO} 继续下一步。"
        exit 0 出口0
    fi 菲
done 完毕
