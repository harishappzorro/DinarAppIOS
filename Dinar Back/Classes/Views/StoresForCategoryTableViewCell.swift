//
//  StoresForCategoryTableViewCell.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 19/09/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class StoresForCategoryTableViewCell: JTSStoreTableViewCell {
    
    @IBOutlet weak var categoryNameLabel:UILabel!
    @IBOutlet weak var categoryNameLabelHeightConstraint:NSLayoutConstraint!
    
    override func bindData(params:[String:Any]) {
        super.bindData(params: params)
        if(params["category"] != nil){
            self.categoryNameLabel.text = params["category"] as? String
        }
    }
    
}
