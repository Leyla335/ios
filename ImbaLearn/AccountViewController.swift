//
//  AccountViewController.swift
//  ImbaLearn
//
//  Created by Leyla Aliyeva on 17.11.25.
//

import UIKit

class AccountViewController: BaseViewController {
    
    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var avatarContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var avatarCircle: UIView = {
        let view = UIView()
        view.backgroundColor = .color
        view.layer.cornerRadius = 40
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var avatarLabel: UILabel = {
        let label = UILabel()
        label.text = "L" // First letter of user's name
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userInfoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Leyla Aliyeva"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "leyla@example.com"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var nameSurnameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name Surname"
        label.textColor = .text
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameSurnameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your name and surname"
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.isEnabled = false
        textField.text = "Leyla Aliyeva" // Pre-filled with user data
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var emailFieldLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = .text
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your email"
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.isEnabled = false
        textField.text = "leyla@example.com" // Pre-filled with user data
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textColor = .text
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "••••••••"
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.isSecureTextEntry = true
        textField.isEnabled = false // Not editable directly
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Password", for: .normal)
        button.setTitleColor(.pinkButton, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(changePasswordTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.backgroundColor = .pinkButton
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete Account", for: .normal)
        button.setTitleColor(.pinkButton, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteAccountTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTextFields()
    }
    
    private func setupUI() {
        view.backgroundColor = .background
        title = "Account"
        
        // Add scroll view and content view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add avatar and user info
        avatarContainer.addSubview(avatarCircle)
        avatarCircle.addSubview(avatarLabel)
        
        userInfoStack.addArrangedSubview(nameLabel)
        userInfoStack.addArrangedSubview(emailLabel)
        
        // Add all elements to content view
        contentView.addSubviews(avatarContainer, userInfoStack, nameSurnameLabel, nameSurnameTextField, emailFieldLabel, emailTextField, passwordLabel, passwordTextField, changePasswordButton, logoutButton, deleteAccountButton)
    }
    
    private func setupTextFields() {
        // Set up text field delegates
        let textFields = [nameSurnameTextField, emailTextField]
        textFields.forEach { textField in
            textField.delegate = self
        }
        
        // Enable keyboard avoidance
        setupKeyboardAvoidance(with: scrollView)
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 20
        let fieldHeight: CGFloat = 50
        let labelHeight: CGFloat = 20
        
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Avatar Container
            avatarContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            avatarContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarContainer.widthAnchor.constraint(equalToConstant: 80),
            avatarContainer.heightAnchor.constraint(equalToConstant: 80),
            
            // Avatar Circle
            avatarCircle.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor),
            avatarCircle.centerYAnchor.constraint(equalTo: avatarContainer.centerYAnchor),
            avatarCircle.widthAnchor.constraint(equalToConstant: 80),
            avatarCircle.heightAnchor.constraint(equalToConstant: 80),
            
            // Avatar Label
            avatarLabel.centerXAnchor.constraint(equalTo: avatarCircle.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarCircle.centerYAnchor),
            
            // User Info Stack
            userInfoStack.leadingAnchor.constraint(equalTo: avatarContainer.trailingAnchor, constant: 16),
            userInfoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            userInfoStack.centerYAnchor.constraint(equalTo: avatarContainer.centerYAnchor),
            
            // Name Surname Label
            nameSurnameLabel.topAnchor.constraint(equalTo: avatarContainer.bottomAnchor, constant: 40),
            nameSurnameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameSurnameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            nameSurnameLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            // Name Surname Text Field
            nameSurnameTextField.topAnchor.constraint(equalTo: nameSurnameLabel.bottomAnchor, constant: 8),
            nameSurnameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameSurnameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            nameSurnameTextField.heightAnchor.constraint(equalToConstant: fieldHeight),
            
            // Email Field Label
            emailFieldLabel.topAnchor.constraint(equalTo: nameSurnameTextField.bottomAnchor, constant: 30),
            emailFieldLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            emailFieldLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            emailFieldLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            // Email Text Field
            emailTextField.topAnchor.constraint(equalTo: emailFieldLabel.bottomAnchor, constant: 8),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            emailTextField.heightAnchor.constraint(equalToConstant: fieldHeight),
            
            // Password Label
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            passwordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            passwordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            passwordLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            // Password Text Field - now full width again
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding), // Full width
            passwordTextField.heightAnchor.constraint(equalToConstant: fieldHeight),
            
            // Change Password Button - UNDERNEATH password field, aligned to right
            changePasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8), // Small gap underneath password field
            changePasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Logout Button - big button with frame, below change password
            logoutButton.topAnchor.constraint(equalTo: changePasswordButton.bottomAnchor, constant: 30), // More space after change password
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            logoutButton.heightAnchor.constraint(equalToConstant: 55),
            
            // Delete Account Button - without frame, underneath logout
            deleteAccountButton.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 20),
            deleteAccountButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            deleteAccountButton.heightAnchor.constraint(equalToConstant: 30),
            deleteAccountButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    // MARK: - Actions
    @objc private func changePasswordTapped() {
        // TODO: Implement change password logic
        print("Change password tapped")
        let changePasswordVC = ChangePasswordViewController()
        navigationController?.pushViewController(changePasswordVC, animated: true)
    }
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(title: "Logout",
                                    message: "Are you sure you want to logout?",
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        present(alert, animated: true)
    }
    
    @objc private func deleteAccountTapped() {
        let alert = UIAlertController(title: "Delete Account",
                                    message: "This action cannot be undone. All your data will be permanently deleted.",
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.performAccountDeletion()
        })
        present(alert, animated: true)
    }
    
    private func performLogout() {
        // TODO: Implement logout logic
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.showAuthentication()
        }
    }
    
    private func performAccountDeletion() {
        // TODO: Implement account deletion logic
        print("Account deletion requested")
        // After deletion, you might want to show authentication screen
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.showAuthentication()
        }
    }
}

// MARK: - ChangePasswordViewController (Placeholder)
class ChangePasswordViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        title = "Change Password"
        // Implement change password UI here
    }
}
