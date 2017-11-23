//
//  CategorySelectButton.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 28/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class CategorySelectButton: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionLabel: UILabel!
    
    func changeState(_ select: Bool){
        selectionLabel.isHidden = !select
        titleLabel.alpha = select ? 1.0 : 0.8
        titleLabel.font = select ? UIFont.appDemiBoldFont(14.0) : UIFont.appMediumFont(14.0)
    }
    
}
