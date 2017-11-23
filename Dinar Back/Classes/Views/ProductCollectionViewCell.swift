//
//  ProductCollectionViewCell.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 27/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

protocol UpdateRebateHandlerDelegate: NSObjectProtocol {
    func updateRebate(cell:ProductCollectionViewCell)
}

class ProductCollectionViewCell: JTSCollectionViewCell {

    @IBOutlet weak var cashBackLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToMyRebateButton: UIButton!
    weak var delegate:UpdateRebateHandlerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addToMyRebates(_ sender: UIButton) {
        guard let method = self.delegate?.updateRebate else {
            logPrint("delegate doesn't implement updateRebate:")
            return
        }
        method(self)
    }
    
    override func bindData(params:[String:Any]) {
        super.bindData(params: params)
        if let rebate = params["rebate"] as? String{
            let rebateAmount = Float(rebate)
            self.cashBackLabel.text = String.init(format:"$%.1f cash back", rebateAmount!)
        }
        if let description = params["description"] as? String{
            self.descriptionLabel.text = description
        }
        if let addedForRebate = params["added_for_rebate"]{
            self.addToMyRebateButton.isSelected = Bool((addedForRebate as? String)!)!
        }else{
            self.addToMyRebateButton.isSelected = false
        }
    }
    
}
