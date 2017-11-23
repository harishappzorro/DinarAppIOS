//
//  StoresForCategoryViewController.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 19/09/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class StoresForCategoryViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableVw: UITableView!
    
    var storeCategoryId:String!
    var stores:[[String:Any]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableVw.register(UINib.init(nibName: "StoresForCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "StoresForCategoryTableViewCell")
        self.fetchStores()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
    }
    
//    MARK: -
    
    func fetchStores(){

        self.showProgressView()
        RestAPI.shared.getStoresForCategory(categoryId: self.storeCategoryId) { (success, data, error) in
            DispatchQueue.main.async {
                self.hideProgressView()
                if (success){
                    if data != nil{
                        self.stores = data as! [[String:Any]]
                        logPrint(self.stores)
                        
                            if(self.stores.count > 0){
                                self.title = self.stores[0]["category"] as? String
                                self.tableVw.reloadData()
                            }
                    }
                }
            }
        }
    }
    
    //    MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stores == nil ? 0 : self.stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:StoresForCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StoresForCategoryTableViewCell", for: indexPath) as! StoresForCategoryTableViewCell
        cell.bindData(params: self.stores[indexPath.row])
        //        cell.textLabel!.text = categoryArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showStore", sender: self.stores[indexPath.row]["id"])
    }

}
