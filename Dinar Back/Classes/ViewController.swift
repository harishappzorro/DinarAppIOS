//
//  ViewController.swift
//  TestButtonInTabBar
//
//  Created by Wirawit Rueopas on 2/27/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
    
    let button = UIButton.init(type: .custom)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let image = UIImage(named: "redeemNavIcon") as UIImage?
        button.setImage(image, for: .normal)
       // button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 50, 0)
       button.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
       // button.setTitle("redeem", for: .normal)
        
       // button.contentVerticalAlignment = .bottom
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.yellow, for: .highlighted)
        //button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50);
        
        button.backgroundColor = .orange
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.yellow.cgColor
        self.view.insertSubview(button, aboveSubview: self.tabBar)
    }
    override func viewWillAppear(_ animated: Bool) {
        let image = UIImage(named: "redeemNavIcon") as UIImage?
        button.setImage(image, for: .normal)
        // button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 50, 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
        // button.setTitle("redeem", for: .normal)
        
        // button.contentVerticalAlignment = .bottom
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.yellow, for: .highlighted)
        //button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50);
        
        button.backgroundColor = .orange
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.yellow.cgColor
        self.view.insertSubview(button, aboveSubview: self.tabBar)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // safe place to set the frame of button manually
        button.frame = CGRect.init(x: self.tabBar.center.x - 30, y: self.view.bounds.height - 85, width: 60, height: 60)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

