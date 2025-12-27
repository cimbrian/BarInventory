// Simple auth helpers using localStorage
window.authHelper = {
    getLoginInfo: function () {
        const data = localStorage.getItem('barInventoryAuth');
        if (!data) return null;
        try {
            return JSON.parse(data);
        } catch {
            return null;
        }
    },
    
    setLoginInfo: function (username) {
        const data = {
            username: username,
            loginDate: new Date().toISOString()
        };
        localStorage.setItem('barInventoryAuth', JSON.stringify(data));
        return true;
    },
    
    clearLoginInfo: function () {
        localStorage.removeItem('barInventoryAuth');
        return true;
    },
    
    isLoggedIn: function () {
        const data = this.getLoginInfo();
        if (!data || !data.loginDate) return false;
        
        // Check if login is older than 30 days
        const loginDate = new Date(data.loginDate);
        const now = new Date();
        const daysDiff = (now - loginDate) / (1000 * 60 * 60 * 24);
        
        if (daysDiff > 30) {
            this.clearLoginInfo();
            return false;
        }
        
        return true;
    },
    
    getUsername: function () {
        const data = this.getLoginInfo();
        return data ? data.username : null;
    }
};
