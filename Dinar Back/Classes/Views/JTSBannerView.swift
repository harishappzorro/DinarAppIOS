//
//  JTSBannerView.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 27/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit
import AsyncImageView

class JTSBannerView: UIView {
    @IBOutlet weak var bannerView:AsyncImageView!
    var data:[String:Any]!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func bannerTapped(_ sender: UITapGestureRecognizer) {
        
    }
    
    func bindData(params:[String:Any]){
        self.data = params
        guard let url = URL(string: data["image_url"]! as! String) else {
            logPrint("Error#JTSCollectionViewCell: cannot create store image URL")
            return
        }
        self.bannerView.imageURL = url
    }

}
