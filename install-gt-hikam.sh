#!/bin/bash

set -e

INSTALL_DIR="$HOME/GT-hikam"
SCRIPT_NAME="gt-hikam.sh"
HIKAM_FILE="hikam.txt"
REPO_RAW_URL="https://raw.githubusercontent.com/SalehGNUTUX/GT-hikam/main"

echo "تثبيت GT-hikam في $INSTALL_DIR ..."
mkdir -p "$INSTALL_DIR"

# --- الحصول على ملف الحكم من الريبو ---
if [ ! -f "$INSTALL_DIR/$HIKAM_FILE" ]; then
    curl -fsSL "$REPO_RAW_URL/$HIKAM_FILE" -o "$INSTALL_DIR/$HIKAM_FILE" || {
        echo "تعذر جلب hikam.txt من الإنترنت."; exit 2;
    }
fi

# --- الحصول على السكريبت الرئيسي من الريبو (أو انسخ نسختك هنا) ---
curl -fsSL "$REPO_RAW_URL/$SCRIPT_NAME" -o "$INSTALL_DIR/$SCRIPT_NAME" || {
    echo "تعذر جلب $SCRIPT_NAME من الإنترنت."; exit 2;
}
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# --- إعداد التحديث التلقائي (يسأل المستخدم) ---
echo ""
echo "إعداد خاصية التحديث التلقائي للحكم:"
echo "يمكنك جعل البرنامج يفحص ويحدّث الحكم تلقائيًا عند كل تشغيل (always)، أو يسأل في كل مرة (ask)، أو لا يحدّث أبدًا (never)."
read -p "اختر سياسة التحديث التلقائي [always/ask/never] (افتراضي: ask): " AUTO_UPDATE
AUTO_UPDATE=${AUTO_UPDATE:-ask}
echo "AUTO_UPDATE=\"$AUTO_UPDATE\"" > "$INSTALL_DIR/.gt-hikam.conf"

# --- إضافة إلى bashrc أو zshrc ---
added=false
add_to_shell_rc() {
    RC_FILE="$1"
    if [ -f "$RC_FILE" ]; then
        if ! grep -Fq "$INSTALL_DIR/$SCRIPT_NAME" "$RC_FILE"; then
            echo "" >> "$RC_FILE"
            echo "# GT-hikam: حكمة في كل فتح طرفية" >> "$RC_FILE"
            echo "\"$INSTALL_DIR/$SCRIPT_NAME\"" >> "$RC_FILE"
            added=true
        fi
    fi
}
add_to_shell_rc "$HOME/.bashrc"
add_to_shell_rc "$HOME/.zshrc"

# --- بدء الإشعار التلقائي (15 دقيقة) ---
"$INSTALL_DIR/$SCRIPT_NAME" --notify-start -i 900

echo ""
echo "تم تثبيت GT-hikam في $INSTALL_DIR"
if [ "$added" = true ]; then
    echo "تمت إضافة السطر للـ bashrc أو zshrc وسيظهر لك حكمة في كل مرة تفتح فيها الطرفية."
else
    echo "أضف يدويًا السطر التالي لملف إعدادات الطرفية:"
    echo "\"$INSTALL_DIR/$SCRIPT_NAME\""
fi
echo ""
echo "تم تفعيل إشعار دوري تلقائيًا كل 15 دقيقة."
echo "لإيقاف الإشعار: \"$INSTALL_DIR/$SCRIPT_NAME\" --notify-stop"
echo "لضبط الفاصل الزمني: \"$INSTALL_DIR/$SCRIPT_NAME\" --notify-start -i [ثواني]"
echo "لفحص أو تحديث الحكم يدويًا: \"$INSTALL_DIR/$SCRIPT_NAME\" --check-update   أو   --update-hikam"
echo "لتغيير سياسة التحديث: \"$INSTALL_DIR/$SCRIPT_NAME\" --auto-update [always|never|ask]"
