#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HIKAM_FILE="$SCRIPT_DIR/hikam.txt"
PID_FILE="$SCRIPT_DIR/.gt-hikam-notify.pid"
CONFIG_FILE="$SCRIPT_DIR/.gt-hikam.conf"

GITHUB_HIKAM_RAW_URL="https://raw.githubusercontent.com/SalehGNUTUX/GT-hikam/main/hikam.txt"
DEFAULT_INTERVAL=$((15*60)) # 15 دقيقة
AUTO_UPDATE="ask"  # ask | always | never

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

    if ! curl -fsSL "$remote_url" -o "$tmp_file"; then
        echo "تعذر جلب hikam.txt من الإنترنت."
        rm -f "$tmp_file"
        return 2
    fi

    if ! cmp -s "$local_file" "$tmp_file"; then
        echo "يوجد إصدار أحدث من ملف الحكم."
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
                update_hikam
                ;;
            never)
                echo "تم تجاهل التحديث (الإعداد: عدم التحديث التلقائي)."
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

# --- عرض حكمة طرفية ---
get_random_hikma() {
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
        echo "لم يتم العثور على حكمة صالحة!"
        return 1
    fi
    echo "$hikma"
}

show_hikma_notify() {
    local hikma
    hikma=$(get_random_hikma)
    if [ -z "$hikma" ]; then
        notify-send "GT-hikam" "لم يتم العثور على حكمة صالحة!"
    else
        notify-send "GT-hikam" "$hikma"
    fi
}

notify_loop() {
    local interval=$1
    while true; do
        show_hikma_notify
        sleep "$interval"
    done
}

start_notify() {
    local interval=$1
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        echo "الإشعارات تعمل بالفعل (PID: $(cat "$PID_FILE"))"
        exit 0
    fi
    (notify_loop "$interval" &) 
    echo $! > "$PID_FILE"
    disown
    echo "تم بدء إشعارات GT-hikam (كل $((interval/60)) دقيقة)"
}

stop_notify() {
    if [ -f "$PID_FILE" ]; then
        local pid
        pid=$(cat "$PID_FILE")
        if kill -0 $pid 2>/dev/null; then
            kill $pid
            echo "تم إيقاف إشعارات GT-hikam (PID: $pid)"
        else
            echo "لم يكن هناك إشعارات قيد التشغيل."
        fi
        rm -f "$PID_FILE"
    else
        echo "لا يوجد إشعارات قيد التشغيل."
    fi
}

status_notify() {
    if [ -f "$PID_FILE" ]; then
        local pid
        pid=$(cat "$PID_FILE")
        if kill -0 $pid 2>/dev/null; then
            echo "الإشعارات قيد التشغيل (PID: $pid)"
            exit 0
        else
            echo "الإشعارات غير فعالة ولكن ملف PID موجود، سيتم حذفه."
            rm -f "$PID_FILE"
            exit 1
        fi
    else
        echo "لا يوجد إشعارات قيد التشغيل."
        exit 1
    fi
}

usage() {
    echo "الاستخدام: $0"
    echo "  عرض حكمة في الطرفية مع فحص التحديثات."
    echo ""
    echo "خيارات متقدمة:"
    echo "  --notify-start      يبدأ إشعارات الحكم كل 15 دقيقة افتراضيًا."
    echo "  --notify-start -i 600   يبدأ إشعارات كل 10 دقائق (بالثواني)."
    echo "  --notify-stop      يوقف الإشعارات الدورية."
    echo "  --notify-status    يعرض حالة الإشعار."
    echo "  --check-update     فحص وجود تحديث فقط."
    echo "  --update-hikam     جلب آخر تحديث لملف الحكم مباشرة."
    echo "  --auto-update [always|never|ask]  تغيير سياسة التحديث التلقائي."
    exit 1
}

# --- بدء التنفيذ ---
load_config

MODE="terminal"
INTERVAL=$DEFAULT_INTERVAL

while [[ $# -gt 0 ]]; do
    case "$1" in
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
        -i|--interval)
            INTERVAL="$2"
            shift 2
            ;;
        *)
            usage
            ;;
    esac
done

if [ ! -f "$HIKAM_FILE" ]; then
    echo "ملف الحكم $HIKAM_FILE غير موجود!"
    exit 1
fi

case $MODE in
    terminal)
        maybe_update_hikam
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
    *)
        usage
        ;;
esac
