#!/bin/bash

set -e

# ألوان للعرض الجمالي
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# مسارات الملفات
INSTALL_DIR="$HOME/.GT-hikam"
SCRIPT_NAME="gt-hikam.sh"
HIKAM_FILE="hikam.txt"
UNINSTALL_SCRIPT="uninstall-gt-hikam.sh"
REPO_RAW_URL="https://raw.githubusercontent.com/SalehGNUTUX/GT-hikam/main"

# دالة لعرض العنوان
show_header() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                 ${WHITE}مثبت GT-hikam${CYAN}                         ║"
    echo "║       ${WHITE}حكم عشوائية في الطرفية والإشعارات${CYAN}              ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# دالة للتحقق من وجود الأدوات
check_dependencies() {
    local missing_deps=()
    
    for cmd in curl notify-send awk shuf; do
        if ! command -v $cmd &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${YELLOW}تحذير: الأدوات التالية غير مثبتة:${NC}"
        for dep in "${missing_deps[@]}"; do
            echo "  - $dep"
        done
        
        read -p "هل تريد تثبيت هذه الأدوات؟ (y/n): " install_choice
        if [[ "$install_choice" == "y" || "$install_choice" == "Y" ]]; then
            if command -v apt &> /dev/null; then
                sudo apt update && sudo apt install -y "${missing_deps[@]}"
            elif command -v yum &> /dev/null; then
                sudo yum install -y "${missing_deps[@]}"
            elif command -v pacman &> /dev/null; then
                sudo pacman -S --noconfirm "${missing_deps[@]}"
            else
                echo -e "${RED}لا يمكن تثبيت التبعيات تلقائيًا. يرجى تثبيتها يدويًا.${NC}"
                exit 1
            fi
        fi
    fi
}

# دالة إنشاء الرابط الرمزي
create_symlink() {
    echo -e "\n${BLUE}[إضافي]${NC} إنشاء رابط تنفيذي في ~/.local/bin/..."
    
    # التأكد من وجود مجلد .local/bin
    LOCAL_BIN="$HOME/.local/bin"
    if [ ! -d "$LOCAL_BIN" ]; then
        mkdir -p "$LOCAL_BIN"
        echo -e "${GREEN}✓${NC} تم إنشاء المجلد $LOCAL_BIN"
    fi
    
    # التحقق من وجود المجلد في PATH
    if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
        echo -e "${YELLOW}⚠${NC} المجلد $LOCAL_BIN ليس في مسار PATH"
        echo -e "${WHITE}سيتم إضافته إلى .bashrc و .zshrc تلقائياً${NC}"
        
        # إضافة المجلد إلى PATH في ملفات الإعداد
        for rc_file in "$HOME/.bashrc" "$HOME/.zshrc"; do
            if [ -f "$rc_file" ]; then
                if ! grep -q "export PATH=\"\$HOME/.local/bin:\$PATH\"" "$rc_file"; then
                    echo "" >> "$rc_file"
                    echo "# إضافة ~/.local/bin إلى PATH" >> "$rc_file"
                    echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$rc_file"
                    echo -e "${GREEN}✓${NC} تم إضافة $LOCAL_BIN إلى PATH في $(basename $rc_file)"
                fi
            fi
        done
    fi
    
    # إنشاء الرابط الرمزي
    SYMLINK_PATH="$LOCAL_BIN/gt-hikam"
    if [ -L "$SYMLINK_PATH" ] || [ -f "$SYMLINK_PATH" ]; then
        rm -f "$SYMLINK_PATH"
    fi
    
    ln -s "$INSTALL_DIR/$SCRIPT_NAME" "$SYMLINK_PATH"
    chmod +x "$SYMLINK_PATH"
    
    echo -e "${GREEN}✓${NC} تم إنشاء الرابط التنفيذي: ${WHITE}gt-hikam${NC}"
    echo -e "${GREEN}✓${NC} يمكنك الآن تشغيل البرنامج بكتابة: ${WHITE}gt-hikam${NC}"
}

# عرض الترخيص
show_license() {
    echo -e "${YELLOW}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║                     ترخيص البرنامج                       ║${NC}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════════════════╝${NC}"
    echo -e "${WHITE}هذا البرنامج مرخص تحت رخصة GPL V2.0${NC}"
    echo -e "${WHITE}يتم توزيعه بحرية مع الحق في التعديل والنشر مع الحفاظ على الرخصة.${NC}"
    echo ""
    read -p "اضغط Enter للمتابعة أو Ctrl+C للإلغاء..."
    clear
}

# دالة التثبيت الرئيسية
install_gt_hikam() {
    clear
    show_header
    
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              بدء تثبيت GT-hikam                         ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    
    # التحقق من التبعيات
    check_dependencies
    
    # إنشاء مجلد التثبيت
    echo -e "\n${BLUE}[1/5]${NC} إنشاء مجلد التثبيت في ${INSTALL_DIR}..."
    mkdir -p "$INSTALL_DIR"
    
    # جلب ملف الحكم
    echo -e "${BLUE}[2/5]${NC} جلب ملف الحكم..."
    if [ ! -f "$INSTALL_DIR/$HIKAM_FILE" ]; then
        curl -fsSL "$REPO_RAW_URL/$HIKAM_FILE" -o "$INSTALL_DIR/$HIKAM_FILE" || {
            echo -e "${RED}تعذر جلب ملف الحكم من الإنترنت.${NC}"
            exit 2
        }
        echo -e "${GREEN}✓${NC} تم جلب ملف الحكم بنجاح"
    else
        echo -e "${YELLOW}⚠${NC} ملف الحكم موجود بالفعل، جاري تحديثه..."
        curl -fsSL "$REPO_RAW_URL/$HIKAM_FILE" -o "$INSTALL_DIR/$HIKAM_FILE.new"
        if cmp -s "$INSTALL_DIR/$HIKAM_FILE" "$INSTALL_DIR/$HIKAM_FILE.new"; then
            rm "$INSTALL_DIR/$HIKAM_FILE.new"
            echo -e "${GREEN}✓${NC} ملف الحكم محدث بالفعل"
        else
            mv "$INSTALL_DIR/$HIKAM_FILE.new" "$INSTALL_DIR/$HIKAM_FILE"
            echo -e "${GREEN}✓${NC} تم تحديث ملف الحكم"
        fi
    fi
    
    # جلب السكريبت الرئيسي
    echo -e "${BLUE}[3/5]${NC} جلب السكريبت الرئيسي..."
    curl -fsSL "$REPO_RAW_URL/$SCRIPT_NAME" -o "$INSTALL_DIR/$SCRIPT_NAME" || {
        echo -e "${RED}تعذر جلب السكريبت الرئيسي.${NC}"
        exit 2
    }
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    echo -e "${GREEN}✓${NC} تم تنزيل السكريبت الرئيسي"
    
    # جلب سكريبت إلغاء التثبيت
    echo -e "${BLUE}[4/5]${NC} جلب سكريبت إلغاء التثبيت..."
    curl -fsSL "$REPO_RAW_URL/$UNINSTALL_SCRIPT" -o "$INSTALL_DIR/$UNINSTALL_SCRIPT" 2>/dev/null || {
        # إنشاء سكريبت إلغاء التثبيت افتراضي إذا لم يوجد
        cat > "$INSTALL_DIR/$UNINSTALL_SCRIPT" << 'EOF'
#!/bin/bash

set -e

# ألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

INSTALL_DIR="$HOME/.GT-hikam"

show_header() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║              إلغاء تثبيت GT-hikam                        ║"
    echo "║       حكم عشوائية في الطرفية والإشعارات                 ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# التحقق مما إذا المستخدم يريد حقًا الإزالة
confirm_uninstall() {
    echo -e "\n${YELLOW}⚠  تحذير:${NC}"
    echo "هذا الإجراء سيقوم بـ:"
    echo "  1. إيقاف جميع الإشعارات الدورية"
    echo "  2. إزالة أسطر GT-hikam من ملفات الإعداد (.bashrc, .zshrc)"
    echo "  3. حذف جميع ملفات البرنامج من ${INSTALL_DIR}"
    echo "  4. إزالة الرابط التنفيذي من ~/.local/bin/"
    echo "  5. تنظيف الملفات المؤقتة"
    echo ""
    
    read -p "هل أنت متأكد من إلغاء تثبيت GT-hikam؟ (y/N): " confirm
    
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo -e "${GREEN}تم إلغاء عملية الإزالة.${NC}"
        exit 0
    fi
}

# إيقاف الإشعارات
stop_notifications() {
    echo -e "\n${BLUE}[1/5]${NC} إيقاف الإشعارات الدورية..."
    
    if [ -f "$INSTALL_DIR/.gt-hikam-notify.pid" ]; then
        pid=$(cat "$INSTALL_DIR/.gt-hikam-notify.pid")
        if kill -0 $pid 2>/dev/null; then
            kill $pid
            echo -e "${GREEN}✓${NC} تم إيقاف الإشعارات الدورية (PID: $pid)"
        else
            echo -e "${YELLOW}⚠${NC} عملية الإشعارات غير نشطة"
        fi
        rm -f "$INSTALL_DIR/.gt-hikam-notify.pid"
    else
        echo -e "${YELLOW}⚠${NC} لا توجد إشعارات قيد التشغيل"
    fi
}

# إزالة من ملفات الإعداد بطريقة آمنة
remove_from_shell_rc() {
    echo -e "\n${BLUE}[2/5]${NC} إزالة أسطر GT-hikam من ملفات الإعداد..."
    
    for rc_file in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.bash_profile" "$HOME/.profile"; do
        if [ -f "$rc_file" ]; then
            # عمل نسخة احتياطية
            cp "$rc_file" "${rc_file}.backup-$(date +%Y%m%d-%H%M%S)" 2>/dev/null
            
            # إزالة الأسطر المتعلقة بـ GT-hikam
            sed -i '/# GT-hikam:/d' "$rc_file"
            sed -i '/\.GT-hikam\/gt-hikam\.sh/d' "$rc_file"
            sed -i '/GT-hikam/d' "$rc_file"
            sed -i '/# إضافة ~\/.local\/bin إلى PATH/d' "$rc_file"
            sed -i '/export PATH="\$HOME\/.local\/bin:\$PATH"/d' "$rc_file"
            
            echo -e "${GREEN}✓${NC} تمت إزالة الأسطر من $(basename $rc_file)"
            
            # التحقق من صحة الملف بعد التعديل
            if [[ "$rc_file" == *".bashrc" ]]; then
                if bash -n "$rc_file" 2>/dev/null; then
                    echo -e "${GREEN}✓${NC} ملف $(basename $rc_file) سليم بعد التعديل"
                else
                    echo -e "${RED}✗${NC} يوجد خطأ في ملف $(basename $rc_file) بعد التعديل!"
                    echo -e "${YELLOW}⚠${NC} يرجى مراجعة الملف يدوياً"
                fi
            fi
        fi
    done
}

# حذف ملفات البرنامج
delete_install_files() {
    echo -e "\n${BLUE}[3/5]${NC} حذف ملفات البرنامج..."
    
    if [ -d "$INSTALL_DIR" ]; then
        # عرض محتويات المجلد قبل الحذف
        echo -e "${WHITE}المحتوى الذي سيتم حذفه:${NC}"
        ls -la "$INSTALL_DIR/" | head -10
        
        rm -rf "$INSTALL_DIR"
        echo -e "${GREEN}✓${NC} تم حذف مجلد التثبيت: $INSTALL_DIR"
    else
        echo -e "${YELLOW}⚠${NC} مجلد التثبيت غير موجود"
    fi
}

# إزالة الرابط الرمزي
remove_symlink() {
    echo -e "\n${BLUE}[4/5]${NC} إزالة الرابط التنفيذي..."
    
    if [ -L "$HOME/.local/bin/gt-hikam" ]; then
        rm -f "$HOME/.local/bin/gt-hikam"
        echo -e "${GREEN}✓${NC} تم إزالة الرابط التنفيذي من ~/.local/bin/"
        
        # إزالة المجلد إذا كان فارغاً
        if [ -d "$HOME/.local/bin" ] && [ -z "$(ls -A "$HOME/.local/bin")" ]; then
            rmdir "$HOME/.local/bin" 2>/dev/null && echo -e "${GREEN}✓${NC} تم إزالة المجلد الفارغ ~/.local/bin/"
        fi
    else
        echo -e "${YELLOW}⚠${NC} الرابط التنفيذي غير موجود"
    fi
}

# تنظيف الملفات المؤقتة
clean_temp_files() {
    echo -e "\n${BLUE}[5/5]${NC} تنظيف الملفات المؤقتة..."
    
    # حذف ملفات التكوين
    rm -f "$HOME/.gt-hikam.conf" 2>/dev/null
    rm -f "$HOME/.config/gt-hikam" 2>/dev/null
    
    echo -e "${GREEN}✓${NC} تم تنظيف الملفات المؤقتة"
}

# دالة رئيسية
main() {
    clear
    show_header
    
    # التحقق من جذر التثبيت
    if [ ! -d "$INSTALL_DIR" ] && [ ! -f "$HOME/.gt-hikam.conf" ]; then
        echo -e "${YELLOW}⚠${NC} يبدو أن GT-hikam غير مثبت على هذا النظام."
        echo -e "${WHITE}موقع التثبيت المتوقع:${NC} $INSTALL_DIR"
        read -p "هل تريد المتابعة مع الإزالة القسرية؟ (y/N): " force_remove
        
        if [[ "$force_remove" != "y" && "$force_remove" != "Y" ]]; then
            echo -e "${GREEN}تم إلغاء عملية الإزالة.${NC}"
            exit 0
        fi
    fi
    
    confirm_uninstall
    
    stop_notifications
    remove_from_shell_rc
    delete_install_files
    remove_symlink
    clean_temp_files
    
    # عرض رسالة النجاح
    echo -e "\n${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║      تم إلغاء تثبيت GT-hikam بنجاح!                      ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    
    echo -e "\n${WHITE}ملاحظات:${NC}"
    echo -e "  • ${GREEN}✓${NC} تم إيقاف جميع الإشعارات الدورية"
    echo -e "  • ${GREEN}✓${NC} تمت إزالة أسطر GT-hikam من ملفات الإعداد"
    echo -e "  • ${GREEN}✓${NC} تم حذف جميع ملفات البرنامج"
    echo -e "  • ${GREEN}✓${NC} تم إزالة الرابط التنفيذي"
    echo -e "  • ${GREEN}✓${NC} تم تنظيف الملفات المؤقتة"
    
    echo -e "\n${YELLOW}⚠  مهم:${NC}"
    echo -e "  • يرجى إعادة تشغيل الطرفية أو تنفيذ الأمر التالي:"
    echo -e "    ${BLUE}source ~/.bashrc${NC} (أو source ~/.zshrc للزش)"
    
    echo -e "\n${CYAN}══════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}لإعادة التثبيت لاحقًا:${NC}"
    echo -e "${BLUE}bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/SalehGNUTUX/GT-hikam/main/install-gt-hikam.sh)\"${NC}"
    
    echo -e "\n${WHITE}شكرًا لك على استخدام GT-hikam!${NC}"
}

# التحقق من الخيارات
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo -e "${WHITE}استخدام:${NC}"
    echo "  ./uninstall-gt-hikam.sh"
    echo "  ~/.GT-hikam/uninstall-gt-hikam.sh"
    echo ""
    echo -e "${WHITE}خيارات:${NC}"
    echo "  --help     عرض هذه الرسالة"
    echo "  --force    الإزالة القسرية بدون تأكيد"
    exit 0
fi

if [[ "$1" == "--force" || "$1" == "-f" ]]; then
    # الإزالة القسرية
    stop_notifications
    remove_from_shell_rc
    delete_install_files
    remove_symlink
    clean_temp_files
    echo -e "${GREEN}تم إزالة GT-hikam قسريًا.${NC}"
    exit 0
fi

# تشغيل الدالة الرئيسية
main
EOF
        chmod +x "$INSTALL_DIR/$UNINSTALL_SCRIPT"
        echo -e "${GREEN}✓${NC} تم إنشاء سكريبت إلغاء التثبيت ومنحه صلاحية التنفيذ"
    }
    
    # إعداد سياسة التحديث التلقائي
    echo -e "\n${BLUE}[5/5]${NC} إعداد سياسة التحديث التلقائي..."
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         سياسة التحديث التلقائي للحكم                    ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo -e "${WHITE}يمكنك اختيار إحدى السياسات التالية:${NC}"
    echo -e "  ${GREEN}always${NC}  - تحديث تلقائي دائمًا"
    echo -e "  ${YELLOW}ask${NC}     - السؤال في كل مرة (افتراضي)"
    echo -e "  ${RED}never${NC}   - لا تحديث تلقائي أبدًا"
    echo ""
    
    read -p "اختر سياسة التحديث التلقائي [always/ask/never] (افتراضي: ask): " AUTO_UPDATE
    AUTO_UPDATE=${AUTO_UPDATE:-ask}
    
    case $AUTO_UPDATE in
        always|ask|never)
            echo "AUTO_UPDATE=\"$AUTO_UPDATE\"" > "$INSTALL_DIR/.gt-hikam.conf"
            echo -e "${GREEN}✓${NC} تم تعيين السياسة إلى: $AUTO_UPDATE"
            ;;
        *)
            echo -e "${YELLOW}⚠${NC} اختيار غير صالح، تم تعيين القيمة الافتراضية: ask"
            echo "AUTO_UPDATE=\"ask\"" > "$INSTALL_DIR/.gt-hikam.conf"
            ;;
    esac
    
    # إنشاء الرابط الرمزي
    create_symlink
    
    # إضافة إلى bashrc/zshrc
    echo -e "\n${MAGENTA}إضافة السكريبت إلى ملفات الإعداد...${NC}"
    added=false
    
    add_to_shell_rc() {
        local RC_FILE="$1"
        local SHELL_NAME="$2"
        
        if [ -f "$RC_FILE" ]; then
            if ! grep -Fq ".GT-hikam/gt-hikam.sh" "$RC_FILE"; then
                echo "" >> "$RC_FILE"
                echo "# GT-hikam: حكمة عشوائية في كل فتح طرفية" >> "$RC_FILE"
                echo "if [ -f \"\$HOME/.GT-hikam/gt-hikam.sh\" ]; then" >> "$RC_FILE"
                echo "    \$HOME/.GT-hikam/gt-hikam.sh" >> "$RC_FILE"
                echo "fi" >> "$RC_FILE"
                added=true
                echo -e "${GREEN}✓${NC} تمت الإضافة إلى $SHELL_NAME"
            else
                echo -e "${YELLOW}⚠${NC} السكريبت مضاف مسبقًا إلى $SHELL_NAME"
            fi
        fi
    }
    
    add_to_shell_rc "$HOME/.bashrc" "bash"
    add_to_shell_rc "$HOME/.zshrc" "zsh"
    
    # بدء الإشعارات
    echo -e "\n${MAGENTA}بدء الإشعارات الدورية...${NC}"
    "$INSTALL_DIR/$SCRIPT_NAME" --notify-start -i 900 > /dev/null 2>&1
    
    # عرض ملخص التثبيت
    clear
    show_header
    
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║      تم تثبيت GT-hikam بنجاح!                          ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    
    echo -e "\n${WHITE}📁 موقع التثبيت:${NC} ${INSTALL_DIR}/"
    echo -e "${WHITE}⚙️  ملف الإعدادات:${NC} ${INSTALL_DIR}/.gt-hikam.conf"
    echo -e "${WHITE}📝 ملف الحكم:${NC} ${INSTALL_DIR}/hikam.txt"
    echo -e "${WHITE}🔗 الرابط التنفيذي:${NC} ~/.local/bin/gt-hikam"
    echo -e "${WHITE}🗑️  إلغاء التثبيت:${NC} ${INSTALL_DIR}/uninstall-gt-hikam.sh"
    
    if [ "$added" = true ]; then
        echo -e "\n${GREEN}✓${NC} سيظهر لك حكمة في كل مرة تفتح فيها الطرفية."
    else
        echo -e "\n${YELLOW}⚠${NC} يمكنك إضافة السكريبت يدويًا لملف إعدادات الطرفية:"
        echo -e "${WHITE}if [ -f \"\$HOME/.GT-hikam/gt-hikam.sh\" ]; then"
        echo "    \$HOME/.GT-hikam/gt-hikam.sh"
        echo "fi"
    fi
    
    echo -e "\n${CYAN}══════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}الأوامر المتاحة:${NC}"
    echo -e "  ${BLUE}gt-hikam${NC}                        - عرض حكمة في الطرفية"
    echo -e "  ${BLUE}gt-hikam --help${NC}                 - عرض المساعدة"
    echo -e "  ${BLUE}gt-hikam --notify-stop${NC}          - إيقاف الإشعارات"
    echo -e "  ${BLUE}gt-hikam --update-hikam${NC}         - تحديث الحكم"
    echo -e "  ${BLUE}gt-hikam --uninstall${NC}            - إلغاء التثبيت"
    
    echo -e "\n${GREEN}تم تفعيل الإشعارات الدورية كل 15 دقيقة تلقائيًا.${NC}"
    echo -e "${YELLOW}لإيقاف الإشعارات:${NC} gt-hikam --notify-stop"
    
    # عرض حكمة تجريبية
    echo -e "\n${CYAN}══════════════════════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}حكمة تجريبية من التثبيت:${NC}"
    "$INSTALL_DIR/$SCRIPT_NAME" --no-update-check
}

# دالة لعرض المساعدة
show_help() {
    show_header
    echo -e "${WHITE}الاستخدام:${NC}"
    echo "  ./install-gt-hikam.sh [خيارات]"
    echo ""
    echo -e "${WHITE}الخيارات:${NC}"
    echo "  --help     عرض هذه الرسالة"
    echo "  --license  عرض ترخيص البرنامج"
    echo "  --install  تثبيت البرنامج (افتراضي)"
    echo "  --remote   جلب وتشغيل المثبت عن بعد"
    echo ""
}

# التحقق من الخيارات
case "$1" in
    --help)
        show_help
        exit 0
        ;;
    --license)
        show_license
        exit 0
        ;;
    --remote)
        echo "جاري تحميل المثبت عن بعد..."
        curl -fsSL "$REPO_RAW_URL/install-gt-hikam.sh" | bash -s -- --install
        exit 0
        ;;
    --install|"")
        install_gt_hikam
        ;;
    *)
        echo -e "${RED}خيار غير معروف: $1${NC}"
        show_help
        exit 1
        ;;
esac
