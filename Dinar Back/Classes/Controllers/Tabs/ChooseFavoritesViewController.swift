//
//  ChooseFavoritesViewController.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 29/08/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class ChooseFavoritesViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var nextButton: JTSFormButton!
    var stores:[[String:Any]]!
    var favorites:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favorites = []
        self.fetchAllStores()
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
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchAllStores(){

        self.showProgressView()
        RestAPI.shared.getAllStores(completionHandler: { (success, data, error) in
            
            DispatchQueue.main.async {
                self.hideProgressView()
                 if(success){
                    if data != nil{
                        self.stores = (data as? [[String:Any]])!
                        self.collectionVw.reloadData()
                    }
                }
            }
        })
    }
    
    //    MARK: - Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        let numberOfTotalObjects = self.stores.count
        return self.stores == nil ? 0 : self.stores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110.0*SCREEN_WIDTH/375.0, height: 126.0*SCREEN_WIDTH/375.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MyRebatesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyRebatesCollectionViewCell", for: indexPath) as! MyRebatesCollectionViewCell
        cell.bindData(params: self.stores[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        self.performSegue(withIdentifier: "showStore", sender: nil)
        if let id = self.stores[indexPath.row]["id"] as? String{
            var favorited:Bool = false
            if let index = favorites.index(of: id){
                favorites.remove(at: index)
            }else{
                favorited = true
                favorites.append(id)
            }
            if let cell = self.collectionVw.cellForItem(at: indexPath) as? MyRebatesCollectionViewCell{
                cell.markFavorite(favorite: favorited)
            }
            nextButton.enabled(enabled: favorites.count > 0)
        }
    }
    
    @IBAction func nextClicked(_ sender: JTSFormButton) {
        
        self.showProgressView()
        
        RestAPI.shared.addFavoriteStores(stores: favorites, completionHandler: { (success, data, error) in
            
            DispatchQueue.main.async {
                
                self.hideProgressView()
                if(success){
                    if data != nil{
                        appDelegate.userInfo["favourite_stores"] = data
                        logPrint(appDelegate.userInfo)
                        userDefaults.set(true, forKey: "favoritesAdded")
                        userDefaults.synchronize()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        })
    }
}
