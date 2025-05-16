// Make sure to include these script dependencies in your JSP files:
// <script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.0/dist/chart.min.js"></script>
// <script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
// <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>

var AdminDashboard = {
    init: function() {
        this.initializeCharts();
        this.initializeEventListeners();
        this.initializeDataTables();
        this.handleResponsive();
        this.initializeModals();
        this.initializeFormSubmissions();
    },

    initializeCharts: function() {
        var self = this;
        
        // Revenue Chart
        var revenueChart = document.getElementById('revenueChart');
        if (revenueChart && window.Chart) {
            new Chart(revenueChart.getContext('2d'), {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'],
                    datasets: [
                        {
                            label: 'Google ads',
                            data: [65, 210, 180, 150, 100, 30, 120, 30],
                            borderColor: '#4CAF50',
                            backgroundColor: 'transparent',
                            tension: 0.4,
                            pointRadius: 4,
                            pointBackgroundColor: '#4CAF50'
                        },
                        {
                            label: 'Facebook ads',
                            data: [30, 120, 90, 50, 150, 300, 120, 180],
                            borderColor: '#FF9800',
                            backgroundColor: 'transparent',
                            tension: 0.4,
                            pointRadius: 4,
                            pointBackgroundColor: '#FF9800'
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'top',
                            align: 'end',
                            labels: {
                                boxWidth: 8,
                                usePointStyle: true,
                                pointStyle: 'circle'
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: {
                                color: 'rgba(0, 0, 0, 0.05)'
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            }
                        }
                    }
                }
            });
        }

        // Website Visitors Chart
        var visitorsChart = document.getElementById('visitorsChart');
        if (visitorsChart && window.Chart) {
            new Chart(visitorsChart.getContext('2d'), {
                type: 'doughnut',
                data: {
                    labels: ['Direct', 'Organic', 'Paid', 'Social'],
                    datasets: [{
                        data: [38, 22, 12, 28],
                        backgroundColor: ['#FF9800', '#4CAF50', '#03A9F4', '#E91E63'],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'right',
                            labels: {
                                boxWidth: 8,
                                usePointStyle: true,
                                pointStyle: 'circle'
                            }
                        }
                    },
                    cutout: '75%'
                }
            });
        }

        // Buyers Profile Chart
        const buyersChart = document.getElementById('buyersChart');
        if (buyersChart) {
            new Chart(buyersChart, {
                type: 'doughnut',
                data: {
                    labels: ['Male', 'Female', 'Others'],
                    datasets: [{
                        data: [50, 35, 15],
                        backgroundColor: ['#FF9800', '#4CAF50', '#03A9F4'],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'right',
                            labels: {
                                boxWidth: 8,
                                usePointStyle: true,
                                pointStyle: 'circle'
                            }
                        }
                    },
                    cutout: '75%'
                }
            });
        }
    },

    initializeEventListeners: function() {
        var self = this;
        
        // Sidebar Toggle
        var sidebarToggle = document.querySelector('.sidebar-toggle');
        var sidebar = document.querySelector('.admin-sidebar');
        var mainContent = document.querySelector('.admin-main');
        
        if (sidebarToggle) {
            sidebarToggle.onclick = function() {
                if (sidebar) sidebar.classList.toggle('collapsed');
                if (mainContent) mainContent.classList.toggle('expanded');
            };
        }

        // Chart Period Toggle
        var chartButtons = document.querySelectorAll('.chart-actions button');
        chartButtons.forEach(function(button) {
            button.onclick = function() {
                chartButtons.forEach(function(btn) {
                    btn.classList.remove('active');
                });
                this.classList.add('active');
                self.updateChartData(this.textContent.toLowerCase());
            };
        });

        // Search Functionality
        var searchInput = document.querySelector('.search-bar input');
        if (searchInput) {
            searchInput.onkeyup = self.debounce(function(e) {
                self.performSearch(e.target.value);
            }, 300);
        }
    },

    initializeModals: function() {
        // Add New Book/User button click handler
        var addButtons = document.querySelectorAll('#addBookBtn, #addUserBtn');
        for (var i = 0; i < addButtons.length; i++) {
            addButtons[i].onclick = function() {
                var modalId = this.id === 'addBookBtn' ? 'bookModal' : 'userModal';
                var modal = document.getElementById(modalId);
                if (modal) {
                    modal.style.display = 'block';
                    modal.classList.add('show');
                }
            };
        }

        // Close button handlers
        var closeButtons = document.querySelectorAll('.modal-close, .btn-secondary');
        for (var j = 0; j < closeButtons.length; j++) {
            closeButtons[j].onclick = function() {
                var modal = this.closest('.modal');
                if (modal) {
                    modal.style.display = 'none';
                    modal.classList.remove('show');
                }
            };
        }

        // Close on outside click
        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                event.target.style.display = 'none';
                event.target.classList.remove('show');
            }
        };
    },

    openModal: function(modalId) {
        var modal = document.getElementById(modalId);
        if (modal) {
            modal.style.display = 'block';
            modal.classList.add('show');
        }
    },

    closeModal: function(modalId) {
        var modal = document.getElementById(modalId);
        if (modal) {
            modal.style.display = 'none';
            modal.classList.remove('show');
        }
    },

    showNotification: function(type, message) {
        var notification = document.createElement('div');
        notification.className = 'notification ' + type;
        notification.textContent = message;
        
        document.body.appendChild(notification);
        
        setTimeout(function() {
            notification.classList.add('show');
        }, 100);
        
        setTimeout(function() {
            notification.classList.remove('show');
            setTimeout(function() {
                notification.remove();
            }, 300);
        }, 3000);
    },

    initializeDataTables: function() {
        if (window.jQuery && jQuery.fn.DataTable) {
            jQuery('.data-table').DataTable({
                pageLength: 10,
                responsive: true,
                dom: '<"table-header"<"table-search"f><"table-length"l>><"table-content"t><"table-footer"<"table-info"i><"table-pagination"p>>',
                language: {
                    search: "",
                    searchPlaceholder: "Search...",
                    lengthMenu: "Show _MENU_",
                    info: "Showing _START_ to _END_ of _TOTAL_ entries"
                }
            });
        }
    },

    handleResponsive: function() {
        var self = this;
        
        function handleResize() {
            if (window.innerWidth <= 768) {
                var sidebar = document.querySelector('.admin-sidebar');
                var mainContent = document.querySelector('.admin-main');
                
                if (sidebar) sidebar.classList.add('collapsed');
                if (mainContent) mainContent.classList.add('expanded');
            }
        }

        window.onresize = handleResize;
        handleResize();
    },

    // Utility Functions
    debounce: function(func, wait) {
        var timeout;
        return function() {
            var context = this;
            var args = arguments;
            clearTimeout(timeout);
            timeout = setTimeout(function() {
                func.apply(context, args);
            }, wait);
        };
    },

    updateChartData: function(period) {
        // Implement chart data update logic based on period
        console.log('Updating chart data for period:', period);
    },

    performSearch: function(query) {
        // Implement search functionality
        console.log('Searching for:', query);
    },

    initializeFormSubmissions: function() {
        var self = this;
        
        // Book form submission
        var bookForm = document.getElementById('bookForm');
        if (bookForm) {
            bookForm.onsubmit = function(e) {
                e.preventDefault();
                var formData = new FormData(this);
                var bookId = document.getElementById('bookId').value;
                
                // Add any missing fields
                if (!formData.has('status')) {
                    formData.append('status', 'Active');
                }
                
                fetch(this.action || (bookId ? '/admin/books?action=edit' : '/admin/books?action=add'), {
                    method: 'POST',
                    body: formData
                })
                .then(function(response) {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(function(data) {
                    self.showNotification('success', 'Book saved successfully');
                    self.closeModal('bookModal');
                    window.location.reload();
                })
                .catch(function(error) {
                    console.error('Error:', error);
                    self.showNotification('error', 'Error saving book');
                });
            };
        }

        // User form submission
        var userForm = document.getElementById('userForm');
        if (userForm) {
            userForm.onsubmit = function(e) {
                e.preventDefault();
                var formData = new FormData(this);
                var userId = document.getElementById('userId').value;
                
                // Add any missing fields
                if (!formData.has('role')) {
                    formData.append('role', 'USER');
                }
                
                fetch(this.action || '/admin/users', {
                    method: 'POST',
                    body: formData
                })
                .then(function(response) {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(function(data) {
                    self.showNotification('success', 'User saved successfully');
                    self.closeModal('userModal');
                    window.location.reload();
                })
                .catch(function(error) {
                    console.error('Error:', error);
                    self.showNotification('error', 'Error saving user');
                });
            };
        }
    }
};

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    AdminDashboard.init();
});

// Make AdminDashboard globally accessible
window.AdminDashboard = AdminDashboard; 