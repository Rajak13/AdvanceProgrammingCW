document.addEventListener('DOMContentLoaded', function() {
    // Mobile Navigation Toggle
    const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
    const mobileNav = document.querySelector('.mobile-nav');
    const closeNav = document.querySelector('.close-mobile-nav');
    const body = document.body;
    
    if (mobileMenuToggle && mobileNav) {
        mobileMenuToggle.addEventListener('click', function() {
            mobileNav.classList.add('active');
            body.style.overflow = 'hidden';
            createOverlay();
        });
    }
    
    if (closeNav) {
        closeNav.addEventListener('click', function() {
            mobileNav.classList.remove('active');
            body.style.overflow = '';
            removeOverlay();
        });
    }
    
    function createOverlay() {
        let overlay = document.createElement('div');
        overlay.className = 'mobile-overlay active';
        overlay.addEventListener('click', function() {
            mobileNav.classList.remove('active');
            body.style.overflow = '';
            removeOverlay();
        });
        body.appendChild(overlay);
    }
    
    function removeOverlay() {
        const overlay = document.querySelector('.mobile-overlay');
        if (overlay) {
            overlay.remove();
        }
    }
    
    // Mobile dropdown toggle
    const mobileDropdownToggle = document.querySelectorAll('.mobile-nav-menu .has-dropdown > a');
    
    mobileDropdownToggle.forEach(function(link) {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const dropdown = this.nextElementSibling;
            dropdown.classList.toggle('active');
        });
    });
    
    // Featured Books Slider
    const booksSlider = document.querySelector('.books-slider');
    const prevBtn = document.querySelector('.prev-btn');
    const nextBtn = document.querySelector('.next-btn');
    
    if (booksSlider && prevBtn && nextBtn) {
        const cardWidth = 240; // Card width + gap
        
        prevBtn.addEventListener('click', function() {
            booksSlider.scrollBy({
                left: -cardWidth,
                behavior: 'smooth'
            });
        });
        
        nextBtn.addEventListener('click', function() {
            booksSlider.scrollBy({
                left: cardWidth,
                behavior: 'smooth'
            });
        });
    }
    
    // New Arrivals Slider
    const arrivalsSlider = document.querySelector('.arrivals-slider');
    const arrivalsPrevBtn = document.querySelector('.arrivals-prev-btn');
    const arrivalsNextBtn = document.querySelector('.arrivals-next-btn');
    
    if (arrivalsSlider && arrivalsPrevBtn && arrivalsNextBtn) {
        const cardWidth = 240; // Card width + gap
        
        arrivalsPrevBtn.addEventListener('click', function() {
            arrivalsSlider.scrollBy({
                left: -cardWidth,
                behavior: 'smooth'
            });
        });
        
        arrivalsNextBtn.addEventListener('click', function() {
            arrivalsSlider.scrollBy({
                left: cardWidth,
                behavior: 'smooth'
            });
        });
    }
    
    // Book Actions
    const quickViewBtns = document.querySelectorAll('.book-actions .quick-view');
    const addToWishlistBtns = document.querySelectorAll('.book-actions .add-to-wishlist');
    const addToCartBtns = document.querySelectorAll('.book-actions .add-to-cart');
    
    quickViewBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            const bookCard = this.closest('.book-card');
            const title = bookCard.querySelector('h3').textContent;
            alert(`Quick view for "${title}"`);
            // Replace with modal implementation in a real application
        });
    });
    
    addToWishlistBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            const bookCard = this.closest('.book-card');
            const title = bookCard.querySelector('h3').textContent;
            this.innerHTML = '<i class="fas fa-heart"></i>'; // Change to filled heart
            this.style.color = '#FF5722';
            alert(`"${title}" added to wishlist`);
        });
    });
    
    addToCartBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            const bookCard = this.closest('.book-card');
            const title = bookCard.querySelector('h3').textContent;
            
            // Update cart count
            const cartCount = document.querySelector('.cart-count');
            if (cartCount) {
                cartCount.textContent = parseInt(cartCount.textContent) + 1;
                cartCount.style.transform = 'scale(1.2)';
                setTimeout(() => {
                    cartCount.style.transform = 'scale(1)';
                }, 300);
            }
            
            alert(`"${title}" added to cart`);
        });
    });
    
    // Header Scroll Effect
    const header = document.querySelector('.site-header');
    let lastScrollY = 0;
    
    window.addEventListener('scroll', function() {
        const currentScrollY = window.scrollY;
        
        // Add shadow when scrolled
        if (currentScrollY > 50) {
            header.classList.add('scrolled');
        } else {
            header.classList.remove('scrolled');
        }
        
        lastScrollY = currentScrollY;
    });
    
    // Newsletter Form
    const newsletterForm = document.querySelector('.newsletter-form');
    
    if (newsletterForm) {
        newsletterForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const emailInput = this.querySelector('input[type="email"]');
            
            if (emailInput && emailInput.value) {
                alert(`Thank you for subscribing with ${emailInput.value}!`);
                emailInput.value = '';
            }
        });
    }
    
    // Back to Top Button
    const backToTop = document.getElementById('back-to-top');
    
    if (backToTop) {
        window.addEventListener('scroll', function() {
            if (window.scrollY > 500) {
                backToTop.classList.add('visible');
            } else {
                backToTop.classList.remove('visible');
            }
        });
        
        backToTop.addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }
    
    // Initialize animations for elements that should fade in when scrolled to
    const animateOnScroll = function() {
        const elements = document.querySelectorAll('.category-card, .book-card, .benefit-card');
        
        elements.forEach(function(element) {
            // Add animation classes initially
            element.classList.add('animate-on-scroll');
            
            // Check if element is in viewport and animate it
            const checkPosition = function() {
                const rect = element.getBoundingClientRect();
                const windowHeight = window.innerHeight || document.documentElement.clientHeight;
                
                if (rect.top <= windowHeight * 0.8) {
                    element.classList.add('animated');
                }
            };
            
            // Check positions initially and on scroll
            checkPosition();
            window.addEventListener('scroll', checkPosition);
        });
    };
    
    animateOnScroll();
    
    // Add CSS for animations
    const style = document.createElement('style');
    style.textContent = `
        .animate-on-scroll {
            opacity: 0;
            transform: translateY(20px);
            transition: opacity 0.6s ease, transform 0.6s ease;
        }
        .animate-on-scroll.animated {
            opacity: 1;
            transform: translateY(0);
        }
        .site-header.scrolled {
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
    `;
    document.head.appendChild(style);
});