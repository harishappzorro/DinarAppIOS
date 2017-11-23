//
//  ProductViewController.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 27/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class ProductViewController: BaseViewController {
    
    @IBOutlet weak var scrollVw:UIScrollView!
    @IBOutlet weak var bannerContainerView: JTSBannerContainerView!
    @IBOutlet weak var cashBackLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var addToMyRebateButton: UIButton!
    @IBOutlet weak var rebatePropertiesIconContainer: UIView!
    @IBOutlet weak var expiringSoonDateLabel: UILabel!
    @IBOutlet weak var eligibilityIcon: UILabel!
    @IBOutlet weak var bonusIcon: UIImageView!
    @IBOutlet weak var expiringSoonIcon: UIImageView!
    @IBOutlet weak var quantityIcon: UIImageView!
    @IBOutlet weak var productDetailsLabel: UILabel!
    
    @IBOutlet weak var productImageRatioConstraint: NSLayoutConstraint!
    @IBOutlet weak var productNameLabelTop: NSLayoutConstraint!
    @IBOutlet weak var productNameLabelHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var productDescriptionLabelHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var rebatePropertiesIconContainerTop: NSLayoutConstraint!
    @IBOutlet weak var rebatePropertiesIconContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var rebatePropertiesIconContainerBottom: NSLayoutConstraint!
    @IBOutlet weak var eligibilityIconContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var bonusIconWidth: NSLayoutConstraint!
    @IBOutlet weak var expiringSoonIconWidth: NSLayoutConstraint!
    @IBOutlet weak var quantityIconWidth: NSLayoutConstraint!
    @IBOutlet weak var topContainerHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var gapBetweenContainers:NSLayoutConstraint!
    
    @IBOutlet weak var rebatePropertiesTextContainerTop: NSLayoutConstraint!
    @IBOutlet weak var rebatePropertiesTextContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var eligibilityTextContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var quantityTextContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var bonusTextContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var expiringTextContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var productDetailsLabelTop: NSLayoutConstraint!
    @IBOutlet weak var productDetailsLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var productDetailsLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var bottomContainerHeightConstraint:NSLayoutConstraint!
    
    var productId:String!
    var data:[String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eligibilityTextContainerHeight.constant = 0
        self.eligibilityIconContainerWidth.constant = 0
        self.bonusTextContainerHeight.constant = 0
        self.bonusIconWidth.constant = 0
        self.rebatePropertiesIconContainerHeight.constant = 0
        self.expiringTextContainerHeight.constant = 0
        
        self.productNameLabelHeightConstraint.constant = (self.productNameLabel.text?.height(self.productNameLabel.font, for: self.productNameLabel.frame.size.width))!
        self.productDescriptionLabelHeightConstraint.constant = (self.productDescriptionLabel.text?.height(self.productDescriptionLabel.font, for: self.productDescriptionLabel.frame.size.width))!
        self.productDetailsLabelHeight.constant = (self.productDetailsLabel.text?.height(self.productDetailsLabel.font, for: self.productDetailsLabel.frame.size.width))!
        self.layoutView()
        self.getProductDetails()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func layoutView() {
        
        let productImageHeight = SCREEN_WIDTH/self.productImageRatioConstraint.multiplier
        
        self.topContainerHeightConstraint.constant = productImageHeight + self.productNameLabelTop.constant + self.productNameLabelHeightConstraint.constant + self.productDescriptionLabelHeightConstraint.constant + self.rebatePropertiesTextContainerTop.constant + self.rebatePropertiesIconContainerHeight.constant + self.rebatePropertiesIconContainerBottom.constant
        
        self.rebatePropertiesTextContainerHeight.constant = self.eligibilityTextContainerHeight.constant + self.quantityTextContainerHeight.constant + self.bonusTextContainerHeight.constant + self.expiringTextContainerHeight.constant
        
        self.bottomContainerHeightConstraint.constant = self.rebatePropertiesTextContainerTop.constant + self.rebatePropertiesTextContainerHeight.constant + self.productDetailsLabelTop.constant + self.productDetailsLabelHeight.constant + self.productDetailsLabelBottom.constant
        //        self.view.layoutIfNeeded()
        DispatchQueue.main.async {
            self.scrollVw.contentSize = CGSize(width: SCREEN_WIDTH, height: (self.topContainerHeightConstraint.constant + self.bottomContainerHeightConstraint.constant + self.gapBetweenContainers.constant))
        }
    }
    
    func getProductDetails() {

        self.showProgressView()
        RestAPI.shared.getProductDetails(productId: self.productId) { (success, data, error) in

            DispatchQueue.main.async {
                self.hideProgressView()
                if (success){
                    if (data != nil){
                        logPrint(data)
                              if let dataObject = data as? [String:Any]{
                                self.populateProductsData(dataObject)
                            }
                        }
                    }
            }
        }
    }
    
    func populateProductsData(_ params: [String:Any]){
        self.data = params
        if let name = params["name"] as? String{
            self.productNameLabel.text = name
        }else{
            self.productNameLabel.text = ""
        }
        
        if let rebate = params["rebate"] as? String{
            let rebateAmount = Float(rebate)
            self.cashBackLabel.text = String.init(format:"$%.1f cash back", rebateAmount!)
        }
        
        if let description = params["description"] as? String{
            self.productDescriptionLabel.text = description
        }
        
        if let addedForRebate = params["added_for_rebate"] as? String{
            self.addToMyRebateButton.isSelected = Bool(addedForRebate)!
            self.addToMyRebateButton.layer.borderWidth = self.addToMyRebateButton.isSelected ? 0.0 : 2.0
        }else{
            self.addToMyRebateButton.isSelected = false
            self.addToMyRebateButton.layer.borderWidth = 1.0
        }
        
        if let imageUrl = params["image_url"] as? String{
            self.bannerContainerView.bindData(params: [["image_url" : imageUrl]])
        }
    }
    
    @IBAction func checkProductBarCode(_ sender: UIButton) {
        
    }
}
