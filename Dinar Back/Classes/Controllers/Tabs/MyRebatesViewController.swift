//
//  MyRebatesViewController.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 27/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class MyRebatesViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionContainerView: UIView!
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var noRebatesMessageView: UIView!
    @IBOutlet weak var noRebatesMessageLabel: UILabel!
    
    var data:[[String:Any]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchMyRebates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateMessageLabelText(){
        let attachment = NSTextAttachment.init()
        attachment.image = UIImage(named: "btnPlusFlamingoLarge")
        attachment.bounds = CGRect(origin: CGPoint(x:0, y: -3), size: CGSize(width: 15.0, height: 15.0))
        let string = NSMutableAttributedString(string: "You haven't selected any offers.\nTap ")
        string.append(NSAttributedString(attachment: attachment))
        string.append(NSAttributedString(string:" on any offer to add it to this list."))
        string.addAttribute(NSFontAttributeName, value: UIFont.appMediumFont(14.0), range: NSRange.init(location: 0, length: string.length - 1))
        string.addAttribute(NSForegroundColorAttributeName, value: UIColor.appGreenColor(), range: NSRange.init(location: 0, length: string.length - 1))
        noRebatesMessageLabel.attributedText = string
    }
    
    func fetchMyRebates(){

        self.showProgressView()
        RestAPI.shared.getMyRebates { (success, data, error) in
            DispatchQueue.main.async {
            self.hideProgressView()
                if (success){
                    if data != nil{
                        
                        if let object = data as? [[String:Any]]{
                            self.data = object
                            let hasRebates:Bool = object.count > 0
                            self.noRebatesMessageView.isHidden = hasRebates
                            self.collectionContainerView.isHidden = !hasRebates
                            if(hasRebates){
                                self.collectionVw.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    //    MARK: - Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.data == nil){
            return 0
        }else{
            return self.data.count
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 110.0*SCREEN_WIDTH/375.0, height: 126.0*SCREEN_WIDTH/375.0)
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MyRebatesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyRebatesCollectionViewCell", for: indexPath) as! MyRebatesCollectionViewCell
        cell.bindData(params: self.data[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showStore", sender: self.data[indexPath.row]["data"])
    }
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination.isKind(of: StoreViewController.self)){
            let controller = segue.destination as! StoreViewController
            controller.products = sender as! [[String:Any]]
            controller.myRebates = true
        }
     }
    
    @IBAction func ellipsisClicked(_ sender: UIBarButtonItem) {
        self.noRebatesMessageView.isHidden = !self.noRebatesMessageView.isHidden
        self.collectionContainerView.isHidden = !self.collectionContainerView.isHidden
    }
    
}
