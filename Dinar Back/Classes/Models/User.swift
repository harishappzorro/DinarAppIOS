//
//  User.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 25/08/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import Foundation

class User:NSObject{
    
    static let shared = User()
    
    var id:String!
    var firstName:String!
    var lastName:String!
    var email:String!
    var dob:String?
    var mobileNumber:String?
    var zipCode:String?
    var gender:String?
    var imageData:String?
    var accessToken:String!
    var accessTokenExpirationDate:String!
    var refreshToken:String!
    var facebookData:[String:Any]?
    var favouriteStores:[String]!
    var userSpecificOffers: [String]!
    var updateProfile:Bool!
    
    func initialize(_ userObject:[String:Any]){
        let userDefaults = UserDefaults()
        userDefaults.set(userObject, forKey: "CurrentUser")
        userDefaults.synchronize()
        for obj in userObject{
            if (obj.key == "id"){
                
            }
            else if (obj.key == "first_name"){
                
            }
            else if (obj.key == "last_name"){
                
            }
            else if (obj.key == "email"){
                
            }
            else if (obj.key == "dob"){
                
            }
            else if (obj.key == "mobile_number"){
                
            }
            else if (obj.key == "zip code"){
                
            }
            else if (obj.key == "gender"){
                
            }
            else if (obj.key == "profile_image_data"){
                
            }
            else if (obj.key == "access_token"){
                
            }
            else if (obj.key == "access_token_expiration_date"){
                
            }
            else if (obj.key == "refresh_token"){
                
            }
            else if (obj.key == "facebook_data"){
                
            }
            else if (obj.key == "favourite_stores"){
                
            }
            else if (obj.key == "user_specific_offers"){
                
            }
            else if (obj.key == "update_profile"){
                
            }
        }
    }
    
    func destroy(){
        id = nil
        firstName = nil
        lastName = nil
        email = nil
        dob = nil
        mobileNumber = nil
        zipCode = nil
        gender = nil
        imageData = nil
        accessToken = nil
        accessTokenExpirationDate = nil
        refreshToken = nil
        facebookData = nil
        favouriteStores = nil
        userSpecificOffers = nil
        updateProfile = nil
    }
    
    func logout(){
        let userDefaults = UserDefaults()
        userDefaults.removeObject(forKey: "CurrentUser")
        userDefaults.synchronize()
        destroy()
    }
}
