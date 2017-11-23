//
//  Font+Extension.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 28/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

extension UIFont{
    
    static let fontFamily:String = "AvenirNext"
    
    static func appFont(_ name: String, size: CGFloat) -> UIFont {
        return UIFont.init(name: name, size: size)!
    }
    
    static func appHeavyFont(_ size: CGFloat) -> UIFont{
        return UIFont.appFont(fontFamily.appending("-Heavy"), size: size)
    }
    
    static func appBoldFont(_ size: CGFloat) -> UIFont{
        return UIFont.appFont(fontFamily.appending("-Bold"), size: size)
    }
    
    static func appDemiBoldFont(_ size: CGFloat) -> UIFont{
        return UIFont.appFont(fontFamily.appending("-DemiBold"), size: size)
    }
   
    static func appMediumFont(_ size: CGFloat) -> UIFont{
        return UIFont.appFont(fontFamily.appending("-Medium"), size: size)
    }
    
    static func appRegularFont(_ size: CGFloat) -> UIFont{
        return UIFont.appFont(fontFamily.appending("-Regular"), size: size)
    }
    
    static func appUltraLightFont(_ size: CGFloat) -> UIFont{
        return UIFont.appFont(fontFamily.appending("-UltraLight"), size: size)
    }
    
}
