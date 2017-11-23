//
//  StoreViewController.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 27/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class StoreViewController: BaseViewController, UIScrollViewDelegate, FeaturedStoreTableViewCellDelegate {
    
    @IBOutlet weak var categoryScrollViewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var titleBarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryScrollView: CategorySelectButtonContainer!
    @IBOutlet weak var contentScrollView: StoreCategoryContentContainer!
    
    //    weak var pageViewController:UIPageViewController!
    var storeId:String!
    var data:[String:Any]!
    var uniqueCategories:[String]!
    var products:[[String:Any]]!
    var banners:[[String:Any]]!
    var controllers:[StoreCategoryContentViewController]!
    var myRebates:Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.data = ["Zoro":[9] , "Wines" : [6], "Kitchen Appliances" : [8], "Bar" : [4], "Clothes" : [5], "Beverages" : [13], "Long Cat" : [5]]
        if(myRebates == true){
            logPrint(self.products)
            let categories = self.products.uniqueCategories()
            self.uniqueCategories = categories.sorted()
            if(categories.count > 1){
                self.initializeProductCategorySelector()
            }else{
                self.categoryScrollViewContainerHeight.constant = 18.0
            }
            self.initializeStore()
        }else{
            self.getStoreData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(StoreViewController.showProduct), name: ProductTappedNotificationName, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    MARK: - Notification Handlers
    
    func showProduct(nc:Notification){
        self.performSegue(withIdentifier: "showProduct", sender: nc.object)
    }
    
    
    //    MARK: - Segue Handling
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if(segue.destination.isKind(of: ProductViewController.self)){
            let controller = segue.destination as! ProductViewController
            controller.productId = sender as! String
        }
    }
    
    
    //    MARK: -
    
    func getStoreData() {

        self.showProgressView()
        RestAPI.shared.getStoreProducts(storeId: storeId) { (success, data, error) in
            if(success){
                DispatchQueue.main.async {

                    self.hideProgressView()
                    if data != nil{
                        self.data = data as! [String : Any]
                        self.products = (self.data["products"] as? [[String:Any]])!
                        self.banners = (self.data["banners"] as? [[String:Any]])!
                        let categories = self.products.uniqueCategories()
                        self.uniqueCategories = categories.sorted()
                        self.initializeProductCategorySelector()
                        self.initializeStore()
                    }
                }
            }
        }
    }
    
    func initializeProductCategorySelector(){
        var x:CGFloat = 0
        let y:CGFloat = 0
        var height = self.categoryScrollView.bounds.size.height
        height = height * SCREEN_WIDTH/375.0
        var width:CGFloat!
        self.categoryScrollView.translatesAutoresizingMaskIntoConstraints = true
        self.categoryScrollView.frame.size = CGSize(width: SCREEN_WIDTH, height: height)
        categoryScrollView.categoryButtons = Array()
        for subViews in categoryScrollView.subviews{
            subViews.removeFromSuperview()
        }
        //For category All
        let key = "All"
        width = key.width(UIFont.appHeavyFont(17.0))
        if(width < 50){
            width = 50
        }
        var view:CategorySelectButton = Bundle.main.loadNibNamed("CategorySelectButton", owner: self, options: nil)?[0] as! CategorySelectButton
        view.frame = CGRect(x: x, y: y, width: width, height: height)
        var tap = UITapGestureRecognizer.init(target: self, action: #selector(StoreViewController.categorySelected))
        view.addGestureRecognizer(tap)
        view.titleLabel.text = key
        categoryScrollView.addSubview(view)
        categoryScrollView.categoryButtons.append(view)
        x += width
        
        for key in uniqueCategories{
            width = key.width(UIFont.appHeavyFont(17.0))
            if(width < 70){
                width = 70
            }
            view = Bundle.main.loadNibNamed("CategorySelectButton", owner: self, options: nil)?[0] as! CategorySelectButton
            view.frame = CGRect(x: x, y: y, width: width, height: height)
            tap = UITapGestureRecognizer.init(target: self, action: #selector(StoreViewController.categorySelected))
            view.addGestureRecognizer(tap)
            view.titleLabel.text = key
            categoryScrollView.addSubview(view)
            categoryScrollView.categoryButtons.append(view)
            x += width
        }
        categoryScrollView.selectedIndex = 0
        categoryScrollView.contentSize = CGSize(width: x, height: height)
    }
    
    func initializeStore(){
        controllers = Array()
        for subViews in contentScrollView.subviews{
            subViews.removeFromSuperview()
        }
        var x:CGFloat = 0
        let y:CGFloat = 0
        let height = self.contentScrollView.bounds.size.height
        let width:CGFloat! = contentScrollView.bounds.size.width
        //loading controller for all
        var index:Int = 0
        var controller = self.storyboard?.instantiateViewController(withIdentifier: "StoreCategoryContentViewController") as! StoreCategoryContentViewController
        controller.delegate = self
        controller.view.frame = CGRect(x: x, y: y, width: width, height: height)
        controller.pageIndex = index
        controller.storeId = self.storeId
        controller.data = products
        controller.banners = banners
        contentScrollView.addSubview(controller.view)
        controllers.append(controller)
        x += SCREEN_WIDTH
        index = index + 1
        
        for key in uniqueCategories{
            controller = self.storyboard?.instantiateViewController(withIdentifier: "StoreCategoryContentViewController") as! StoreCategoryContentViewController
            controller.delegate = self
            controller.view.frame = CGRect(x: x, y: y, width: width, height: height)
            controller.pageIndex = index
            controller.storeId = self.storeId
            let data = products.filter({ (item) -> Bool in
                return (item["category"] as! String) == key
            })
            logPrint(data)
            controller.data = data
            if (self.banners != nil){
                let bannerData = banners.filter({ (item) -> Bool in
                    if(item["category"] != nil){
                        return (item["category"] as! String) == key
                    }else{
                        return true
                    }
                })
                logPrint(bannerData)
                controller.banners = bannerData
            }
            
            contentScrollView.addSubview(controller.view)
            controllers.append(controller)
            x += SCREEN_WIDTH
            index = index + 1
        }
        if(uniqueCategories.count > 1){
            contentScrollView.contentSize = CGSize(width: SCREEN_WIDTH * CGFloat(uniqueCategories.count + 1), height: height*SCREEN_WIDTH/375.0)
        }else{
            contentScrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: height*SCREEN_WIDTH/375.0)
        }
    }
    
    func categorySelected(gesture: UITapGestureRecognizer){
        let categoryButton = (gesture.view as? CategorySelectButton)!
        if(categoryScrollView.selectedIndex == categoryScrollView.categoryButtons.index(of: categoryButton)){
            return
        }
        categoryScrollView.highlightCategory(button: categoryButton)
        contentScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * CGFloat(categoryScrollView.selectedIndex), y: 0), animated: true)
    }
    
    //    MARK: -  Scroll View Delegates
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView == contentScrollView){
            let offset = scrollView.contentOffset
            let index = Int((offset.x)/SCREEN_WIDTH)
            if(categoryScrollView.selectedIndex != index){
                categoryScrollView.selectedIndex = index
            }
        }
    }
    
    func updateData(cell:FeaturedStoreTableViewCell){
        self.getStoreData()
    }
}
