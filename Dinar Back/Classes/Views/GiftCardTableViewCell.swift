//
//  GiftCardTableViewCell.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 10/08/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class GiftCardTableViewCell: UITableViewCell , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionVw:UICollectionView!
    
    var data:[[String:Any]]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        logPrint("Number Of Itmes: \(numberOfTotalItems)")
        self.collectionVw.register(UINib.init(nibName: "GiftCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GiftCardCollectionViewCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // MARK: -
    
    func bind(params:[[String:Any]]){
        self.data = params
        self.collectionVw.reloadData()
    }
    
    
    // MARK: Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.data == nil ? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let count:Double = Double(Double(numberOfTotalItems)/3.0)
//        let number = section <= Int(count)-1 ? 3 : Int(numberOfTotalItems - Int(count)*3)
        return self.data.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 117.0*SCREEN_WIDTH/375.0, height: 128.0*SCREEN_WIDTH/375.0)
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:GiftCardCollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCardCollectionViewCell", for: indexPath) as! GiftCardCollectionViewCell)
        cell.bindData(params: self.data[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: GiftCardTappedNotificationName, object: collectionView.cellForItem(at: indexPath))
    }

}
