//
//  JTSCollectionViewCell.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 12/09/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class JTSCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var logoContainer: UIView!
    @IBOutlet weak var logoImageView: AsyncImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var params:[String:Any]!
    public var isRoundedImageView:Bool = false
    
    func bindData(params:[String:Any]) {
        self.params = params
        if self.titleLabel != nil{
            if let name = params["name"] as? String{
                self.titleLabel.text = name
            }
        }
        if(self.logoImageView != nil){
            guard let url = URL(string: params["image_url"]! as! String) else {
                logPrint("Error#JTSCollectionViewCell: cannot create store image URL")
                return
            }
            self.logoImageView.imageURL = url
        }
        
        if(isRoundedImageView){
            logoImageView.backgroundColor = UIColor.white
            logoImageView.layer.cornerRadius = logoImageView.frame.width/2
            logoImageView.clipsToBounds = true
        }else{
            logoImageView.layer.cornerRadius = 0
        }
    }
}
