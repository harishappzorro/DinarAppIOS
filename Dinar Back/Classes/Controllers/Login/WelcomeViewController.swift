//
//  WelcomeViewController.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 18/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import AVKit
import AVFoundation


class WelcomeViewController: BaseViewController{

    @IBOutlet var introVideoView: UIView!
    var player: AVPlayer!
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForegroundNotification),
                                               name: .UIApplicationWillEnterForeground, object: nil)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func appWillEnterForegroundNotification() {
        
        player?.play()
        
    }
    
    private func playVideo() {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch { }
        
        let bundle = Bundle.main
        let moviePath: String? = bundle.path(forResource: "Dinar_Back_Intro", ofType: "mp4")
        let movieURL = URL(fileURLWithPath: moviePath!)
        
        player = AVPlayer(url: movieURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.introVideoView.bounds
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        self.introVideoView.layer.addSublayer(playerLayer)
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {
                self.player.seek(to: kCMTimeZero)
                self.player.play()
            }
        })
        
        player.seek(to: kCMTimeZero)
        player.play()
    }
    
    
    func loginWithFacebook(_ accessToken:AccessToken, fbDetails: NSDictionary){

        self.showProgressView()
        
        DispatchQueue.main.async {
            
            RestAPI.shared.facebookLogin(accessToken: accessToken.authenticationToken, fbDetails:fbDetails) { (success, data, error) in
                
                self.hideProgressView()
                if(success){
                    if(data != nil){
                        AppDelegate.loginSuccessful(data)
                    }
                }
            }
        }
        
    }

    @IBAction func fbLoginClicked(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn([.email, .publicProfile], viewController: self) { (result) in
            switch result {
            case .cancelled:
                break
            case .failed(let error):
                logPrint(error)
                appDelegate.showAlert(message: error.localizedDescription)
                break
            case .success(grantedPermissions: let grantedPermission, declinedPermissions: let declinedPermission, token: let accessToken):
                
                logPrint(grantedPermission)
                logPrint(declinedPermission)
                logPrint(accessToken)
                
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id,email, name, first_name, last_name, age_range, link, gender, locale, timezone, updated_time, verified, picture.width(480).height(480), relationship_status"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        let fbDetails = result as! NSDictionary
                        print(fbDetails)
                        DispatchQueue.main.async {
                            self.loginWithFacebook(accessToken,fbDetails: fbDetails)
                        }
                    }
                })
                
                break
            }
        }
        
        
    }
    
    
    
   
    
}

