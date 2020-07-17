//
//  Extensions.swift
//  Actio
//
//  Created by Arun Eswaramurthi on 07/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

extension UIApplication {
    func keyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
             return UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
        }
        else {
            return self.keyWindow
        }
    }
}

extension UIWindow {
    func topViewController() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        
        return nil
    }
}

extension String {
    var toDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter.date(from: self)
    }
}

extension Date {
    var ddMMyyyy: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter.string(from: self)
    }
}

extension UIViewController {
    func presentAlert(withTitle title: String, message : String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension CGFloat {
    static let kExternalPadding: CGFloat = 20
    static let kTableCellPadding: CGFloat = 15
    static let kInternalPadding: CGFloat = 10
}

extension NSLayoutAnchor {
    @objc func constraint(equalTo anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat = 0, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        
        return constraint
    }
}

extension UIEdgeInsets {
    var horizontal: CGFloat { return right + left }
    var vertical: CGFloat { return top + bottom }
}

extension CGSize {
    func paddedBy(_ insets: UIEdgeInsets) -> CGSize {
        return CGSize(width: width + insets.horizontal, height: height + insets.vertical)
    }
    
    var roundedUp: CGSize {
        return CGSize(width: ceil(width), height: ceil(height))
    }
}
