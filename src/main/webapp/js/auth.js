document.addEventListener('DOMContentLoaded', () => {
    const signUpButton = document.getElementById('signUp');
    const signInButton = document.getElementById('signIn');
    const container = document.getElementById('container');
    
    const togglePanel = (isRightActive) => {
        container.classList.toggle('right-panel-active', isRightActive);
        
        // Force reflow to trigger animations
        void container.offsetWidth;
    };

    signUpButton.addEventListener('click', () => togglePanel(true));
    signInButton.addEventListener('click', () => togglePanel(false));
    
    // Initialize with correct panel
    togglePanel(false);
});