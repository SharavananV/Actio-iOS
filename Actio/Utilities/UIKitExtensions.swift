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

extension RangeExpression where Bound == String.Index  {
    func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}

extension String {
    var toDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter.date(from: self)
    }
    
    func nsRange<S: StringProtocol>(of string: S, options: String.CompareOptions = [], range: Range<Index>? = nil, locale: Locale? = nil) -> NSRange? {
           self.range(of: string,
                      options: options,
                      range: range ?? startIndex..<endIndex,
                      locale: locale ?? .current)?
               .nsRange(in: self)
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
    
    @objc func constraint(lessThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat = 0, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = self.constraint(lessThanOrEqualTo: anchor, constant: constant)
        constraint.priority = priority
        
        return constraint
    }
}

extension UIEdgeInsets {
    var horizontal: CGFloat { return right + left }
    var vertical: CGFloat { return top + bottom }
}

extension UILabel {
    func textHeight(withWidth width: CGFloat) -> CGFloat {
        guard let text = text else {
            return 0
        }
        return text.height(withWidth: width, font: font)
    }
}

extension String {
    func height(withWidth width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font: font], context: nil)
        return actualSize.height
    }
}

extension CGSize {
    func paddedBy(_ insets: UIEdgeInsets) -> CGSize {
        return CGSize(width: width + insets.horizontal, height: height + insets.vertical)
    }
    
    var roundedUp: CGSize {
        return CGSize(width: ceil(width), height: ceil(height))
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension TimeInterval {
    func components() -> DateComponents {
        let sysCalendar = Calendar.current
        let date1 = Date()
        let date2 = Date(timeInterval: self, since: date1)
        
        return sysCalendar.dateComponents([.hour, .minute], from: date1, to: date2)
    }
    
    var displayString: String {
        let components = self.components()
        
        var value = ""
        if let hour = components.hour, hour > 0 {
            value += components.hour == 1 ? "\(hour) hour" : "\(hour) hours"
            
            if let minute = components.minute, minute > 0 {
                value += " and \(minute) minutes"
            }
        }
        else if let minute = components.minute, minute > 0 {
            value += "\(minute) minutes"
        }
        
        return value
    }
}
