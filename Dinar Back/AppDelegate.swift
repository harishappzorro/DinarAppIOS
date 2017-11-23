//
//  AppDelegate.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 18/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit
import CoreData
import FacebookCore
import FacebookLogin
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    
    var window: UIWindow?
    
    weak var tabBarController: UITabBarController!
    weak var tabBarView: JTSTabBarView!
    var userInfo:[String:Any]!
    
    //    MARK: - App Delegate
  
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        application.registerForRemoteNotifications()
        
        self.customizeAppAppearance()
        
        
        return SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
       
        
        
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool{
        return SDKApplicationDelegate.shared.application(application, open: url, options: [.sourceApplication : sourceApplication ?? "", .annotation : annotation])
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Dinar_Back")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    // MARK: - Tab Bar Controller Delegate
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.tabBarView.selectTab(index: (tabBarController.viewControllers?.index(of: viewController))!)
    }
    
    
    //    MARK: - Static Methods
    
    static func loginSuccessful(_ object:Any?){
        UIStoryboard.load(name: "Main")
        appDelegate.userInfo = (object as? [String:Any])!
        appDelegate.addCustomTabView()
        AppDelegate.updateUserSessionData(appDelegate.userInfo)
    }
    
    static func updateUserSessionData(_ userData:[String:Any]){
        let userdefault = UserDefaults.standard
        if let access_token = userData["access_token"] as? String{
            userdefault.set(access_token, forKey: UserAccessToken)
        }
        if let refresh_token = userData["refresh_token"] as? String{
            userdefault.set(refresh_token, forKey: UserRefreshToken)
        }
        if let access_token_expiration_date = userData["access_token_expiration_date"] as? String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let expireDate = dateFormatter.date(from: access_token_expiration_date)
            userdefault.set(expireDate, forKey: UserAccessTokenExpireDate)
        }
        userdefault.synchronize()
    }
    
    static func logoutSuccessful(_ object:Any?){
        appDelegate.tabBarView.removeFromSuperview()
        UIStoryboard.load(name: "Login")
        appDelegate.userInfo = nil
        let userdefault = UserDefaults.standard
        userdefault.removeObject(forKey: UserAccessToken)
        userdefault.removeObject(forKey: UserRefreshToken)
        userdefault.removeObject(forKey: UserAccessTokenExpireDate)
        userdefault.synchronize()
    }
    
    
    //    MARK: -
    
    func addCustomTabView(){
        DispatchQueue.main.async {
            if (self.window?.rootViewController?.isKind(of: UITabBarController.self))!{
                self.tabBarController = self.window?.rootViewController as! UITabBarController
                let view:JTSTabBarView = Bundle.main.loadNibNamed("JTSTabBarView", owner: self.tabBarController, options: nil)?[0] as! JTSTabBarView
                self.tabBarView = view
                view.frame = self.tabBarController.tabBar.bounds
                self.tabBarController.tabBar.addSubview(view)
                self.tabBarController.tabBar.selectionIndicatorImage = nil
                self.tabBarController.tabBar.sendSubview(toBack: view)
                self.tabBarController.delegate = self
                self.tabBarView.selectTab(index: 0)
            }
        }
    }
    
    func customizeAppAppearance(){
        UINavigationBar.appearance().setBackgroundImage(_ : UIImage.init(), for : .default)
        UINavigationBar.appearance().shadowImage = UIImage.init()
        UINavigationBar.appearance().tintColor = UIColor.appGreenColor()
        UISearchBar.appearance().backgroundImage = UIImage.init()
        UIButton.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleColor(UIColor.appGreenColor(), for: .normal)
        UISearchBar.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = UIColor.appGreenColor()
        // For changing search bar icon
        UISearchBar.appearance().setImage(UIImage(named: "iconSearch9A"), for: UISearchBarIcon.search, state: UIControlState .normal)
    }
    
    
    //    MARK: - Utils
    
    func showAlert(message: String){
        let alertController = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "OK", style: .cancel, handler: { (action) in
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let welcomViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            let navigation = UINavigationController(rootViewController: welcomViewController)
            self.window?.rootViewController = navigation
            
        })
        alertController.addAction(alertAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    internal func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        print("Device token: \(deviceTokenString)")
        
    }
    
    
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        print(userInfo)
    }
}

