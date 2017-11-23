//
//  SearchViewController.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 10/08/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, BarCodeResultDelegate {
    
    @IBOutlet var viewForSerchbar: UIView!
    @IBOutlet weak var tableVw: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noResultView: UIView!

    var searchResultData:[Any]? = []
    public var searchKey:String?
    public var filterKey:String! = ""
    static let SHOPS_SECTION_TITLE:String = "Stores"
    static let PRODUCTS_SECTION_TITLE:String = "Rebates"
    static let CATEGORIES_SECTION_TITLE:String = "Categories"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableVw.register(UINib.init(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultTableViewCell")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 100)) {
            let button:UIButton = UIButton.init(type: .custom)
            button.setImage(UIImage.init(named: "icnBarcodeGray"), for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: 40, height: self.viewForSerchbar.frame.size.height)
            self.viewForSerchbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.9, height: 60)
            button.addTarget(self, action: #selector(SearchViewController.barcodeSearchClicked), for: .touchUpInside)
            if let textField:UITextField = self.searchBar.textField(){
                textField.rightView = button
                textField.rightViewMode = .unlessEditing
                textField.borderStyle = .roundedRect
                textField.backgroundColor = UIColor.appGrayColor()
                textField.clearButtonMode = .whileEditing
                textField.font = UIFont.appMediumFont(14)
            }
        }
        showNoResultFoundView(show: false)
        self.tableVw.keyboardDismissMode = .onDrag
        
        if(searchKey != nil){
            searchForKeyword(keyword: searchKey!)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination.isKind(of: ProductViewController.self)){
            let controller = segue.destination as! ProductViewController
            controller.productId = sender as! String
        }else if(segue.destination.isKind(of: StoreViewController.self)){
            let controller = segue.destination as! StoreViewController
            controller.storeId = sender as! String
        }else if(segue.destination.isKind(of: CameraViewController.self)){
            let controller = segue.destination as! CameraViewController
            controller.delegate = self
        }else if(segue.destination.isKind(of: StoresForCategoryViewController.self)){
            let controller = segue.destination as! StoresForCategoryViewController
            controller.storeCategoryId = sender as! String
        }
    }
    
    func barcodeSearchClicked(_ sender:UIButton){
        self.performSegue(withIdentifier: "showBarCodeScanner", sender: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchResultData == nil ? 0 : (searchResultData?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = searchResultData![section] as! [String:Any]
        if let sectionData = sectionItem["section_data"] as? [[String:Any]]{
            return sectionData.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SearchResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! SearchResultTableViewCell
        
        let sectionItem = searchResultData![indexPath.section] as! [String:Any]
        //setup cell UI
        if let sectionName = sectionItem["section_name"] as? String{
            if(sectionName == SearchViewController.SHOPS_SECTION_TITLE){
                cell.updateUIForShopResult()
            }else if(sectionName == SearchViewController.PRODUCTS_SECTION_TITLE){
                cell.updateUIForItemResult()
            }else if(sectionName == SearchViewController.CATEGORIES_SECTION_TITLE){
                cell.updateUIForCategoryResult()
            }
        }
        
        //Bind cell data
        if let sectionData = sectionItem["section_data"] as? [[String:Any]]{
            let rowData = sectionData[indexPath.row]
            cell.bindData(rowData)
            
            if let sectionName = sectionItem["section_name"] as? String{
                if(sectionName == SearchViewController.SHOPS_SECTION_TITLE){
                    cell.btnFavShop.tag = indexPath.row
                    cell.btnFavShop.addTarget(self, action: #selector(self.shopFavButtonAction(_:)), for: .touchUpInside)
                    
                    if let id = rowData["id"] as? String{
                        cell.btnFavShop.isSelected = self.isShopFavorite(shopId: id)
                    }
                }else if(sectionName == SearchViewController.PRODUCTS_SECTION_TITLE){
                    cell.btnItemRebate.tag = indexPath.row
                    cell.btnItemRebate.addTarget(self, action: #selector(self.itemRebateButtonAction(_:)), for: .touchUpInside)
                    if let id = rowData["id"] as? String{
                        cell.btnItemRebate.isSelected = self.isProductAddedInRebate(productId: id)
                    }
                }
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionItem = searchResultData![section] as! [String:Any]
        if let sectionName = sectionItem["section_name"] as? String{
           return sectionName
        }
        
        return ""
    }
    
    
    //    MARK: - UITableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionItem = searchResultData![indexPath.section] as! [String:Any]
        if let sectionName = sectionItem["section_name"] as? String{
            if let sectionData = sectionItem["section_data"] as? [[String:Any]]{
                let rowData = sectionData[indexPath.row]
                if(sectionName == SearchViewController.SHOPS_SECTION_TITLE){
                    if let id = rowData["id"] as? String{
                        self.performSegue(withIdentifier: "showStore", sender: id)
                    }
                }else if(sectionName == SearchViewController.PRODUCTS_SECTION_TITLE){
                    if let id = rowData["id"] as? String{
                        self.performSegue(withIdentifier: "showProduct", sender: id)
                    }
                }else if(sectionName == SearchViewController.CATEGORIES_SECTION_TITLE){
                    if let id = rowData["id"] as? String{
                        self.performSegue(withIdentifier: "showStoresForCategory", sender: id)
                    }
                    
                }
            }
        }
    }
    
    
    //    MARK: - Search Bar Delegate
    
    override func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return super.searchBarShouldBeginEditing(searchBar)
    }
    
    override func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        super.searchBarTextDidEndEditing(searchBar)
        let keyword:String = searchBar.text!
        if keyword.count > 0{
            searchForKeyword(keyword: keyword)
        }
        searchBar.showsCancelButton = true
    }
    
    override func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
        super.searchBarCancelButtonClicked(searchBar)
    }

    // Mark :- Selector
    
    func searchForKeyword(keyword:String){

        self.showProgressView()
        RestAPI.shared.getSearchResult(searchKeyword: keyword, filter: self.filterKey, completionHandler: { (success, data, error) in
            self.searchResultData = []
            if let responseData = data as? [String:Any]{
                if let stores = responseData["stores"] as? [[String:Any]]{
                    if stores.count > 0{
                        let params = ["section_name":SearchViewController.SHOPS_SECTION_TITLE, "section_data":stores] as [String : Any]
                        self.searchResultData?.append(params)
                    }
                }
                
                if let products = responseData["products"] as? [[String:Any]]{
                    if products.count > 0{
                        let params = ["section_name":SearchViewController.PRODUCTS_SECTION_TITLE, "section_data":products] as [String : Any]
                        self.searchResultData?.append(params)
                    }
                }
                
                if let product_categories = responseData["product_categories"] as? [[String:Any]]{
                    if product_categories.count > 0{
                        let params = ["section_name":SearchViewController.CATEGORIES_SECTION_TITLE, "section_data":product_categories] as [String : Any]
                        self.searchResultData?.append(params)
                    }
                }
            }
            DispatchQueue.main.async {

                self.hideProgressView()
                if (self.searchResultData?.count)! > 0{
                    self.showNoResultFoundView(show: false)
                }else{
                    self.showNoResultFoundView(show: true)
                }
                self.tableVw.reloadData()
            }
        })
    }
    
    func showNoResultFoundView(show:Bool){
        var frame = self.tableVw.tableHeaderView?.frame
        frame?.size.height = show ? 240 : 0
        self.tableVw.tableHeaderView?.frame = frame!
        
        noResultView.isHidden = !show
    }
    
    func isProductAddedInRebate(productId:String)->Bool{
        if let arr = appDelegate.userInfo["applied_rebates"] as? [[String:Any]]{
            let filterArr = arr.filter({ (data) -> Bool in
                if let id = data["id"] as? String{
                    return id == productId
                }else{
                    return false
                }
            })
            if filterArr.count > 0{
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func isShopFavorite(shopId:String)->Bool{
        if let arr = appDelegate.userInfo["favourite_stores"] as? [[String:Any]]{
            let filterArr = arr.filter({ (data) -> Bool in
                if let id = data["id"] as? String{
                    return id == shopId
                }else{
                    return false
                }
            })
            if filterArr.count > 0{
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func itemRebateButtonAction(_ sender:UIButton){
        for item in searchResultData!{
            let sectionItem = item as! [String:Any]
            if let sectionName = sectionItem["section_name"] as? String{
                if(sectionName == SearchViewController.PRODUCTS_SECTION_TITLE){
                    if let sectionData = sectionItem["section_data"] as? [[String:Any]]{
                        let data = sectionData[sender.tag]
                        if let productId = data["id"] as? String{
                            if let storeId = data["id_shop"] as? String{
                                
                                self.showProgressView()
                                if(self.isProductAddedInRebate(productId: productId)){
                                    RestAPI.shared.removeRebate(storeId:storeId, productId:productId, completionHandler: { (success, data, error) in
                                        DispatchQueue.main.async {
                                            self.hideProgressView()
                                            if(success){
                                                if data != nil{
                                                    appDelegate.userInfo["applied_rebates"] = data
                                                    logPrint(appDelegate.userInfo)
                                                     self.tableVw.reloadData()
                                                }
                                            }
                                        }
                                    })
                                }else{
                                    RestAPI.shared.saveRebate(storeId:storeId, productId:productId, completionHandler: { (success, data, error) in

                                        DispatchQueue.main.async {
                                            self.hideProgressView()
                                            if(success){
                                                if data != nil{
                                                    appDelegate.userInfo["applied_rebates"] = data
                                                    logPrint(appDelegate.userInfo)
                                                    
                                                        self.tableVw.reloadData()
                                                }
                                            }
                                        }
                                    })
                                }
                                
                            }
                        }
                        break
                    }
                }
            }
        }
    }
    
    func shopFavButtonAction(_ sender:UIButton){
        for item in searchResultData!{
            let sectionItem = item as! [String:Any]
            if let sectionName = sectionItem["section_name"] as? String{
                if(sectionName == SearchViewController.SHOPS_SECTION_TITLE){
                    if let sectionData = sectionItem["section_data"] as? [[String:Any]]{
                        let data = sectionData[sender.tag]
                        if let id = data["id"] as? String{

                            self.showProgressView()
                            if(self.isShopFavorite(shopId: id)){
                                RestAPI.shared.removeFavoriteStores(stores: [id], completionHandler: { (success, data, error) in
                                    DispatchQueue.main.async {
                                        self.hideProgressView()
                                        if(success){
                                            if data != nil{
                                                appDelegate.userInfo["favourite_stores"] = data
                                                logPrint(appDelegate.userInfo)
                                                
                                                self.tableVw.reloadData()
                                            }
                                        }
                                    }
                                })
                            }else{
                                RestAPI.shared.addFavoriteStores(stores: [id], completionHandler: { (success, data, error) in
                                     DispatchQueue.main.async {
                                        self.hideProgressView()
                                        if(success){
                                            if data != nil{
                                                appDelegate.userInfo["favourite_stores"] = data
                                                logPrint(appDelegate.userInfo)
                                               
                                                self.tableVw.reloadData()
                                            }
                                        }
                                    }
                                })
                            }
                        }
                        break
                    }
                }
            }
        }
    }
    
    // Mark :- Barcode delegate
    
    func captureBarCodeResult(barCodeString: String) {
        self.perform(#selector(searchForKeyword(keyword:)), with: barCodeString, afterDelay: 0.5)
    }
    
}
