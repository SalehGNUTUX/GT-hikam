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

# إزالة من ملفات الإعداد
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
