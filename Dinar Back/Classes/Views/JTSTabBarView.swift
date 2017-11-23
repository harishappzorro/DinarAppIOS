//
//  JTSTabBarView.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 27/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class JTSTabBarView: UIView {

    @IBOutlet var tabs: [JTSTabView]!
    
    func selectTab(index: Int) {
        for tab in tabs{
            tab.selected(select: tabs.index(of: tab) == index)
        }
    }
}
