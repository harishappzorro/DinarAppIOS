//
//  UISearchbar+Extension.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 09/08/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

extension UISearchBar{
    
    func textField() -> UITextField?{
        let container = self.subviews[0]
        for view in container.subviews{
            if view.isKind(of: UITextField.self){
                return view as? UITextField
            }
        }
        return nil
    }
    
}
