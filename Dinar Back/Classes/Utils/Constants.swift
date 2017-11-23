//
//  Constants.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 26/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit
import Foundation


//MARK: - Notifications

let FormValidityChangedNotificationName = NSNotification.Name(rawValue:"FormValidityChanged")
let ShowStoreContentsNotificationName = NSNotification.Name(rawValue:"ShowStoreContents")
let ProductTappedNotificationName = NSNotification.Name(rawValue:"ProductTapped")
let GiftCardTappedNotificationName = NSNotification.Name(rawValue:"GiftCardTapped")
let ShowStoreOptionNotificationName = NSNotification.Name(rawValue:"ShowStoreOptions")

//MARK: - Layout Constants

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height


//MARK: - Objects

let appDelegate = (UIApplication.shared.delegate as? AppDelegate)!
let userDefaults = UserDefaults.standard


//MARK: - User Default Keys

let favoritesAdded = "favoritesAdded"

let UserAccessToken = "useraccesstoken"
let UserRefreshToken = "userrefreshtoken"
let UserAccessTokenExpireDate = "useraccesstokenexpiredate"


//MARK: - Segue Identifiers

let showAllStoresSegue = "showAllStores"
