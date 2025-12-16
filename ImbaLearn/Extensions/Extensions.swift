//
//  Untitled.swift
//  ImbaLearn
//
//  Created by Leyla Aliyeva on 19.11.25.
//

import UIKit

// MARK: - UIView Extension
extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

extension UITextField {
    func applyShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
    }
}

extension UIView {
    func applyShadowForView() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1

    }
}

extension UIViewController {
    func showAlert(title: String?, message: String?, handlers: [UIAlertAction]) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        handlers.forEach({ controller.addAction($0) })
        present(controller, animated: true)
    }
}

extension Notification.Name {
    static let userDidLogout = Notification.Name("userDidLogout")
    static let sessionExpired = Notification.Name("sessionExpired")
}
