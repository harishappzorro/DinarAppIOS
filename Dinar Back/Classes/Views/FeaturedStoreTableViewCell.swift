//
//  FeaturedStoreTableViewCell.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 27/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit
//import ProductCollectionViewCell
protocol FeaturedStoreTableViewCellDelegate:NSObjectProtocol{
    func updateData(cell:FeaturedStoreTableViewCell)
}

class FeaturedStoreTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UpdateRebateHandlerDelegate {
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeIconImageView: AsyncImageView!
    @IBOutlet weak var collectionVw:UICollectionView!
    @IBOutlet weak var viewAllButton:UIButton!
    weak var delegate:FeaturedStoreTableViewCellDelegate?
    var params:[String:Any]!
    var myRebate:Bool! = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionVw.register(UINib.init(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // MARK: -
    
    func bind(data:[String:Any]){
        logPrint(data)
        self.params = data
        if(self.storeNameLabel != nil){
            if let name = data["name"] as? String{
                self.storeNameLabel.text = name
                if(self.viewAllButton != nil){
                    self.viewAllButton.setTitle(String.init(format: "View All %@", name), for: .normal)
                }
            }
        }
        if(self.storeIconImageView != nil){
            guard let url = URL(string: data["image_url"]! as! String) else {
                logPrint("Error#JTSCollectionViewCell: cannot create store image URL")
                return
            }
            self.storeIconImageView.imageURL = url
        }
        self.collectionVw.reloadData()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func showMoreStore(sender: Any?){
        NotificationCenter.default.post(name: ShowStoreContentsNotificationName, object: self)
    }
    
    @IBAction func ellipsesClicked(_ sender: UIButton) {
        NotificationCenter.default.post(name: ShowStoreOptionNotificationName, object: self)
    }
    // MARK: Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if(self.params == nil){
            return 0
        }
        if let arr = params["data"] as? [[String:Any]]{
            let numberOfTotalItems = arr.count
            let count:Double = Double(Double(numberOfTotalItems)/3.0)
            return count == floor(count) ? Int(count) : Int(floor(count)) + 1
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let arr = params["data"] as? [[String:Any]]{
            let numberOfTotalItems = arr.count
            let count:Double = Double(Double(numberOfTotalItems)/3.0)
            let number = section <= Int(count)-1 ? 3 : Int(numberOfTotalItems - Int(count)*3)
            return number
        }else{
            return 0
        }
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 117.0*SCREEN_WIDTH/375.0, height: 156.0*SCREEN_WIDTH/375.0)
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ProductCollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell)
        cell.delegate = self
        cell.addToMyRebateButton.isHidden = self.myRebate
        if let arr = params["data"] as? [[String:Any]]{
            cell.bindData(params: arr[indexPath.section*3 + indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ProductCollectionViewCell{
            NotificationCenter.default.post(name: ProductTappedNotificationName, object: cell.params["id"])
        }
    }
    
    
    //    MARK: - UpdateRebateHandlerDelegate
    
    func updateRebate(cell: ProductCollectionViewCell) {
        let btn:UIButton = cell.addToMyRebateButton
        let shouldAdd = !btn.isSelected
        logPrint(self.params)
        let storeId:String = (self.params["id"] as? String)!
        let productId:String = (cell.params["id"] as? String)!
        
//        SVProgressHUD.show()
//        PKGIFHUD.setGifWithImageName("Loading.gif")
//        PKGIFHUD.showWithOverlay()
        if(shouldAdd){
            RestAPI.shared.saveRebate(storeId: storeId, productId: productId, completionHandler: { (success, data, error) in
                //                SVProgressHUD.dismiss()
                if(success){
                    DispatchQueue.main.async {
                        if data != nil{
                            appDelegate.userInfo["applied_rebates"] = data
                            guard let method = self.delegate?.updateData else {
                                logPrint("delegate doesn't implement updateRebate:")
                                return
                            }
                            method(self)
                        }else{
                            
                            
//                            SVProgressHUD.dismiss()
//                            PKGIFHUD.dismiss()
                        }
                    }
                }
            })
        }else{
            RestAPI.shared.removeRebate(storeId: storeId, productId: productId, completionHandler: { (success, data, error) in
//                SVProgressHUD.dismiss()
//                PKGIFHUD.dismiss()
                if(success){
                    DispatchQueue.main.async {
                        if data != nil{
                            appDelegate.userInfo["applied_rebates"] = data
                            guard let method = self.delegate?.updateData else {
                                logPrint("delegate doesn't implement updateRebate:")
                                return
                            }
                            method(self)
                        }else{
//                            SVProgressHUD.dismiss()
//                            PKGIFHUD.dismiss()
                        }
                    }
                }
            })
        }
    }
    
}
