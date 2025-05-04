document.addEventListener('DOMContentLoaded', function() {
    // Sidebar Toggle
    const sidebarToggle = document.querySelector('.sidebar-toggle');
    const sidebar = document.querySelector('.admin-sidebar');
    const mainContent = document.querySelector('.admin-main');

    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', function() {
            sidebar.classList.toggle('active');
            mainContent.classList.toggle('sidebar-collapsed');
        });
    }

    // Initialize Chart
    const salesChart = document.getElementById('salesChart');
    if (salesChart) {
        const ctx = salesChart.getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                datasets: [{
                    label: 'Sales',
                    data: [12, 19, 3, 5, 2, 3],
                    backgroundColor: 'rgba(255, 87, 34, 0.2)',
                    borderColor: 'rgba(255, 87, 34, 1)',
                    borderWidth: 2,
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            display: true,
                            color: 'rgba(0, 0, 0, 0.1)'
                        },
                        ticks: {
                            callback: function(value) {
                                return '$' + value;
                            }
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

    // Chart Period Toggle
    const chartButtons = document.querySelectorAll('.chart-actions button');
    chartButtons.forEach(button => {
        button.addEventListener('click', function() {
            chartButtons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');
            // Here you would typically update the chart data based on the selected period
            updateChartData(this.textContent.toLowerCase());
        });
    });

    // Date Filter
    const dateFilter = document.querySelector('.date-filter select');
    if (dateFilter) {
        dateFilter.addEventListener('change', function() {
            // Here you would typically update the dashboard data based on the selected date range
            updateDashboardData(this.value);
        });
    }

    // Search Functionality
    const searchInput = document.querySelector('.search-bar input');
    const searchButton = document.querySelector('.search-bar button');
    
    if (searchInput && searchButton) {
        searchButton.addEventListener('click', function(e) {
            e.preventDefault();
            performSearch(searchInput.value);
        });

        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                performSearch(this.value);
            }
        });
    }

    function performSearch(query) {
        // Here you would typically implement the search functionality
        console.log('Searching for:', query);
        // You can make an AJAX call to your backend here
    }

    function updateChartData(period) {
        // Here you would typically fetch new chart data based on the period
        console.log('Updating chart data for period:', period);
        // You can make an AJAX call to your backend here
    }

    function updateDashboardData(dateRange) {
        // Here you would typically fetch new dashboard data based on the date range
        console.log('Updating dashboard data for date range:', dateRange);
        // You can make an AJAX call to your backend here
    }

    // Notifications
    const notifications = document.querySelector('.notifications');
    if (notifications) {
        notifications.addEventListener('click', function() {
            // Here you would typically show a notifications panel
            console.log('Notifications clicked');
            // You can make an AJAX call to fetch notifications here
        });
    }

    // User Dropdown
    const userMenu = document.querySelector('.user-menu');
    if (userMenu) {
        userMenu.addEventListener('click', function(e) {
            e.stopPropagation();
            const dropdown = this.querySelector('.user-dropdown');
            dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
        });

        // Close dropdown when clicking outside
        document.addEventListener('click', function() {
            const dropdown = document.querySelector('.user-dropdown');
            if (dropdown) {
                dropdown.style.display = 'none';
            }
        });
    }

    // Responsive Design
    function handleResponsive() {
        if (window.innerWidth <= 768) {
            sidebar.classList.remove('active');
            mainContent.classList.remove('sidebar-collapsed');
        }
    }

    window.addEventListener('resize', handleResponsive);
    handleResponsive();

    // Add loading state to buttons
    const buttons = document.querySelectorAll('.btn');
    buttons.forEach(button => {
        button.addEventListener('click', function() {
            if (this.classList.contains('btn-primary') || 
                this.classList.contains('btn-secondary') || 
                this.classList.contains('btn-danger')) {
                this.classList.add('loading');
                setTimeout(() => {
                    this.classList.remove('loading');
                }, 1000);
            }
        });
    });
}); 