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
	
	public var visibleViewController: UIViewController? {
		return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
	}
	
	public static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
		if let nc = vc as? UINavigationController {
			return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
		} else if let tc = vc as? UITabBarController {
			return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
		} else {
			if let pvc = vc?.presentedViewController {
				return UIWindow.getVisibleViewControllerFrom(pvc)
			} else {
				return vc
			}
		}
	}
}

extension RangeExpression where Bound == String.Index  {
    func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}

extension String {
	var htmlToAttributedString: NSAttributedString? {
		guard let data = data(using: .utf8) else { return nil }
		do {
			return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
		} catch {
			return nil
		}
	}
	
	var htmlToString: String {
		return htmlToAttributedString?.string ?? ""
	}
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
	
	func chatTime() -> String {
		let feedDateFormatter = DateFormatter()
		feedDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		if let createdDate = feedDateFormatter.date(from: self) {
			if (Calendar.current.isDateInToday(createdDate)) {
				let timeDiff = abs(createdDate.timeIntervalSince(Date()))
				return timeDiff.displayString + " ago"
			} else if (Calendar.current.isDateInYesterday(createdDate)) {
				return "yesterday"
			} else {
				let simpleDateFormatter = DateFormatter()
				simpleDateFormatter.dateFormat = "dd MMM yyyy"
				
				return simpleDateFormatter.string(from: createdDate)
			}
		} else {
			return self
		}
	}
}

extension Date {
    var ddMMyyyy: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter.string(from: self)
    }
	
	func age() -> Int {
		return Calendar.current.component(.year, from: Date()) -  Calendar.current.component(.year, from: self)
	}
	
	var uniqueId: Int {
		return Int(self.timeIntervalSince1970)
	}
	
	func dateFormatWithSuffix() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM dd"
		
		return dateFormatter.string(from: self) + self.daySuffix()
	}
	
	func daySuffix() -> String {
		let components = Calendar.current.component(.day, from: self)
		switch components {
		case 1, 21, 31:
			return "st"
		case 2, 22:
			return "nd"
		case 3, 23:
			return "rd"
		default:
			return "th"
		}
	}
	
	func justTime() -> String {
		let justTimeFormatter = DateFormatter()
		justTimeFormatter.dateFormat = "HH:mm"
		
		return justTimeFormatter.string(from: self)
	}
	
	func splitDate() -> (String, String, String) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM"
		
		let month = dateFormatter.string(from: self)
		dateFormatter.dateFormat = "dd"
		
		let date = dateFormatter.string(from: self)
		dateFormatter.dateFormat = "yyyy"
		
		let year = dateFormatter.string(from: self)
		
		return (month, date, year)
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

extension UIView {
	func dropShadow(color: UIColor, opacity: Float = 0.16, offSet: CGSize, radius: CGFloat = 10.0, scale: Bool = true) {
		layer.masksToBounds = false
		layer.shadowColor = color.cgColor
		layer.shadowOpacity = opacity
		layer.shadowOffset = offSet
		layer.shadowRadius = radius
		
		layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
		layer.shouldRasterize = true
		layer.rasterizationScale = scale ? UIScreen.main.scale : 1
	}
}

extension UIImage {
	func alpha(_ value:CGFloat) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage!
	}
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
            value += "\(hour) h"
            
            if let minute = components.minute, minute > 0 {
                value += ", \(minute) m"
            }
        }
        else if let minute = components.minute, minute > 0 {
            value += "\(minute) m"
        }
        
        return value
    }
}
extension UITextField
{
    open override func draw(_ rect: CGRect) {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = AppColor.TextFieldBorderColor().cgColor
        self.layer.masksToBounds = true
    }
}
extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
}

enum DoubleType: Codable {
	
	case string(String)
	case double(Double)
	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		do {
			self = .double(try container.decode(Double.self))
		} catch DecodingError.typeMismatch {
			self = .string(try container.decode(String.self))
		}
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .string(let value):
			try container.encode(value)
		case .double(let value):
			try container.encode(value)
		}
	}
	
	var value: Double {
		switch self {
		case .string(let value):
			return Double(value) ?? 0
		case .double(let value):
			return value
		}
	}
}

enum IntType: Codable {
	
	case string(String)
	case int(Int)
	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		do {
			self = .int(try container.decode(Int.self))
		} catch DecodingError.typeMismatch {
			self = .string(try container.decode(String.self))
		}
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .string(let value):
			try container.encode(value)
		case .int(let value):
			try container.encode(value)
		}
	}
	
	var value: Int {
		switch self {
		case .string(let value):
			return Int(value) ?? 0
		case .int(let value):
			return value
		}
	}
}

class ChatTextAttachment: NSTextAttachment {
	override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
		let returnBounds = CGRect(x: 0, y: -3, width: 12, height: 12)
		return returnBounds
	}
}

extension UITableView {
	func setEmptyView(_ message: String? = nil, _ imageName: String? = nil) {
		let view: UIView = {
			let view = UIView()
			
			return view
		}()
		
		let label: UILabel = {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.text = message?.uppercased()
			label.textAlignment = .center
			label.font = AppFont.PoppinsRegular(size: 18)
			label.numberOfLines = 0
			
			view.addSubview(label)
			
			return label
		}()
		
		let imageView: UIImageView? = {
			guard let imageName = imageName, let image = UIImage(named: imageName) else {
				return nil
			}
			let imageView = UIImageView(image: image)
			imageView.contentMode = .scaleAspectFit
			imageView.translatesAutoresizingMaskIntoConstraints = false
			
			view.addSubview(imageView)
			
			return imageView
		}()
		
		var constraints = [
			imageView?.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			imageView?.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			imageView?.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			
			label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		]
		
		if let imageView = imageView {
			constraints += [
				imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 2.0/3.0),
				label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
			]
		} else {
			constraints += [
				label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
			]
		}
		
		NSLayoutConstraint.activate(constraints.compactMap({ $0 }))
		
		self.backgroundView = view
	}
}
