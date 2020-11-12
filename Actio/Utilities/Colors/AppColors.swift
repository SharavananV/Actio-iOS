//
//  AppColors.swift
//  Actio
//
//  Created by senthil on 06/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

extension UIColor {
    static let themeOrange: UIColor = {
        return UIColor(hex: "#FF5733") ?? UIColor.orange
    }()
    
    static let themePurple: UIColor = {
        return UIColor(hex: "#511845") ?? UIColor.purple
    }()
    
    static let themeRed: UIColor = {
        return UIColor(hex: "#C70039") ?? UIColor.red
    }()
    
    static let themeOrangeHalfAlpha: UIColor = {
        return UIColor(hex: "#FF573355") ?? UIColor.orange
    }()
    
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}



class AppColor: UIColor {
    class func OrangeColor() -> UIColor {
        
        return self.HexToColor(hexString: "#FF5733")
    }
    class func PurpleColor() -> UIColor {
        
        return self.HexToColor(hexString: "#511845")
    }
    class func GreyColor() -> UIColor {
        
        return self.HexToColor(hexString: "#505050")
    }
    class func ButtonGreyColor() -> UIColor {
        
        return self.HexToColor(hexString: "#E8E7E7")
    }
    class func RedColor() -> UIColor {
        
        return self.HexToColor(hexString: "#C70039")
    }
    class func iconPurpleColor() -> UIColor {
        
        return self.HexToColor(hexString: "#900C3F")
    }

    class func TextFieldBorderColor() -> UIColor {
        
        return self.HexToColor(hexString: "#fedcd7")
    }
    class func ViewBackgroundColor() -> UIColor {
        
        return self.HexToColor(hexString: "##FCF0EA")
    }
    class func FavViewBackgroundColor() -> UIColor {
        
        return self.HexToColor(hexString: "#F2F2F2")
    }
    class func HexToColor(hexString: String) -> UIColor
    {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        return color
    }
    
    class func intFromHexString(hexStr: String) -> UInt32{
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}
//Gradient Color

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }
    
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
	
	@discardableResult
	func applyGradientFromTop(colours: [UIColor]) -> CAGradientLayer {
		let gradient: CAGradientLayer = CAGradientLayer()
		gradient.frame = self.bounds
		gradient.colors = colours.map { $0.cgColor }
		gradient.startPoint = CGPoint(x: 0.5, y: 0)
		gradient.endPoint = CGPoint(x: 0.5, y: 1)
		self.layer.insertSublayer(gradient, at: 0)
		return gradient
	}
}
extension UIViewController {
    func changeNavigationBar() {
//        navigationController?.navigationBar.applyGradient(colours: [AppColor.RedColor(),AppColor.OrangeColor()], locations:[ 0,1])
    }
}
// Textfield BorderColor
extension UITextField{
    func setBorderColor(width:CGFloat,color:UIColor) -> Void{
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
}





