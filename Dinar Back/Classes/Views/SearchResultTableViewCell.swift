//
//  SearchResultTableViewCell.swift
//  Dinar Back
//
//  Created by Macbook01 on 06/10/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var imgViewItem: AsyncImageView!
    @IBOutlet weak var lblShopTitle: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductCategory: UILabel!
    @IBOutlet weak var btnFavShop: UIButton!
    @IBOutlet weak var btnItemRebate: UIButton!
    @IBOutlet weak var lblCashBack: UILabel!
    @IBOutlet weak var lblShopTitle2: UILabel!
    
    var cellType = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func updateUIForShopResult(){
        cellType = 0
        lblShopTitle.isHidden = false
        lblProductName.isHidden = true
        lblProductCategory.isHidden = true
        btnFavShop.isHidden = false
        btnItemRebate.isHidden = true
        lblCashBack.isHidden = true
        lblShopTitle2.isHidden = true
    }
    
    public func updateUIForItemResult(){
        cellType = 1
        lblShopTitle.isHidden = true
        lblProductName.isHidden = false
        lblProductCategory.isHidden = true
        btnFavShop.isHidden = true
        btnItemRebate.isHidden = false
        lblCashBack.isHidden = false
        lblShopTitle2.isHidden = false
    }
    
    public func updateUIForCategoryResult(){
        cellType = 2
        lblShopTitle.isHidden = false
        lblProductName.isHidden = true
        lblProductCategory.isHidden = true
        btnFavShop.isHidden = true
        btnItemRebate.isHidden = true
        lblCashBack.isHidden = true
        lblShopTitle2.isHidden = true
    }
    
    public func bindData(_ params:[String:Any]){
        imgViewItem.imageURL = URL.init(string: (params["image_url"] as? String) ?? "")
        switch cellType {
        case 0:
            lblShopTitle.text = params["name"] as? String
            break
        case 1:
            lblProductName.text = params["name"] as? String
            lblProductCategory.text = params["category"] as? String
            break
        case 2:
            lblShopTitle.text = params["name"] as? String
            break
        default:
            break
        }
    }
    
}
