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
        
        window?.makeKeyAndVisible()
    }
    
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
        // Clear token from NetworkManager
        NetworkManager.shared.authToken = nil
        
        // Clear token from UserDefaults
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "currentUser")
        UserDefaults.standard.synchronize()
        
        // Clear any cookies
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        print("✅ User logged out, showing authentication screen")
        showAuthentication(animated: true)
    }
}
