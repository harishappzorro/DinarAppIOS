//
//  StoreCategoryContentViewController.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 28/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class StoreCategoryContentViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableVw:UITableView!
    @IBOutlet weak var bannerContainerView: JTSBannerContainerView!
    var delegate:StoreViewController!
    var pageIndex:Int!
    var data:[[String:Any]]!
    var banners:[[String:Any]]!
    var storeId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableVw.register(UINib.init(nibName: "FeaturedStoreTableViewCell-Small", bundle: nil), forCellReuseIdentifier: "FeaturedStoreTableViewCell-Small")
        if(self.banners == nil || self.banners.count == 0){
            self.tableVw.tableHeaderView = nil
        }else{
            self.bannerContainerView.bindData(params: banners)
        }
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
    
    
    //MARK: - Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data == nil ? 0 : data.uniqueCategories().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (data == nil){
            return 0
        }else{
            let keys = data.uniqueCategories().sorted()
            var objectCount:Int!
            let key = keys[section]
            if(keys.count > 1){
                let objects = data.filter({ (item) -> Bool in
                    return (item["category"] as! String) == key
                })
                objectCount = objects.count
            }else{
                objectCount = data.count
            }
            return objectCount % 3 == 0 ? objectCount / 3 : Int(objectCount / 3) + 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 174.0 * SCREEN_WIDTH/375.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (data == nil || self.delegate.myRebates){
            return nil
        }else{
            let keys = data.uniqueCategories().sorted()
            return keys[section]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (data == nil || self.delegate.myRebates){
            return 0.0
        }else{
            return 40.0
        }
    }
//    if let formattedData = data as? [String:Any]{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FeaturedStoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FeaturedStoreTableViewCell-Small") as! FeaturedStoreTableViewCell
        cell.frame.size.width = SCREEN_WIDTH
        cell.delegate = self.delegate
        let keys = data.uniqueCategories().sorted()
        let key = keys[indexPath.section]
        let objects = data.filter({ (item) -> Bool in
            return (item["category"] as! String) == key
        })
        let object = ["id":self.storeId, "data":objects] as [String : Any]
        cell.myRebate = self.delegate.myRebates
//        logPrint(object)
        cell.bind(data: object)
        return cell
    }
    
}
