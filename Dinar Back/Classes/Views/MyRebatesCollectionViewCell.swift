//
//  MyRebatesCollectionViewCell.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 08/08/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class MyRebatesCollectionViewCell: JTSCollectionViewCell {
    
    @IBOutlet weak var favoritedView: UIView!
    @IBOutlet weak var rebatesCountLabel: UILabel!
    
    override func bindData(params:[String:Any]) {
        super.bindData(params: params)
        if(self.rebatesCountLabel != nil){
            if let arr = self.params["data"] as? [[String:Any]]{
                let count = arr.count
                self.rebatesCountLabel.text = String.init(format: count > 1 ?  "%i offers" : "%i offer", count)
            }
        }
    }
    
    func markFavorite(favorite:Bool){
        self.favoritedView.isHidden = !favorite
        self.setNeedsDisplay()
    }
}
