// ===== Initialization =====
document.addEventListener('DOMContentLoaded', function() {
    initializeScrollTopButton();
    initializeNavigation();
    initializeAnimation();
    initializeScrollEffects();
});

// ===== Scroll to Top Button =====
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
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
}

// ===== Navigation =====
function initializeNavigation() {
    const navLinks = document.querySelectorAll('.nav-link');
    const hamburger = document.querySelector('.hamburger');
    const navMenu = document.querySelector('.nav-menu');
    
    // Mobile menu toggle
    if (hamburger) {
        hamburger.addEventListener('click', function() {
            navMenu.classList.toggle('active');
        });
    }
    
    // Close menu on link click
    navLinks.forEach(link => {
        link.addEventListener('click', function() {
            if (navMenu) navMenu.classList.remove('active');
        });
    });
    
    // Add active state to current link
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            navLinks.forEach(l => l.classList.remove('active'));
            this.classList.add('active');
        });
    });
}

// ===== Scroll Animation (AOS alternative) =====
function initializeAnimation() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -100px 0px'
    };
    
    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const delay = entry.target.getAttribute('data-aos-delay') || 0;
                setTimeout(() => {
                    entry.target.classList.add('aos-animate');
                }, delay);
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);
    
    const animatedElements = document.querySelectorAll('[data-aos]');
    animatedElements.forEach(element => observer.observe(element));
}

// ===== Scroll Effects =====
function initializeScrollEffects() {
    const header = document.querySelector('header');
    
    window.addEventListener('scroll', function() {
        if (window.pageYOffset > 50) {
            header.style.boxShadow = '0 4px 20px rgba(26, 71, 42, 0.3)';
        } else {
            header.style.boxShadow = '0 2px 10px rgba(26, 71, 42, 0.15)';
        }
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
    }).catch(err => {
        console.error('خطأ في النسخ:', err);
        alert('حدث خطأ في نسخ الكود');
    });
}

// ===== Smooth Scroll for Anchor Links =====
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// ===== Random Wisdom Display (Optional) =====
function displayRandomWisdom() {
    const wisdoms = [
        {
            text: 'العلم نور والجهل ظلام',
            author: 'الإمام علي',
            region: 'الجزيرة العربية'
        },
        {
            text: 'من عرف نفسه فقد عرف ربه',
            author: 'الإمام الغزالي',
            region: 'المغرب الإسلامي'
        },
        {
            text: 'الصبر مفتاح الفرج',
            author: 'الحكم الشرقية',
            region: 'بلاد الشام'
        }
    ];
    
    const random = wisdoms[Math.floor(Math.random() * wisdoms.length)];
    console.log(`${random.text} — ${random.author} (${random.region})`);
}

// ===== Performance: Lazy Loading Images =====
if ('IntersectionObserver' in window) {
    const images = document.querySelectorAll('img[data-src]');
    const imageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                img.src = img.dataset.src;
                img.removeAttribute('data-src');
                observer.unobserve(img);
            }
        });
    });
    
    images.forEach(img => imageObserver.observe(img));
}

// ===== Page Load Animation =====
window.addEventListener('load', function() {
    document.body.style.opacity = '1';
});

// ===== Keyboard Shortcuts =====
document.addEventListener('keydown', function(event) {
    // Ctrl+Shift+H للذهاب للرئيسية
    if (event.ctrlKey && event.shiftKey && event.key === 'H') {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
});

console.log('%c🌟 HIKAM - حكم 🌟', 'color: #d4af37; font-size: 20px; font-weight: bold;');
console.log('%c مشروع مفتوح المصدر لحكم المسلمين والعرب', 'color: #1a472a; font-size: 14px;');
console.log('%c GitHub: https://github.com/SalehGNUTUX/GT-hikam', 'color: #8b4513; font-size: 12px;');
