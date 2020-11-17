//
//  AppFonts.swift
//  Actio
//
//  Created by senthil on 06/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class AppFont: UIFont {
    
    class func PoppinsRegular(size : CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: size)!
    }
    class func PoppinsBold(size : CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Bold", size: size)!
    }
    class func PoppinsMedium(size : CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: size)!
    }
    class func PoppinsSemiBold(size : CGFloat) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: size)!
    }
}
