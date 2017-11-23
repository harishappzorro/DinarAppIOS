//
//  FindRebatesViewController.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 27/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class FindRebatesViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, BarCodeResultDelegate {
    
    
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet var myFavoritesTableHeaderView: UIView!
    @IBOutlet var noFavoritesTableHeaderView: UIView!
    @IBOutlet weak var noFavoritesMessageLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableVw: UITableView!
    @IBOutlet weak var searchBarContainer: UIView!
    
    var favorites:[[String:Any]]!
    var categories:[[String:Any]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableVw.register(UINib.init(nibName: "StoreCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "StoreCategoryTableViewCell")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 100)) {
            let button:UIButton = UIButton.init(type: .custom)
            let image = UIImage.init(named: "icnBarcodeGray")
            button.setImage(image, for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            //        button.imageEdgeInsets = UIEdgeInsetsMake(-16, 0, 0, 0)
            //        button.backgroundColor = UIColor.black
            button.addTarget(self, action: #selector(FindRebatesViewController.barcodeSearchClicked), for: .touchUpInside)
            if let textField:UITextField = self.searchBar.textField(){
                textField.rightView = button
                textField.rightViewMode = .unlessEditing
                textField.borderStyle = .roundedRect
                textField.backgroundColor = UIColor.appGrayColor()
                textField.clearButtonMode = .whileEditing
                textField.font = UIFont(name: "Avenir Next", size: 14)
                textField.font = UIFont.appMediumFont(14)
            }
        }
        self.tableVw.keyboardDismissMode = .onDrag
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateTableHeader()
        if(self.categories == nil){
            self.fetchCategories()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if(segue.destination.isKind(of: StoresForCategoryViewController.self)){
            let controller = segue.destination as! StoresForCategoryViewController
            controller.storeCategoryId = sender as! String
        }else if(segue.destination.isKind(of: UINavigationController.self)){
            let navigationController = segue.destination as! UINavigationController
            if let controller = navigationController.viewControllers.first as? SearchViewController{
                controller.searchKey = sender as? String
            }
        }else if(segue.destination.isKind(of: CameraViewController.self)){
            let controller = segue.destination as! CameraViewController
            controller.delegate = self
        }
    }
    
    //    MARK: -
    
    func updateNoFavoritesLabel(){
        let attachment = NSTextAttachment.init()
        attachment.image = UIImage(named: "icnStarUnfilledTeal")
        attachment.bounds = CGRect(origin: CGPoint(x:0, y: -3), size: CGSize(width: 15.0, height: 15.0))
        let string = NSMutableAttributedString(string: "You don't have any favourites.\nTap ")
        string.append(NSAttributedString(attachment: attachment))
        string.append(NSAttributedString(string:" to add stores to your favorites."))
        string.addAttribute(NSFontAttributeName, value: UIFont.appMediumFont(14.0), range: NSRange.init(location: 0, length: string.length - 1))
        string.addAttribute(NSForegroundColorAttributeName, value: UIColor.appGreenColor(), range: NSRange.init(location: 0, length: string.length - 1))
        noFavoritesMessageLabel.attributedText = string
    }
    
    func updateTableHeader(){
        if let favoriteStores = appDelegate.userInfo["favourite_stores"] as? [[String:Any]]{
            self.favorites = favoriteStores
            if(self.favorites.count > 0){
                self.tableVw.tableHeaderView = myFavoritesTableHeaderView
                self.collectionVw.reloadData()
            }else{
                self.tableVw.tableHeaderView = noFavoritesTableHeaderView
                self.updateNoFavoritesLabel()
            }
        }else{
            self.tableVw.tableHeaderView = noFavoritesTableHeaderView
            self.updateNoFavoritesLabel()
        }
    }
    
    func fetchCategories(){
        
        self.showProgressView()
        RestAPI.shared.getCategories(completionHandler: { (success, data, error) in
            
            DispatchQueue.main.async {
                self.hideProgressView()
                if(success){
                    if data != nil{
                        self.categories = (data as? [[String:Any]])!
                        
                        self.tableVw.reloadData()
                    }
                }
            }
        })
    }
    
    func barcodeSearchClicked(_ sender:UIButton){
        self.performSegue(withIdentifier: "showBarCodeScanner", sender: nil)
    }
    
    func searchForKeyword(keyword:String){
        searchBar.text = nil
        self.performSegue(withIdentifier: "showSearch", sender: keyword)
    }
    
    func captureBarCodeResult(barCodeString: String) {
        self.searchForKeyword(keyword: barCodeString)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //    MARK: - Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.favorites == nil ? 0 : self.favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:StoreCircularIconCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCircularIconCollectionViewCell", for: indexPath) as! StoreCircularIconCollectionViewCell
        cell.isRoundedImageView = true
        cell.bindData(params: self.favorites[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.favorites[indexPath.row]
        self.performSegue(withIdentifier: "showStore", sender: data["id"])
    }
    
    
    //    MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "BROWSE BY CATEGORY"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width:
            tableView.bounds.size.width, height: 30.0))
        
        
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 15, width:
            tableView.bounds.size.width, height: 30.0))
//        headerView.backgroundColor = UIColor(displayP3Red: 217/255.0, green: 226/255.0, blue: 209/255.0, alpha: 1)
        headerLabel.textColor = UIColor.titleGrayColor()
        headerLabel.font = UIFont.appBoldFont(15)
        headerLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories == nil ? 0 : self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:StoreCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StoreCategoryTableViewCell", for: indexPath) as! StoreCategoryTableViewCell
        cell.bindData(params: self.categories[indexPath.row])
        //        cell.textLabel!.text = categoryArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showStoresForCategory", sender: self.categories[indexPath.row]["id"])
    }
    
    
    //    MARK: - Search Bar Delegate
    
    override func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return super.searchBarShouldBeginEditing(searchBar)
    }
    
    override func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        super.searchBarTextDidEndEditing(searchBar)
        if(searchBar.text!.count > 0){
            self.searchForKeyword(keyword: searchBar.text!)
        }
//        RestAPI.share
    }
    
}
