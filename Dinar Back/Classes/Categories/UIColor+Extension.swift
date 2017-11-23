//
//  UIColor+Extension.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 22/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

extension UIColor{
    
    static func appGreenColor() -> UIColor {
//        return UIColor(red: 176.0/255.0, green: 11.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        return UIColor(red: 38.0/255.0, green: 148.0/255.0, blue: 143/255.0, alpha: 1.0)
    }
    
    static func appGrayColor() -> UIColor {
        return UIColor(red: 236.0/255.0, green: 237.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
    
    static func buttonDisabledBackgroundColor() -> UIColor {
        return UIColor(red: 237.0/255.0, green: 240.0/255.0, blue: 245.0/255.0, alpha: 1.0)
    }
    
    static func buttonDisabledTitleColor() -> UIColor {
        return UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 207.0/255.0, alpha: 1.0)
    }
    
    static func buttonEnabledBackgroundColor() -> UIColor {
        return UIColor.appGreenColor()
    }
    
    static func buttonEnabledTitleColor() -> UIColor {
        return UIColor.white
    }
    
    static func titleGrayColor() -> UIColor {
        return UIColor(red: 148.0/255.0, green: 148.0/255.0, blue: 148.0/255.0, alpha: 1.0)
    }
    
    static func titleDarkGrayColor() -> UIColor {
        return UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    }
    
    static func cellTitleLabelGrayColor() -> UIColor {
        return UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    }
    
    static func titleRedColor() -> UIColor {
        return UIColor(red: 228.0/255.0, green: 84.0/255.0, blue: 97.0/255.0, alpha: 1.0)
    }
    
    static func separatorGrayColor() -> UIColor {
        return UIColor(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 0.35)
    }
    
    static func separatorRedColor() -> UIColor {
        return UIColor(red: 228.0/255.0, green: 84.0/255.0, blue: 97.0/255.0, alpha: 0.35)
    }
    
    static func separatorGreenColor() -> UIColor {
        return UIColor(red: 38.0/255.0, green: 148.0/255.0, blue: 143/255.0, alpha: 0.35)
    }
    
}
