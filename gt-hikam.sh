#!/bin/bash

# الحصول على المسار الحقيقي حتى مع وجود روابط رمزية
get_script_real_path() {
    local source="${BASH_SOURCE[0]}"
    while [ -h "$source" ]; do
        local dir="$(cd -P "$(dirname "$source")" && pwd)"
        source="$(readlink "$source")"
        [[ $source != /* ]] && source="$dir/$source"
    done
    echo "$(cd -P "$(dirname "$source")" && pwd)"
}

SCRIPT_DIR="$(get_script_real_path)"
INSTALL_DIR="$HOME/.GT-hikam"
HIKAM_FILE="$SCRIPT_DIR/hikam.txt"
PID_FILE="$SCRIPT_DIR/.gt-hikam-notify.pid"
CONFIG_FILE="$SCRIPT_DIR/.gt-hikam.conf"
UPDATE_CHECK_TIMEOUT=3  # 3 ثواني للتحقق من التحديثات في الخلفية

GITHUB_HIKAM_RAW_URL="https://raw.githubusercontent.com/SalehGNUTUX/GT-hikam/main/hikam.txt"
DEFAULT_INTERVAL=$((15*60)) # 15 دقيقة
AUTO_UPDATE="ask"  # ask | always | never

# ألوان للعرض الجمالي
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# --- تحميل إعداد التحديث التلقائي إن وجد ---
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        . "$CONFIG_FILE"
    fi
}

save_config() {
    echo "AUTO_UPDATE=\"$AUTO_UPDATE\"" > "$CONFIG_FILE"
}

# --- دالة فحص التحديثات ---
check_update_hikam() {
    local remote_url="${GITHUB_HIKAM_RAW_URL}"
    local local_file="$HIKAM_FILE"
    local tmp_file
    tmp_file=$(mktemp)

    if ! curl -fsSL --max-time 3 "$remote_url" -o "$tmp_file" 2>/dev/null; then
        rm -f "$tmp_file"
        return 2
    fi

    if ! cmp -s "$local_file" "$tmp_file"; then
        rm -f "$tmp_file"
        return 1
    else
        rm -f "$tmp_file"
        return 0
    fi
}

# --- دالة جلب وتحديث ملف الحكم من GitHub ---
update_hikam() {
    local remote_url="${GITHUB_HIKAM_RAW_URL}"
    local local_file="$HIKAM_FILE"
    if curl -fsSL "$remote_url" -o "$local_file"; then
        echo "تم جلب وتحديث ملف الحكم بنجاح!"
        return 0
    else
        echo "فشل التحديث، تعذر جلب الملف!"
        return 1
    fi
}

# --- دالة تنفيذ منطق التحديث (حسب الإعداد أو سؤال المستخدم) ---
maybe_update_hikam() {
    check_update_hikam
    local status=$?
    if [ $status -eq 1 ]; then
        case "$AUTO_UPDATE" in
            always)
                update_hikam > /dev/null 2>&1
                ;;
            never)
                # تجاهل التحديث بصمت
                ;;
            *)
                read -p "يوجد تحديث جديد. هل تريد التحديث الآن؟ (y/n/a/never): " ans
                if [[ "$ans" == "y" ]]; then
                    update_hikam
                elif [[ "$ans" == "a" ]]; then
                    AUTO_UPDATE="always"
                    save_config
                    update_hikam
                elif [[ "$ans" == "never" ]]; then
                    AUTO_UPDATE="never"
                    save_config
                    echo "لن يتم سؤالك مجددًا."
                else
                    echo "تم تجاهل التحديث."
                fi
                ;;
        esac
    fi
}

# --- دالة البحث عن التحديثات في الخلفية (بدون انتظار) ---
check_update_background() {
    # تشغيل التحقق من التحديثات في عملية منفصلة في الخلفية مع timeout
    (
        if timeout $UPDATE_CHECK_TIMEOUT bash -c "
            tmp_file=\$(mktemp)
            if curl -fsSL --max-time $UPDATE_CHECK_TIMEOUT \"$GITHUB_HIKAM_RAW_URL\" -o \"\$tmp_file\" 2>/dev/null; then
                if ! cmp -s \"$HIKAM_FILE\" \"\$tmp_file\"; then
                    # يوجد تحديث جديد - نحفظ في ملف علامة
                    touch \"$SCRIPT_DIR/.update-available\"
                fi
            fi
            rm -f \"\$tmp_file\"
        " 2>/dev/null; then
            :
        fi
    ) &
    disown  # فصل العملية تماماً عن الـ shell
}

# --- عرض حكمة طرفية ---
get_random_hikma() {
    # التأكد من وجود ملف الحكم
    if [ ! -f "$HIKAM_FILE" ]; then
        echo "ملف الحكم غير موجود: $HIKAM_FILE" >&2
        return 1
    fi
    
    awk -v RS='%' '
    {
        gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", $0);
        if(length($0)>0) print $0
    }' "$HIKAM_FILE" | shuf -n 1
}

show_hikma_terminal() {
    local hikma
    hikma=$(get_random_hikma)
    
    if [ -z "$hikma" ]; then
        echo -e "${RED}لم يتم العثور على حكمة صالحة!${NC}"
        return 1
    fi
    
    # التحقق إذا كانت الحكمة من الأئمة
    local imam=""
    if [[ "$hikma" == *"الإمام مالك"* ]]; then
        imam="مالك"
    elif [[ "$hikma" == *"الإمام الشافعي"* ]]; then
        imam="الشافعي"
    elif [[ "$hikma" == *"الإمام أحمد"* ]]; then
        imam="أحمد بن حنبل"
    elif [[ "$hikma" == *"الإمام أبو حنيفة"* ]]; then
        imam="أبو حنيفة النعمان"
    fi
    
    # عرض جمالي
    local width=60
    local border_char="═"
    
    # إنشاء الحدود
    local border_line=""
    for ((i=0; i<width; i++)); do
        border_line+="$border_char"
    done
    
    # تقسيم النص إلى أسطر
    echo ""
    echo -e "${CYAN}╔${border_line}╗${NC}"
    
    # إذا كانت الحكمة من إمام، إضافة عنوان خاص
    if [ -n "$imam" ]; then
        local title=" حكمة من الإمام $imam "
        local title_padding=$(( (width - ${#title}) / 2 ))
        printf "${CYAN}║${NC}%${title_padding}s${MAGENTA}%s${NC}%$((width - title_padding - ${#title}))s${CYAN}║${NC}\n" "" "$title" ""
        echo -e "${CYAN}╠${border_line}╣${NC}"
    fi
    
    # عرض الحكمة مع تفقيط النص
    local words=($hikma)
    local line=""
    local line_length=0
    
    for word in "${words[@]}"; do
        if (( line_length + ${#word} + 1 > width - 4 )); then
            printf "${CYAN}║${NC} %-${width}s ${CYAN}║${NC}\n" "$line"
            line=""
            line_length=0
        fi
        if [ -z "$line" ]; then
            line="$word"
            line_length=${#word}
        else
            line="$line $word"
            line_length=$((line_length + ${#word} + 1))
        fi
    done
    
    if [ -n "$line" ]; then
        printf "${CYAN}║${NC} %-${width}s ${CYAN}║${NC}\n" "$line"
    fi
    
    echo -e "${CYAN}╚${border_line}╝${NC}"
    echo ""
}

# --- دوال الإشعارات الدورية ---
start_notify() {
    local interval="${1:-$DEFAULT_INTERVAL}"
    
    if [ -f "$PID_FILE" ]; then
        pid=$(cat "$PID_FILE")
        if kill -0 "$pid" 2>/dev/null; then
            echo "الإشعارات قيد التشغيل بالفعل (PID: $pid)"
            return 0
        fi
    fi
    
    # بدء عملية الإشعارات في الخلفية
    (
        while true; do
            sleep "$interval"
            
            # التحقق من التحديث بهدوء
            if timeout $UPDATE_CHECK_TIMEOUT check_update_hikam > /dev/null 2>&1; then
                :
            fi
            
            # عرض حكمة عشوائية في الإشعار
            local hikma=$(get_random_hikma)
            if [ -n "$hikma" ]; then
                notify-send -t 5000 "GT-hikam 📖" "$hikma" 2>/dev/null || true
            fi
        done
    ) &
    
    local bg_pid=$!
    echo "$bg_pid" > "$PID_FILE"
    echo "تم بدء الإشعارات (PID: $bg_pid) كل $interval ثانية"
}

stop_notify() {
    if [ -f "$PID_FILE" ]; then
        pid=$(cat "$PID_FILE")
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid"
            rm -f "$PID_FILE"
            echo "تم إيقاف الإشعارات (PID: $pid)"
        else
            rm -f "$PID_FILE"
            echo "لا توجد عملية إشعارات قيد التشغيل"
        fi
    else
        echo "لا توجد عملية إشعارات قيد التشغيل"
    fi
}

status_notify() {
    if [ -f "$PID_FILE" ]; then
        pid=$(cat "$PID_FILE")
        if kill -0 "$pid" 2>/dev/null; then
            echo "الإشعارات قيد التشغيل (PID: $pid)"
        else
            echo "الإشعارات متوقفة (ملف PID موجود لكن العملية غير نشطة)"
        fi
    else
        echo "الإشعارات متوقفة"
    fi
}

# --- دالة المساعدة ---
usage() {
    echo "الاستخدام: gt-hikam [خيارات]"
    echo "  عرض حكمة في الطرفية مع فحص التحديثات في الخلفية."
    echo ""
    echo "الخيارات:"
    echo "  -h, --help          عرض هذه المساعدة"
    echo "  --notify-start      يبدأ إشعارات الحكم كل 15 دقيقة افتراضيًا"
    echo "  --notify-stop       يوقف الإشعارات الدورية"
    echo "  --notify-status     يعرض حالة الإشعار"
    echo "  --check-update      فحص وجود تحديث فقط"
    echo "  --update-hikam      جلب آخر تحديث لملف الحكم مباشرة"
    echo "  --auto-update [always|never|ask]  تغيير سياسة التحديث التلقائي"
    echo "  --uninstall         تشغيل برنامج إلغاء التثبيت"
    echo ""
    echo "أمثلة:"
    echo "  gt-hikam                    # عرض حكمة"
    echo "  gt-hikam --update-hikam     # تحديث ملف الحكم"
    echo "  gt-hikam --uninstall        # إلغاء تثبيت البرنامج"
    exit 0
}

# --- بدء التنفيذ ---
load_config

MODE="terminal"
INTERVAL=$DEFAULT_INTERVAL

# معالجة الخيارات
if [[ $# -eq 0 ]]; then
    # لا توجد خيارات، عرض حكمة
    MODE="terminal"
else
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                usage
                ;;
            --notify-start)
                MODE="notify-start"
                shift
                ;;
            --notify-stop)
                MODE="notify-stop"
                shift
                ;;
            --notify-status)
                MODE="notify-status"
                shift
                ;;
            --check-update)
                MODE="check-update"
                shift
                ;;
            --update-hikam)
                MODE="update-hikam"
                shift
                ;;
            --auto-update)
                AUTO_UPDATE="$2"
                save_config
                echo "تم تعيين سياسة التحديث التلقائي إلى: $AUTO_UPDATE"
                exit 0
                ;;
            --uninstall)
                MODE="uninstall"
                shift
                ;;
            -i|--interval)
                INTERVAL="$2"
                shift 2
                ;;
            --no-update-check)
                # خيار مخفي لتخطي فحص التحديثات (يُستخدم في المثبت)
                MODE="terminal"
                NO_UPDATE_CHECK=true
                shift
                ;;
            *)
                echo -e "${RED}خيار غير معروف: $1${NC}"
                usage
                ;;
        esac
    done
fi

# التحقق من وجود ملف الحكم
if [ ! -f "$HIKAM_FILE" ] && [ "$MODE" != "uninstall" ] && [ "$MODE" != "update-hikam" ]; then
    echo -e "${RED}ملف الحكم $HIKAM_FILE غير موجود!${NC}" >&2
    echo -e "${YELLOW}يرجى تشغيل: ${NC}gt-hikam --update-hikam${NC}" >&2
    exit 1
fi

case $MODE in
    terminal)
        # إذا لم تكن قد طلبت تخطي فحص التحديثات، قم بتشغيل الفحص في الخلفية بهدوء
        if [ "$NO_UPDATE_CHECK" != "true" ]; then
            check_update_background
        fi
        show_hikma_terminal
        ;;
    notify-start)
        start_notify "$INTERVAL"
        ;;
    notify-stop)
        stop_notify
        ;;
    notify-status)
        status_notify
        ;;
    check-update)
        if check_update_hikam; then
            echo "ملف الحكم محدث."
            exit 0
        else
            if [ $? -eq 1 ]; then
                echo "يوجد تحديث جديد لملف الحكم."
                exit 1
            else
                echo "تعذر فحص التحديث."
                exit 2
            fi
        fi
        ;;
    update-hikam)
        update_hikam
        ;;
    uninstall)
        if [ -f "$INSTALL_DIR/uninstall-gt-hikam.sh" ]; then
            # التأكد من صلاحية التنفيذ
            if [ ! -x "$INSTALL_DIR/uninstall-gt-hikam.sh" ]; then
                echo -e "${YELLOW}⚠ جاري منح صلاحية التنفيذ لملف إلغاء التثبيت...${NC}"
                chmod +x "$INSTALL_DIR/uninstall-gt-hikam.sh"
            fi
            echo "جاري تشغيل برنامج إلغاء التثبيت..."
            exec "$INSTALL_DIR/uninstall-gt-hikam.sh"
        else
            echo -e "${RED}خطأ: لم يتم العثور على برنامج إلغاء التثبيت في $INSTALL_DIR${NC}"
            echo -e "${YELLOW}يمكنك إلغاء التثبيت يدوياً:${NC}"
            echo "  1. إيقاف الإشعارات: pkill -f gt-hikam"
            echo "  2. حذف المجلد: rm -rf $INSTALL_DIR"
            echo "  3. حذف الرابط: rm -f ~/.local/bin/gt-hikam"
            echo "  4. إزالة الأسطر من .bashrc و .zshrc يدوياً"
            exit 1
        fi
        ;;
    *)
        usage
        ;;
esac
