//
//  BaseViewController.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 18/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UISearchBarDelegate {

    var loadingView: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        // Do any additional setup after loading the view.
        
        loadingView = UINib(nibName: "LoadingView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LoadingView
        loadingView.instanceFromNib()
        let frame = UIScreen.main.bounds
        loadingView.frame = frame
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    MARK: - Segue Handling
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination.isKind(of: StoreCategoryContentViewController.self)){
            let controller = segue.destination as! StoreCategoryContentViewController
            controller.hidesBottomBarWhenPushed = true
        }else if(segue.destination.isKind(of: StoreViewController.self)){
            let controller = segue.destination as! StoreViewController
            controller.storeId = sender as! String
        }
    }

    func showProgressView() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        window.addSubview(loadingView)
        window.bringSubview(toFront: loadingView)
        loadingView.loadingPlay()
        
    }
    
    func hideProgressView() {
        loadingView.loadingStop()
        loadingView.removeFromSuperview()
    }
    
    //    MARK: - Search Bar Delegate
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }

}
