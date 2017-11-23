//
//  UIApplication+Extension.swift
//  Dinar Back
//
//  Created by bo on 11/2/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import Foundation

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
