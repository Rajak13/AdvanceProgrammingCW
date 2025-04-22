<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- About Banner -->
<section class="about-banner">
    <div class="container">
        <div class="about-banner-content">
            <h1>About Panna BookStore</h1>
            <p>Nepal's premier destination for book lovers since 2010</p>
        </div>
    </div>
</section>

<!-- Our Story -->
<section class="about-section">
    <div class="container">
        <div class="about-content">
            <div class="about-image">
                <img src="${pageContext.request.contextPath}/images/about-store.png" alt="Panna BookStore Interior">
            </div>
            <div class="about-text">
                <h2>Our Story</h2>
                <p>Panna BookStore was founded in 2010 with a simple mission: to promote literacy and foster a love for reading in Nepal. What started as a small bookshop in Putali Sadak, Kathmandu has now grown into one of the country's leading book retailers.</p>
                <p>Our journey began when our founder, Panna Sharma, a passionate bibliophile, recognized the need for a bookstore that not only sold books but created a community for readers. With dedication and a love for literature, Panna BookStore was born.</p>
                <p>Today, we proudly serve thousands of customers, offering a carefully curated selection of books across genres, from international bestsellers to works by local Nepali authors. Our commitment to promoting reading culture and supporting education remains at the heart of everything we do.</p>
            </div>
        </div>
    </div>
</section>

<!-- Our Mission -->
<section class="mission-section">
    <div class="container">
        <div class="section-header">
            <h2>Our Mission</h2>
            <p>What drives us every day</p>
        </div>
        <div class="mission-values">
            <div class="mission-card">
                <div class="mission-icon">
                    <i class="fas fa-book-reader"></i>
                </div>
                <h3>Promote Literacy</h3>
                <p>We believe that literacy is a fundamental right. Through our bookstore and outreach programs, we strive to make books accessible to all and promote reading as a lifelong habit.</p>
            </div>
            <div class="mission-card">
                <div class="mission-icon">
                    <i class="fas fa-hands-helping"></i>
                </div>
                <h3>Support Local Authors</h3>
                <p>We take pride in showcasing and supporting Nepali authors and publishers, helping to nurture local literary talent and preserve our cultural heritage through literature.</p>
            </div>
            <div class="mission-card">
                <div class="mission-icon">
                    <i class="fas fa-users"></i>
                </div>
                <h3>Build Community</h3>
                <p>More than just a bookstore, we aim to create a vibrant community of readers through book clubs, author events, and literary discussions that bring people together.</p>
            </div>
        </div>
    </div>
</section>

<!-- Team Section -->
<section class="team-section">
    <div class="container">
        <div class="section-header">
            <h2>Meet Our Team</h2>
            <p>The passionate people behind Panna BookStore</p>
        </div>
        <div class="team-grid">
            <div class="team-member">
                <div class="member-image">
                    <img src="${pageContext.request.contextPath}/images/team/founder.jpg" alt="Panna Sharma">
                </div>
                <div class="member-info">
                    <h3>Panna Sharma</h3>
                    <p class="member-role">Founder & CEO</p>
                    <p class="member-bio">A lifelong book lover with a vision to transform Nepal's reading culture.</p>
                </div>
            </div>
            <div class="team-member">
                <div class="member-image">
                    <img src="${pageContext.request.contextPath}/images/team/manager.jpg" alt="Aarya Thapa">
                </div>
                <div class="member-info">
                    <h3>Aarya Thapa</h3>
                    <p class="member-role">Store Manager</p>
                    <p class="member-bio">Ensures our bookstore provides an exceptional experience for all visitors.</p>
                </div>
            </div>
            <div class="team-member">
                <div class="member-image">
                    <img src="${pageContext.request.contextPath}/images/team/curator.jpg" alt="Rohan Shrestha">
                </div>
                <div class="member-info">
                    <h3>Rohan Shrestha</h3>
                    <p class="member-role">Book Curator</p>
                    <p class="member-bio">Our literary expert who carefully selects each book in our collection.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Testimonials -->
<section class="testimonials-section">
    <div class="container">
        <div class="section-header">
            <h2>What Our Customers Say</h2>
            <p>Hear from our community of book lovers</p>
        </div>
        <div class="testimonials-slider">
            <div class="testimonial">
                <div class="testimonial-text">
                    <i class="fas fa-quote-left"></i>
                    <p>Panna BookStore has been my go-to place for books for years. Their collection is impressive, and the staff recommendations have never disappointed me.</p>
                </div>
                <div class="testimonial-author">
                    <div class="author-image">
                        <img src="${pageContext.request.contextPath}/images/testimonials/customer1.jpg" alt="Anita Gurung">
                    </div>
                    <div class="author-info">
                        <h4>Anita Gurung</h4>
                        <p>Literature Professor</p>
                    </div>
                </div>
            </div>
            <div class="testimonial">
                <div class="testimonial-text">
                    <i class="fas fa-quote-left"></i>
                    <p>What sets Panna BookStore apart is their commitment to promoting Nepali literature. As an author, I'm grateful for their support of local writers.</p>
                </div>
                <div class="testimonial-author">
                    <div class="author-image">
                        <img src="${pageContext.request.contextPath}/images/testimonials/customer2.jpg" alt="Dipesh Rijal">
                    </div>
                    <div class="author-info">
                        <h4>Dipesh Rijal</h4>
                        <p>Nepali Author</p>
                    </div>
                </div>
            </div>
            <div class="testimonial">
                <div class="testimonial-text">
                    <i class="fas fa-quote-left"></i>
                    <p>I love the book club events at Panna BookStore! They've helped me discover new genres and connect with fellow book lovers in Kathmandu.</p>
                </div>
                <div class="testimonial-author">
                    <div class="author-image">
                        <img src="${pageContext.request.contextPath}/images/testimonials/customer3.jpg" alt="Priya Maharjan">
                    </div>
                    <div class="author-info">
                        <h4>Priya Maharjan</h4>
                        <p>Regular Customer</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="testimonial-controls">
            <button class="slider-btn testimonial-prev-btn"><i class="fas fa-chevron-left"></i></button>
            <button class="slider-btn testimonial-next-btn"><i class="fas fa-chevron-right"></i></button>
        </div>
    </div>
</section>

<style>
    .about-banner {
        background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
        color: var(--white);
        padding: 80px 0;
        text-align: center;
    }
    
    .about-banner h1 {
        font-size: 42px;
        margin-bottom: 15px;
    }
    
    .about-banner p {
        font-size: 18px;
        max-width: 700px;
        margin: 0 auto;
        opacity: 0.9;
    }
    
    .about-section {
        padding: 80px 0;
        background-color: var(--white);
    }
    
    .about-content {
        display: flex;
        align-items: center;
        gap: 40px;
    }
    
    .about-image {
        flex: 1;
    }
    
    .about-image img {
        width: 100%;
        border-radius: 10px;
        box-shadow: var(--shadow);
    }
    
    .about-text {
        flex: 1;
    }
    
    .about-text h2 {
        color: var(--primary-dark);
        margin-bottom: 20px;
        font-size: 32px;
    }
    
    .about-text p {
        margin-bottom: 15px;
        line-height: 1.8;
    }
    
    .mission-section {
        padding: 80px 0;
        background-color: var(--light-bg);
    }
    
    .mission-values {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 30px;
        margin-top: 40px;
    }
    
    .mission-card {
        background-color: var(--white);
        padding: 30px;
        border-radius: 10px;
        box-shadow: var(--shadow);
        text-align: center;
        transition: var(--transition);
    }
    
    .mission-card:hover {
        transform: translateY(-10px);
        box-shadow: 0 15px 30px rgba(0,0,0,0.1);
    }
    
    .mission-icon {
        width: 70px;
        height: 70px;
        margin: 0 auto 20px;
        background: var(--primary-color);
        color: var(--white);
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        font-size: 24px;
    }
    
    .mission-card h3 {
        color: var(--primary-dark);
        margin-bottom: 15px;
    }
    
    .team-section {
        padding: 80px 0;
        background-color: var(--white);
    }
    
    .team-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 30px;
        margin-top: 40px;
    }
    
    .team-member {
        background-color: var(--light-bg);
        border-radius: 10px;
        overflow: hidden;
        box-shadow: var(--shadow);
        transition: var(--transition);
    }
    
    .team-member:hover {
        transform: translateY(-10px);
        box-shadow: 0 15px 30px rgba(0,0,0,0.1);
    }
    
    .member-image img {
        width: 100%;
        height: 300px;
        object-fit: cover;
    }
    
    .member-info {
        padding: 20px;
        text-align: center;
    }
    
    .member-info h3 {
        color: var(--primary-dark);
        margin-bottom: 5px;
    }
    
    .member-role {
        color: var(--accent-color);
        font-weight: 500;
        margin-bottom: 10px;
    }
    
    .testimonials-section {
        padding: 80px 0;
        background-color: var(--light-bg);
    }
    
    .testimonials-slider {
        display: flex;
        overflow-x: auto;
        gap: 30px;
        margin-top: 40px;
        padding: 20px 0;
        scroll-behavior: smooth;
        scrollbar-width: none;
    }
    
    .testimonials-slider::-webkit-scrollbar {
        display: none;
    }
    
    .testimonial {
        flex: 0 0 350px;
        background-color: var(--white);
        border-radius: 10px;
        padding: 30px;
        box-shadow: var(--shadow);
    }
    
    .testimonial-text {
        margin-bottom: 20px;
    }
    
    .testimonial-text i {
        font-size: 24px;
        color: var(--accent-color);
        margin-right: 10px;
    }
    
    .testimonial-author {
        display: flex;
        align-items: center;
        gap: 15px;
    }
    
    .author-image {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        overflow: hidden;
    }
    
    .author-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    
    .author-info h4 {
        margin-bottom: 5px;
        color: var(--primary-dark);
    }
    
    .author-info p {
        font-size: 12px;
        color: var(--light-text);
    }
    
    .testimonial-controls {
        text-align: center;
        margin-top: 30px;
    }
    
    @media (max-width: 768px) {
        .about-content {
            flex-direction: column;
        }
        
        .testimonial {
            flex: 0 0 280px;
        }
        
        .about-banner h1 {
            font-size: 32px;
        }
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Testimonials Slider
        const slider = document.querySelector('.testimonials-slider');
        const prevBtn = document.querySelector('.testimonial-prev-btn');
        const nextBtn = document.querySelector('.testimonial-next-btn');
        
        if (slider && prevBtn && nextBtn) {
            const cardWidth = 380; // Testimonial width + gap
            
            prevBtn.addEventListener('click', function() {
                slider.scrollBy({
                    left: -cardWidth,
                    behavior: 'smooth'
                });
            });
            
            nextBtn.addEventListener('click', function() {
                slider.scrollBy({
                    left: cardWidth,
                    behavior: 'smooth'
                });
            });
        }
    });
</script> 