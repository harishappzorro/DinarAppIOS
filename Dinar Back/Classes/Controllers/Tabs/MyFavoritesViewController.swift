//
//  MyFavoritesViewController.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 11/08/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class MyFavoritesViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableVw: UITableView!
    var favorites:[[String:Any]]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableVw.isEditing = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let favoriteStores = appDelegate.userInfo["favourite_stores"] as? [[String:Any]]{
            self.favorites = favoriteStores
            self.tableVw.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination.isKind(of: UINavigationController.self)){
            let navigationController = segue.destination as! UINavigationController
            if let controller = navigationController.viewControllers.first as? SearchViewController{
                controller.filterKey = "STORE"
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

//    MARK: -  Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favorites == nil ? 0 : self.favorites!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:JTSStoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! JTSStoreTableViewCell
        let favoriteItem = self.favorites![indexPath.row]
        
        debugPrint(favoriteItem)
        cell.bindData(params: favoriteItem)
        if let category = favoriteItem["category"] as? String{
            cell.newRebatesLabel.text = category
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    //    MARK: -  Table View Delegates
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.favorites?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            appDelegate.userInfo["favourite_stores"] = self.favorites!
        }
    }
    
    
    // Mark:- IBActions
    
    @IBAction func addStoresButtonAction(_ sender:UIBarButtonItem){
        self.performSegue(withIdentifier: "showSearch", sender: self)
    }
    
    @IBAction func dismissView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
