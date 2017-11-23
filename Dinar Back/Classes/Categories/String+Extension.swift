//
//  String+Extension.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 24/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import Foundation
import UIKit
import Security

extension String{
    
    static func isValidEmail(inString:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: inString)
    }
    
    static func isValidPhone(inString: String) -> Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: inString, options: [], range: NSMakeRange(0, inString.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == inString.characters.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    static func isValidPassword(inString: String) -> Bool {
        return !inString.isEmpty && inString.characters.count >= 6
    }
}

extension String{
    
    func width(_ font:UIFont) -> CGFloat {
        return ceil(((self as NSString).size(attributes: [NSFontAttributeName: font])).width)
    }
    
    func height(_ font:UIFont, for width:CGFloat) -> CGFloat {
        let attributes : [String : Any] = [NSFontAttributeName : font]
        let attributedString : NSAttributedString = NSAttributedString(string: self, attributes: attributes)
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize:CGRect = rect
        return ceil(requredSize.height)
    }
    
}

extension String{
    func encrypt() -> String{
        return self
    }
    
    func decrypt() -> String{
        return self
    }
}

extension String{
}
