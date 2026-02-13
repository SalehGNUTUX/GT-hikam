// ===== مصفوفة الحكم من ملف hikam.txt =====
const wisdomLibrary = [
    { text: "العِلْمُ نُورٌ، وَالجَهْلُ ظَلَامٌ، وَمَنْ نَوَّرَ اللَّهُ قَلْبَهُ هُدِيَ إِلَى الصَّوَابِ.", source: "الإمام مالك", region: "المشرق العربي", sourceType: "malik" },
    { text: "مَا تَرَكَ أَحَدٌ شَيْئًا لِلَّهِ إِلَّا عَوَّضَهُ اللَّهُ خَيْرًا مِنْهُ.", source: "الإمام مالك", region: "المشرق العربي", sourceType: "malik" },
    { text: "السُّنَّةُ سَفِينَةُ نُوحٍ، مَنْ رَكِبَهَا نَجَا، وَمَنْ تَخَلَّفَ عَنْهَا غَرِقَ.", source: "الإمام مالك", region: "المدينة المنورة", sourceType: "malik" },
    { text: "العِلْمُ مَا نَفَعَ، لَيْسَ العِلْمُ مَا حُفِظَ.", source: "الإمام الشافعي", region: "مصر", sourceType: "shafii" },
    { text: "مَنْ وَعَظَ أَخَاهُ سِرًّا فَقَدْ نَصَحَهُ، وَمَنْ وَعَظَهُ عَلَانِيَةً فَقَدْ فَضَحَهُ.", source: "الإمام الشافعي", region: "مصر", sourceType: "shafii" },
    { text: "النَّفْسُ إِنْ لَمْ تُشْغِلْهَا بِالحَقِّ شَغَلَتْكَ بِالبَاطِلِ.", source: "الإمام الشافعي", region: "الحجاز", sourceType: "shafii" },
    { text: "مَعَ القُرْآنِ لَا تَضِلُّ، وَمَعَ السُّنَّةِ لَا تَجْهَلُ.", source: "الإمام أحمد بن حنبل", region: "بغداد", sourceType: "hanbal" },
    { text: "أُصُولُ السُّنَّةِ عِنْدَنَا: التَّمَسُّكُ بِمَا كَانَ عَلَيْهِ أَصْحَابُ رَسُولِ اللَّهِ.", source: "الإمام أحمد بن حنبل", region: "بغداد", sourceType: "hanbal" },
    { text: "إذَا صَحَّ الحَدِيثُ فَهُوَ مَذْهَبِي.", source: "الإمام أبو حنيفة", region: "الكوفة", sourceType: "hanifa" },
    { text: "لَا يَحِلُّ لِأَحَدٍ أَنْ يَأْخُذَ بِقَوْلِنَا مَا لَمْ يَعْلَمْ مِنْ أَيْنَ أَخَذْنَاهُ.", source: "الإمام أبو حنيفة", region: "العراق", sourceType: "hanifa" },
    { text: "العِلْمُ أَفْضَلُ مِنَ المَالِ، لِأَنَّ العِلْمَ يَحْرُسُكَ، وَأَنْتَ تَحْرُسُ المَالَ.", source: "الإمام أبو حنيفة", region: "الكوفة", sourceType: "hanifa" },
    { text: "لا تؤجل عمل اليوم إلى الغد.", source: "حكمة عربية", region: "الجزيرة العربية", sourceType: "arab" },
    { text: "من جد وجد ومن زرع حصد.", source: "حكمة عربية", region: "بلاد الشام", sourceType: "arab" },
    { text: "العقل زينة.", source: "حكمة عربية", region: "مصر", sourceType: "arab" },
    { text: "العلم نور والجهل ظلام.", source: "حكمة إسلامية", region: "العالم الإسلامي", sourceType: "arab" },
    { text: "من تواضع لله رفعه.", source: "حكمة إسلامية", region: "المشرق العربي", sourceType: "arab" },
    { text: "الصبر مفتاح الفرج.", source: "حكمة إسلامية", region: "مصر", sourceType: "arab" },
    { text: "خير الناس أنفعهم للناس.", source: "حديث نبوي", region: "الحجاز", sourceType: "arab" },
    { text: "الوقت كالسيف إن لم تقطعه قطعك.", source: "حكمة عربية", region: "بلاد الشام", sourceType: "arab" },
    { text: "القناعة كنز لا يفنى.", source: "حكمة إسلامية", region: "العراق", sourceType: "arab" },
    { text: "ليس الشديد بالصرعة، إنما الشديد الذي يملك نفسه عند الغضب.", source: "الحديث الشريف", region: "الحجاز", sourceType: "arab" },
    { text: "من حسن إسلام المرء تركه ما لا يعنيه.", source: "الحديث الشريف", region: "الحجاز", sourceType: "arab" },
    { text: "الْعُلَمَاءُ أَرْبَعَةٌ: عَالِمٌ يَعْلَمُ أَنَّهُ يَعْلَمُ فَذَاكَ عَالِمٌ فَاسْأَلُوهُ، وَعَالِمٌ يَعْلَمُ أَنَّهُ لَا يَعْلَمُ فَذَاكَ مُتَعَلِّمٌ فَعَلِّمُوهُ، وَعَالِمٌ لَا يَعْلَمُ أَنَّهُ يَعْلَمُ فَذَاكَ نَائِمٌ فَأَيْقِظُوهُ، وَعَالِمٌ لَا يَعْلَمُ أَنَّهُ لَا يَعْلَمُ فَذَاكَ جَاهِلٌ فَاحْذَرُوهُ.", source: "الإمام الشافعي", region: "مصر", sourceType: "shafii" }
];

// ===== دوال التهيئة =====
document.addEventListener('DOMContentLoaded', function() {
    initializeScrollTopButton();
    initializeNavigation();
    initializeAnimation();
    initializeScrollEffects();
    initThemeToggle();
    initFontSelector();
    loadWisdomGrid();          // تحميل الحكم في الشبكة
    updateDailyWisdom();       // عرض حكمة اليوم
    
    // أحداث إضافية
    document.getElementById('newWisdomBtn').addEventListener('click', updateDailyWisdom);
});

// ===== حكمة اليوم =====
function updateDailyWisdom() {
    const randomIndex = Math.floor(Math.random() * wisdomLibrary.length);
    const wisdom = wisdomLibrary[randomIndex];
    
    document.getElementById('dailyWisdomText').textContent = wisdom.text;
    document.getElementById('dailyWisdomSource').textContent = `— ${wisdom.source}`;
    document.getElementById('dailyWisdomRegion').textContent = wisdom.region;
    
    // تحديث لون البطاقة حسب المصدر
    const dailyCard = document.getElementById('dailyWisdomCard');
    dailyCard.setAttribute('data-source', wisdom.sourceType);
}

// ===== تحميل شبكة الحكم =====
function loadWisdomGrid() {
    const grid = document.getElementById('wisdomGrid');
    if (!grid) return;
    
    // عرض 12 حكمة عشوائية (أو كلها إذا كانت أقل)
    const shuffled = [...wisdomLibrary].sort(() => 0.5 - Math.random());
    const selected = shuffled.slice(0, 12);
    
    grid.innerHTML = selected.map(wisdom => `
        <div class="wisdom-card" data-source="${wisdom.sourceType}">
            <div class="card-content">
                <div class="quote-icon">"</div>
                <p class="wisdom-text">${wisdom.text}</p>
                <p class="wisdom-source">— ${wisdom.source}</p>
            </div>
            <div class="wisdom-region">${wisdom.region}</div>
        </div>
    `).join('');
}

// ===== دوال أخرى (بدون تغيير) =====
function initializeScrollTopButton() { /* ... */ }
function initializeNavigation() { /* ... */ }
function initializeAnimation() { /* ... */ }
function initializeScrollEffects() { /* ... */ }

// ===== Dark/Light Mode Toggle =====
function initThemeToggle() {
    const themeToggle = document.getElementById('themeToggle');
    const body = document.body;
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'dark') {
        body.classList.add('dark-mode');
        themeToggle.textContent = '☀️';
    } else {
        themeToggle.textContent = '🌙';
    }
    themeToggle.addEventListener('click', () => {
        body.classList.toggle('dark-mode');
        const isDark = body.classList.contains('dark-mode');
        themeToggle.textContent = isDark ? '☀️' : '🌙';
        localStorage.setItem('theme', isDark ? 'dark' : 'light');
    });
}

// ===== Font Selector =====
function initFontSelector() {
    const fontSelector = document.getElementById('fontSelector');
    const body = document.body;
    const savedFont = localStorage.getItem('selectedFont') || 'Amiri';
    body.style.fontFamily = savedFont + ', var(--font-secondary)';
    fontSelector.value = savedFont;
    fontSelector.addEventListener('change', (e) => {
        const selectedFont = e.target.value;
        body.style.fontFamily = selectedFont + ', var(--font-secondary)';
        localStorage.setItem('selectedFont', selectedFont);
    });
}

// ===== Copy to Clipboard =====
function copyToClipboard() {
    const code = document.querySelector('.install-code code').textContent;
    navigator.clipboard.writeText(code).then(() => {
        const btn = event.target;
        const originalText = btn.textContent;
        btn.textContent = '✓ تم النسخ!';
        btn.style.background = '#27ae60';
        setTimeout(() => {
            btn.textContent = originalText;
            btn.style.background = '';
        }, 2000);
    });
}

// ===== Smooth Scroll =====
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) target.scrollIntoView({ behavior: 'smooth', block: 'start' });
    });
});

// ===== رسالة ترحيب =====
console.log('%c🌟 HIKAM - حكم 🌟', 'color: #d4af37; font-size: 20px; font-weight: bold;');
console.log('%c أكثر من 100 حكمة من الأئمة الأربعة والحكم العربية', 'color: #1a472a; font-size: 14px;');
