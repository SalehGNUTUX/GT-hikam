// ===== مصفوفة الحكم من ملف hikam.txt (مقتطفات) =====
const wisdomLibrary = [
    { text: "العِلْمُ نُورٌ، وَالجَهْلُ ظَلَامٌ، وَمَنْ نَوَّرَ اللَّهُ قَلْبَهُ هُدِيَ إِلَى الصَّوَابِ.", source: "الإمام مالك", region: "المشرق العربي", sourceType: "malik" },
    { text: "مَا تَرَكَ أَحَدٌ شَيْئًا لِلَّهِ إِلَّا عَوَّضَهُ اللَّهُ خَيْرًا مِنْهُ.", source: "الإمام مالك", region: "المشرق العربي", sourceType: "malik" },
    { text: "السُّنَّةُ سَفِينَةُ نُوحٍ، مَنْ رَكِبَهَا نَجَا، وَمَنْ تَخَلَّفَ عَنْهَا غَرِقَ.", source: "الإمام مالك", region: "المدينة المنورة", sourceType: "malik" },
    { text: "مَنْ تَصَدَّرَ قَبْلَ أَوَانِهِ فَقَدْ تَصَدَّرَ لِنَفْسِهِ.", source: "الإمام مالك", region: "المدينة", sourceType: "malik" },
    { text: "العِلْمُ لَا يُعْطَى بَعْضُهُ إِلَّا بِبَعْضٍ.", source: "الإمام مالك", region: "الحجاز", sourceType: "malik" },
    { text: "العِلْمُ مَا نَفَعَ، لَيْسَ العِلْمُ مَا حُفِظَ.", source: "الإمام الشافعي", region: "مصر", sourceType: "shafii" },
    { text: "مَنْ وَعَظَ أَخَاهُ سِرًّا فَقَدْ نَصَحَهُ، وَمَنْ وَعَظَهُ عَلَانِيَةً فَقَدْ فَضَحَهُ.", source: "الإمام الشافعي", region: "مصر", sourceType: "shafii" },
    { text: "النَّفْسُ إِنْ لَمْ تُشْغِلْهَا بِالحَقِّ شَغَلَتْكَ بِالبَاطِلِ.", source: "الإمام الشافعي", region: "الحجاز", sourceType: "shafii" },
    { text: "لَا يَبْلُغُ الأَعْدَاءُ مِنْ جَاهِلٍ مَا يَبْلُغُ الجَاهِلُ مِنْ نَفْسِهِ.", source: "الإمام الشافعي", region: "العراق", sourceType: "shafii" },
    { text: "رِضَا النَّاسِ غَايَةٌ لَا تُدْرَكُ، فَعَلَيْكَ بِمَا يَنْفَعُكَ فَالْزَمْهُ.", source: "الإمام الشافعي", region: "مصر", sourceType: "shafii" },
    { text: "مَعَ القُرْآنِ لَا تَضِلُّ، وَمَعَ السُّنَّةِ لَا تَجْهَلُ.", source: "الإمام أحمد بن حنبل", region: "بغداد", sourceType: "hanbal" },
    { text: "أُصُولُ السُّنَّةِ عِنْدَنَا: التَّمَسُّكُ بِمَا كَانَ عَلَيْهِ أَصْحَابُ رَسُولِ اللَّهِ.", source: "الإمام أحمد بن حنبل", region: "بغداد", sourceType: "hanbal" },
    { text: "مَنْ دَعَا إِلَى بِدْعَةٍ فَهُوَ مَبْغُوضٌ.", source: "الإمام أحمد بن حنبل", region: "بغداد", sourceType: "hanbal" },
    { text: "كُتُبُ الحَدِيثِ خَيْرٌ مِنْ كُتُبِ الدَّرَاهِمِ وَالدَّنَانِيرِ.", source: "الإمام أحمد بن حنبل", region: "بغداد", sourceType: "hanbal" },
    { text: "إذَا صَحَّ الحَدِيثُ فَهُوَ مَذْهَبِي.", source: "الإمام أبو حنيفة", region: "الكوفة", sourceType: "hanifa" },
    { text: "لَا يَحِلُّ لِأَحَدٍ أَنْ يَأْخُذَ بِقَوْلِنَا مَا لَمْ يَعْلَمْ مِنْ أَيْنَ أَخَذْنَاهُ.", source: "الإمام أبو حنيفة", region: "العراق", sourceType: "hanifa" },
    { text: "العِلْمُ أَفْضَلُ مِنَ المَالِ، لِأَنَّ العِلْمَ يَحْرُسُكَ، وَأَنْتَ تَحْرُسُ المَالَ.", source: "الإمام أبو حنيفة", region: "الكوفة", sourceType: "hanifa" },
    { text: "مَنْ طَلَبَ العِلْمَ لِلدُّنْيَا فَاتَهُ العِلْمُ وَالدُّنْيَا، وَمَنْ طَلَبَهُ لِلآخِرَةِ نَالَ العِلْمَ وَالدُّنْيَا وَالآخِرَةَ.", source: "الإمام أبو حنيفة", region: "الكوفة", sourceType: "hanifa" },
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

// ===== التهيئة =====
document.addEventListener('DOMContentLoaded', function() {
    initializeScrollTopButton();
    initializeNavigation();
    initializeAnimation();
    initializeScrollEffects();
    initThemeToggle();
    initFontSelector();
    loadWisdomGrid();
    updateDailyWisdom();
    
    document.getElementById('newWisdomBtn').addEventListener('click', updateDailyWisdom);
});

// ===== دوال التحكم =====

function initializeScrollTopButton() {
    const scrollTopBtn = document.getElementById('scrollTopBtn');
    window.addEventListener('scroll', function() {
        if (window.pageYOffset > 300) {
            scrollTopBtn.classList.add('show');
        } else {
            scrollTopBtn.classList.remove('show');
        }
    });
    scrollTopBtn.addEventListener('click', function() {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
}

function initializeNavigation() {
    const navLinks = document.querySelectorAll('.nav-link');
    const hamburger = document.querySelector('.hamburger');
    const navMenu = document.querySelector('.nav-menu');
    
    if (hamburger) {
        hamburger.addEventListener('click', function() {
            navMenu.classList.toggle('active');
        });
    }
    
    navLinks.forEach(link => {
        link.addEventListener('click', function() {
            if (navMenu) navMenu.classList.remove('active');
        });
    });
}

function initializeAnimation() {
    const observerOptions = { threshold: 0.1, rootMargin: '0px 0px -100px 0px' };
    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const delay = entry.target.getAttribute('data-aos-delay') || 0;
                setTimeout(() => entry.target.classList.add('aos-animate'), delay);
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-aos]').forEach(el => observer.observe(el));
}

function initializeScrollEffects() {
    const header = document.querySelector('header');
    window.addEventListener('scroll', function() {
        header.style.boxShadow = window.pageYOffset > 50 
            ? '0 4px 20px var(--shadow-color)' 
            : '0 2px 10px var(--shadow-color)';
    });
}

// ===== حكمة اليوم =====
function updateDailyWisdom() {
    const randomIndex = Math.floor(Math.random() * wisdomLibrary.length);
    const wisdom = wisdomLibrary[randomIndex];
    document.getElementById('dailyWisdomText').textContent = wisdom.text;
    document.getElementById('dailyWisdomSource').textContent = `— ${wisdom.source}`;
    document.getElementById('dailyWisdomRegion').textContent = wisdom.region;
    document.getElementById('dailyWisdomCard').setAttribute('data-source', wisdom.sourceType);
}

// ===== تحميل شبكة الحكم =====
function loadWisdomGrid() {
    const grid = document.getElementById('wisdomGrid');
    if (!grid) return;
    
    // اختر 12 حكمة عشوائية
    const shuffled = [...wisdomLibrary].sort(() => 0.5 - Math.random());
    const selected = shuffled.slice(0, 12);
    
    grid.innerHTML = selected.map(w => `
        <div class="wisdom-card" data-source="${w.sourceType}">
            <div class="card-content">
                <div class="quote-icon">"</div>
                <p class="wisdom-text">${w.text}</p>
                <p class="wisdom-source">— ${w.source}</p>
            </div>
            <div class="wisdom-region">${w.region}</div>
        </div>
    `).join('');
}

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
    
    // تحميل الخط المحفوظ
    const savedFont = localStorage.getItem('selectedFont') || 'Amiri';
    applyFont(savedFont);
    fontSelector.value = savedFont;
    
    fontSelector.addEventListener('change', (e) => {
        const selectedFont = e.target.value;
        applyFont(selectedFont);
        localStorage.setItem('selectedFont', selectedFont);
    });
}

function applyFont(fontName) {
    document.body.style.fontFamily = `'${fontName}', var(--font-secondary)`;
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
    }).catch(err => alert('حدث خطأ في النسخ'));
}

// ===== Smooth Scroll for Anchor Links =====
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) target.scrollIntoView({ behavior: 'smooth', block: 'start' });
    });
});

// ===== رسالة ترحيب في الكونسول =====
console.log('%c🌟 HIKAM - حكم 🌟', 'color: #d4af37; font-size: 20px; font-weight: bold;');
console.log('%c أكثر من 100 حكمة من الأئمة الأربعة والحكم العربية', 'color: #1a472a; font-size: 14px;');
