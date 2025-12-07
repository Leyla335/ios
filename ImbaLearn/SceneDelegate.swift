import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // Check if user is logged in by checking for saved token
        if isUserLoggedIn() {
            print("✅ User is logged in, showing main app")
            showMainApp(animated: false) // No animation on initial launch
        } else {
            print("⚠️ User is not logged in, showing authentication")
            showAuthentication(animated: false) // No animation on initial launch
        }
        
        // Listen for session expired notifications
        setupNotifications()
        
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Session Management
    
    // Check if user has a valid authentication token
    private func isUserLoggedIn() -> Bool {
        // Check NetworkManager for saved token
        if let token = NetworkManager.shared.authToken, !token.isEmpty {
            print("Found saved token: \(token.prefix(20))...")
            return true
        }
        
        // Optional: Also check UserDefaults as backup
        if let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty {
            print("Found token in UserDefaults: \(token.prefix(20))...")
            // Also save to NetworkManager for consistency
            NetworkManager.shared.authToken = token
            return true
        }
        
        print("No authentication token found")
        return false
    }
    
    private func setupNotifications() {
        // Listen for session expired notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSessionExpired),
            name: .sessionExpired,
            object: nil
        )
        
        // Listen for logout notifications (optional)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLogout),
            name: Notification.Name("userDidLogout"),
            object: nil
        )
    }
    
    @objc private func handleSessionExpired(_ notification: Notification) {
        print("🔄 Session expired, redirecting to login...")
        
        // Clear all user data
        clearUserData()
        
        DispatchQueue.main.async {
            // Get the message from notification if available
            let message = notification.userInfo?["message"] as? String ?? "Your session has expired. Please login again."
            
            // Show alert on current screen
            self.showSessionExpiredAlert(message: message)
        }
    }
    
    @objc private func handleLogout() {
        print("🔄 User logged out, redirecting to login...")
        clearUserData()
        showAuthentication(animated: true)
    }
    
    private func clearUserData() {
        // Clear token from NetworkManager
        NetworkManager.shared.authToken = nil
        
        // Clear token from UserDefaults
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "currentUser")
        UserDefaults.standard.synchronize()
        
        // Clear any cookies
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
    }
    
    private func showSessionExpiredAlert(message: String) {
        // Get the topmost view controller
        guard let topViewController = getTopViewController() else {
            // If we can't get top VC, just redirect
            showAuthentication(animated: true)
            return
        }
        
        // Show alert
        let alert = UIAlertController(
            title: "Session Expired",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.showAuthentication(animated: true)
        })
        
        topViewController.present(alert, animated: true)
    }
    
    private func getTopViewController() -> UIViewController? {
        guard let rootVC = window?.rootViewController else { return nil }
        
        var topVC = rootVC
        while let presentedVC = topVC.presentedViewController {
            topVC = presentedVC
        }
        
        // If it's a navigation controller, get the top VC
        if let navController = topVC as? UINavigationController {
            return navController.topViewController ?? navController
        }
        
        // If it's a tab bar controller, get the selected VC
        if let tabBarController = topVC as? UITabBarController {
            return tabBarController.selectedViewController ?? tabBarController
        }
        
        return topVC
    }
    
    // MARK: - App Lifecycle
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Optional: Check token validity when app comes to foreground
        checkTokenValidityOnForeground()
    }
    
    private func checkTokenValidityOnForeground() {
        guard NetworkManager.shared.authToken != nil else {
            // No token, already at login or need to go to login
            return
        }
        
        // Optional: Validate token with a quick API call
        // This prevents users from staying logged in with expired tokens
        NetworkManager.shared.validateToken { [weak self] isValid in
            if !isValid {
                print("❌ Token invalid when app entered foreground")
                DispatchQueue.main.async {
                    self?.showSessionExpiredAlert(message: "Please login again to continue.")
                }
            }
        }
    }
    
    // MARK: - Navigation Methods
    
    func showAuthentication(animated: Bool = true) {
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        
        changeRootViewController(to: navController, animated: animated)
    }
    
    func showMainApp(animated: Bool = true) {
        let tabBarController = UITabBarController()
        
        // Create view controllers for each tab
        let homeVC = HomeViewController()
        let createSetVC = CreateSetViewController()
        let libraryVC = LibraryViewController()
        let accountVC = AccountViewController()
        
        // Configure tab bar items
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        createSetVC.tabBarItem = UITabBarItem(title: "Create", image: UIImage(systemName: "plus.circle"), tag: 1)
        libraryVC.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "books.vertical"), tag: 2)
        accountVC.tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person"), tag: 3)
        
        tabBarController.tabBar.tintColor = .darkGray
        tabBarController.tabBar.unselectedItemTintColor = .lightGray
        
        // Set up tab bar controller
        tabBarController.viewControllers = [homeVC, createSetVC, libraryVC, accountVC]
        tabBarController.selectedIndex = 0
        
        changeRootViewController(to: tabBarController, animated: animated)
    }
    
    // MARK: - Smooth Transition Method
    
    private func changeRootViewController(to newRootViewController: UIViewController, animated: Bool = true) {
        guard let window = self.window else { return }
        
        if animated {
            // Fade animation (cross dissolve)
            UIView.transition(with: window,
                            duration: 0.3,
                            options: .transitionCrossDissolve,
                            animations: {
                window.rootViewController = newRootViewController
            })
        } else {
            // No animation (for initial app launch)
            window.rootViewController = newRootViewController
        }
    }
    
    // method to clear auth state (for logout)
    func logoutUser() {
        print("✅ User logging out...")
        clearUserData()
        showAuthentication(animated: true)
    }
    
    // MARK: - Cleanup
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
