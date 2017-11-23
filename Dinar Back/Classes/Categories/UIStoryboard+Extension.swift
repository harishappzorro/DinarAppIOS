//
//  UIStoryboard+Extension.swift
//  Parking App
//
//  Created by Madhup Yadav on 12/08/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static func load(name:String) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard.init(name: name, bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            let window:UIWindow = appDelegate.window!
            window.rootViewController = vc
            window.makeKeyAndVisible()
        }
    }
}
