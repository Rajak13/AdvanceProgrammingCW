document.addEventListener('DOMContentLoaded', () => {
    const container = document.getElementById('container');
    const urlParams = new URLSearchParams(window.location.search);

    // Clean URL parameter handling
    const handleUrlParams = () => {
        if (urlParams.has('registered')) {
            container.classList.remove('right-panel-active');
            history.replaceState(null, '', window.location.pathname);
        }
    };

    // Panel toggle with animation safeguards
    const togglePanel = (action) => {
        container.classList[action]('right-panel-active');
        document.activeElement.blur(); // Remove focus from buttons
    };

    // Event delegation for better performance
    document.body.addEventListener('click', (e) => {
        if (e.target.matches('#signUp, #signUp *')) {
            togglePanel('add');
        } else if (e.target.matches('#signIn, #signIn *')) {
            togglePanel('remove');
        }
    });

    // Initial setup
    handleUrlParams();
    
    // Add keyboard navigation support
    document.addEventListener('keyup', (e) => {
        if (e.key === 'Escape' && container.classList.contains('right-panel-active')) {
            togglePanel('remove');
        }
    });
});