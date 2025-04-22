<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Footer -->
<footer class="site-footer">
    <div class="footer-top">
        <div class="container">
            <div class="footer-widgets">
                <div class="footer-widget">
                    <h3>About Panna BookStore</h3>
                    <p>Nepal's leading bookstore offering a wide selection of books across genres. We're dedicated to promoting literacy and a love for reading in our community.</p>
                    <div class="footer-social">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-pinterest"></i></a>
                    </div>
                </div>
                <div class="footer-widget">
                    <h3>Quick Links</h3>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
                        <li><a href="${pageContext.request.contextPath}/contact">Contact Us</a></li>
                        <li><a href="${pageContext.request.contextPath}/terms">Terms & Conditions</a></li>
                        <li><a href="${pageContext.request.contextPath}/privacy">Privacy Policy</a></li>
                        <li><a href="${pageContext.request.contextPath}/shipping">Shipping & Returns</a></li>
                        <li><a href="${pageContext.request.contextPath}/faq">FAQ</a></li>
                    </ul>
                </div>
                <div class="footer-widget">
                    <h3>Categories</h3>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/category/fiction">Fiction</a></li>
                        <li><a href="${pageContext.request.contextPath}/category/non-fiction">Non-Fiction</a></li>
                        <li><a href="${pageContext.request.contextPath}/category/children">Children's Books</a></li>
                        <li><a href="${pageContext.request.contextPath}/category/textbooks">Textbooks</a></li>
                        <li><a href="${pageContext.request.contextPath}/category/nepali">Nepali Literature</a></li>
                    </ul>
                </div>
                <div class="footer-widget">
                    <h3>Contact Us</h3>
                    <ul class="contact-info">
                        <li><i class="fas fa-map-marker-alt"></i> 123 Putali Sadak, Kathmandu, Nepal</li>
                        <li><i class="fas fa-phone"></i> +977 987-654-3210</li>
                        <li><i class="fas fa-envelope"></i> info@pannabookstore.com</li>
                        <li><i class="fas fa-clock"></i> Mon-Sat: 9:00 AM - 8:00 PM</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <div class="footer-bottom">
        <div class="container">
            <div class="copyright">
                <p>&copy; <%= java.time.Year.now().getValue() %> Panna BookStore. All Rights Reserved.</p>
            </div>
            <div class="payment-methods">
                <span>Accepted Payment Methods:</span>
                <img src="${pageContext.request.contextPath}/images/payment-methods.png" alt="Payment Methods">
            </div>
        </div>
    </div>
    <div id="back-to-top">
        <i class="fas fa-chevron-up"></i>
    </div>
</footer>

<!-- JavaScript -->
<script src="${pageContext.request.contextPath}/js/home.js"></script>