//
//  JTSFormButton.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 26/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class JTSFormButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        self.enabled(enabled: false)
    }
    
    func enabled(enabled:Bool){
        if(enabled == super.isEnabled){
            return
        }
        super.isEnabled = enabled
        self.backgroundColor = enabled ? UIColor.buttonEnabledBackgroundColor() : UIColor.buttonDisabledBackgroundColor()
        self.setTitleColor(enabled ? UIColor.buttonEnabledTitleColor() : UIColor.buttonDisabledTitleColor(), for: .normal)
    }

}
