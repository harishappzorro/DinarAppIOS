//
//  LaunchViewController.swift
//  Dinar Back
//
//  Created by bo on 10/24/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var retryBtn: UIButton!
    @IBOutlet weak var failedToLoadLabel: UILabel!
    var animationView: LOTAnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        animationView = LOTAnimationView(name: "White_Dots")
        animationView.frame.size = CGSize(width: 50  , height: 50)
        animationView.frame.origin.x = self.view.frame.size.width/2 - animationView.frame.size.width/2
        animationView.frame.origin.y = self.view.frame.size.height/2 - animationView.frame.size.height/2
        
        self.view.addSubview(animationView)
        self.view.bringSubview(toFront: animationView)
        self.animationView.isHidden = true
        
        if RestAPI.shared.isInternetAvailable(){
            failedToLoadLabel.isHidden = true
            retryBtn.isHidden = true
            self.automaticLogin()
        }else{
            failedToLoadLabel.isHidden = false
            retryBtn.isHidden = false
        }
        
    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    func automaticLogin(){
        if let expireDate = UserDefaults.standard.object(forKey: UserAccessTokenExpireDate) as? Date{
            if expireDate.isExpire(){

                self.animationView.isHidden = false
                self.animationView.play()
                DispatchQueue.main.async {
                    RestAPI.shared.refreshAccessToken(completionHandler: { (success, data, error) in
                        if(success){
                            if(data != nil){
                                AppDelegate.updateUserSessionData(data as! [String : Any])
                                RestAPI.shared.getLoginData(completionHandler: { (success, data, error) in
                                    
                                    self.animationView.stop()
                                    self.animationView.removeFromSuperview()
                                    
                                    if(success){
                                        if(data != nil){
                                            AppDelegate.loginSuccessful(data)
                                        }
                                    }
                                })
                            }
                        }else{
                           
                            self.animationView.stop()
                            self.animationView.removeFromSuperview()
                        }
                    })
                }
                
            }else{
                self.animationView.isHidden = false
                self.animationView.play()
                
                
                DispatchQueue.main.async {
                    RestAPI.shared.getLoginData(completionHandler: { (success, data, error) in
                        
                        self.animationView.stop()
                        self.animationView.removeFromSuperview()
                        if(success){
                            if(data != nil){
                                AppDelegate.loginSuccessful(data)
                            }
                        }
                    })
                }
                
            }
        }else{
            let welcomViewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            let navVC = UINavigationController(rootViewController: welcomViewController)
            navVC.isNavigationBarHidden = true
            self.navigationController?.present(navVC, animated: true, completion: nil)
            
        }
    }
    

    @IBAction func retryClicked(_ sender: UIButton) {
        if RestAPI.shared.isInternetAvailable(){
            failedToLoadLabel.isHidden = true
            retryBtn.isHidden = true
            self.automaticLogin()
        }else{
            failedToLoadLabel.isHidden = false
            retryBtn.isHidden = false
        }
    }
   

}
