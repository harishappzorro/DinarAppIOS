//
//  GiftCardCollectionViewCell.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 10/08/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class GiftCardCollectionViewCell: JTSCollectionViewCell {
    
    @IBOutlet weak var cashBackLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func bindData(params:[String:Any]) {
        super.bindData(params: params)
    }
    
}
