//
//  JTSStoreTableViewCell.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 19/09/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class JTSStoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageVw:AsyncImageView!
    @IBOutlet weak var textLbl:UILabel!
    @IBOutlet weak var rebatesLabel:UILabel!
    @IBOutlet weak var newRebatesLabel:UILabel!
    
    var data:[String:Any]!
    
    func bindData(params:[String:Any]){
        self.data = params
        self.textLbl.text = params["name"] as? String
        if(self.newRebatesLabel != nil){
            if(params["new_rebate_count"] != nil){
                let count = (params["new_rebate_count"] as? NSNumber)!
                if count as! Int > 0{
                    self.newRebatesLabel.text = String.init(format: "%@ new", count)
                }else{
                    self.newRebatesLabel.text = nil
                }
            }else{
                self.newRebatesLabel.text = nil
            }
        }
        if(self.rebatesLabel != nil){
            if(params["rebate_count"] != nil){
                let rebateCount = (params["rebate_count"] as? NSNumber)!
                self.rebatesLabel.text = String.init(format: rebateCount.intValue > 1 ? "%@ offers" : "%@ offer", rebateCount)
            }else{
                self.rebatesLabel.text = nil
            }
        }
        guard let url = URL(string: params["image_url"]! as! String) else {
            logPrint("Error#StoreCategoryTableViewCell: cannot create store image URL")
            return
        }
        self.imageVw.imageURL = url
    }
    
}
