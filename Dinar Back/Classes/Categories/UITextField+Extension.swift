//
//  UITextField+Extension.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 24/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

extension UITextField{
    
    func validateEmail() -> Bool{
        return String.isValidEmail(inString: self.text!)
    }
    
    func validatePassword() -> Bool{
        return String.isValidPassword(inString: self.text!)
    }
    
    func validatePhoneNumber() -> Bool {
        return String.isValidPhone(inString: self.text!)
    }
    
    func validateBlank() -> Bool {
        return !((self.text?.isEmpty)!)
    }
    
    func validateDob() -> Bool {
        return true//(self.text?.isEmpty)!
    }
    
    func validateZip() -> Bool {
        return true//(self.text?.isEmpty)!
    }
    
}
