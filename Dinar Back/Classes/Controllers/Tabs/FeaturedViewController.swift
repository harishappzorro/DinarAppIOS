//
//  FeaturedViewController.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 27/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class FeaturedViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, FeaturedStoreTableViewCellDelegate {
    @IBOutlet var notigicationBarItem: UIBarButtonItem!
    
    @IBOutlet weak var topBannerView: JTSBannerContainerView!
    @IBOutlet weak var bottomBannerView: JTSBannerContainerView!
    @IBOutlet weak var tableVw:UITableView!
    var storesData:[[String:Any]]!
    var bannersData:[String:Any]!
    let button = UIButton.init(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableVw.register(UINib.init(nibName: "FeaturedStoreTableViewCell", bundle: nil), forCellReuseIdentifier: "FeaturedStoreTableViewCell")
        //        let rowCount =  Int(arc4random() % 10) + 1
        //        self.dataArray = Array()
        //        for _ in 0..<rowCount {
        //            dataArray.append(Int(arc4random() % 6) + 1)
        //        }
        
        // Do any additional setup after loading the view.
        notigicationBarItem.addBadge(number: 6)
        
      
    }
    
    
     
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tabBarController?.tabBar.isHidden = false;
        NotificationCenter.default.addObserver(self, selector: #selector(FeaturedViewController.showStore), name: ShowStoreContentsNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FeaturedViewController.showStoreOptions), name: ShowStoreOptionNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FeaturedViewController.showProduct), name: ProductTappedNotificationName, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        notigicationBarItem.removeBadge()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        if(!self.shouldAddFavorites() && self.storesData == nil){
            self.fetchFeaturedRebates()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    MARK: -
    
    func showAllStores(){
        self.performSegue(withIdentifier: showAllStoresSegue, sender: nil)
    }
    
    func shouldAddFavorites() -> Bool{
        if let arr = appDelegate.userInfo["favourite_stores"] as? [[String:Any]]{
            if (arr.count > 0){
            
                return false
            }else{
                if(userDefaults.bool(forKey: favoritesAdded)){
                    return false
                }else{
                    self.perform(#selector(showAllStores), with: nil, afterDelay: 0.5)
 //                   showAllStores()
                    
                    return true
                }
            }
        }else{
//            showAllStores()
            

            self.perform(#selector(showAllStores), with: nil, afterDelay: 0.5)
            return true
        }
    }
    
    func fetchFeaturedRebates(){

        self.showProgressView()
        
        RestAPI.shared.getFeatured(completionHandler:  { (success, data, error) in

            DispatchQueue.main.async {
                self.hideProgressView()
                
                if(success){
                    if data != nil{
                        if let resp = data as? [String:Any]{
                            DispatchQueue.main.async {
                                if let bannersData = resp["banners"] as? [String:Any]{
                                    self.bannersData = bannersData
                                    if let top = bannersData["top"] as? [[String:Any]]{
                                        self.topBannerView.bindData(params: top)
                                    }
                                    if let bottom = bannersData["bottom"] as? [[String:Any]]{
                                        self.bottomBannerView.bindData(params: bottom)
                                    }
                                }
                                //if let storesData = resp["featured_stores"] as? [[String:Any]]{
                                if let storesData = resp["featured_stores"] as? [[String:Any]]{
                                    self.storesData = storesData
                                }
                                self.tableVw.reloadData()
                            }
                        }
                    }
                }
            }
        })
    }
    
    
    //    MARK: - Notification Handlers
    
    func showStore(nc:Notification){
        if let cell = nc.object as? FeaturedStoreTableViewCell{
            self.performSegue(withIdentifier: "showStore", sender: cell.params["id"])
        }
    }
    
    func showStoreOptions(nc:Notification){
        if let cell = nc.object as? FeaturedStoreTableViewCell{
            let storeName = cell.params["name"] as! String
            let moreOptionStyleSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            let showShop = UIAlertAction.init(title: "View All " + storeName + " Offers", style:.default, handler: { (alert) in
                self.performSegue(withIdentifier: "showStore", sender: cell.params["id"])
            })
            
            let showFavShop = UIAlertAction.init(title: "Manage My Favorites", style:.default, handler: { (alert) in
                self.performSegue(withIdentifier: "showMyFavorites", sender: self)
            })
            
            let cancelAction = UIAlertAction.init(title: "Cancel", style:.cancel, handler: nil)
            
            moreOptionStyleSheet.addAction(showFavShop)
            moreOptionStyleSheet.addAction(showShop)
            moreOptionStyleSheet.addAction(cancelAction)
            
            self.present(moreOptionStyleSheet, animated: true)
        }
    }
    
    func showProduct(nc:Notification){
        let sender = nc.object
        self.performSegue(withIdentifier: "showProduct", sender: sender)
    }
    
    //    MARK: - Segue Handling
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if(segue.destination.isKind(of: ProductViewController.self)){
            let controller = segue.destination as! ProductViewController
            controller.productId = sender as! String
        }
    }
    
    
    // MARK: - Table View Data Source & Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(storesData)
        return storesData == nil ? 0 : storesData.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let obj = storesData[indexPath.row]["data"] as? [Any]{
            let count = obj.count
            let collectionViewHeight = (count <= 3 ? 165.0 : 335.0) * SCREEN_WIDTH/375.0
            return collectionViewHeight + 95.0
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FeaturedStoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FeaturedStoreTableViewCell") as! FeaturedStoreTableViewCell
        cell.delegate = self
        cell.bind(data: storesData[indexPath.row])
        return cell
    }
    
    
    //    FeaturedStoreTableViewCellDelegate
    
    func updateData(cell:FeaturedStoreTableViewCell){
        self.fetchFeaturedRebates()
    }
    
}

//harish
private var handle: UInt8 = 0

extension UIBarButtonItem {
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        badgeLayer?.removeFromSuperlayer()
        
        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(7)
        let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
        badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
        view.layer.addSublayer(badge)
        
        // Initialiaze Badge's label
        let label = CATextLayer()
        label.string = "\(number)"
        label.alignmentMode = kCAAlignmentCenter
        label.fontSize = 11
        label.frame = CGRect(origin: CGPoint(x: location.x - 4, y: offset.y), size: CGSize(width: 8, height: 16))
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
        
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func updateBadge(number: Int) {
        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }
    
    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
}
extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

