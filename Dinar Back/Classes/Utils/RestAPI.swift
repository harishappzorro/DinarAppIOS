//
//  RestAPI.swift
//  Parking App
//
//  Created by Madhup Yadav on 12/08/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import Foundation
import SystemConfiguration

class RestAPI: NSObject{
//    let SERVER_LOCATION = "http://192.168.1.5/dinar-back/api/public/v1/"
    let SERVER_LOCATION = "http://www.jixtra.com/jixtra_app/DinarBack/api/public/v1/"
//    let SERVER_LOCATION = "http://miro92.com/dinarback/api/public/v1/"
    static let shared = RestAPI()
    
    //    MARK: - Checking Internet Connection
    func isInternetAvailable() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func makeRequest(params: [String: Any], methodType: String, completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()){
        var urlRequest:URLRequest!
        if (methodType == "POST" || methodType == "PUT") {
            let urlString = SERVER_LOCATION.appending((params["endPoint"] as? String)!)
            guard let url = URL(string: urlString) else {
                logPrint("Error: cannot create URL")
                return
            }
            urlRequest = URLRequest(url: url)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            do{
                let data = try JSONSerialization.data(withJSONObject: (params["body"] as? [String:Any])!, options: [])
                urlRequest.httpBody = data
            }catch {
                appDelegate.showAlert(message: "Unexpected Error occorred!")
                logPrint(error)
                completionHandler(false, nil, error)
                return
            }
        }else{
            var urlString = SERVER_LOCATION.appending((params["endPoint"] as? String)!)
            if params["requestParams"] != nil{
                for param in (params["requestParams"] as! [String]){
                    urlString = urlString.appendingFormat("/%@",param)
                }
            }
            guard let url = URL(string: urlString) else {
                logPrint("Error: cannot create URL")
                return
            }
            urlRequest = URLRequest(url: url)
        }
        
        if let accessToken = self.userAccessToken(){
            urlRequest.addValue(accessToken, forHTTPHeaderField: "Authentication-Info")
        }
        
        urlRequest.httpMethod = methodType
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            logPrint(response ?? error ?? "Unexpected Error occorred!")
            if(error != nil){
                appDelegate.showAlert(message: ((error)?.localizedDescription)!)
                completionHandler(false, nil, error)
            }else if(data != nil){
                do{
                    logPrint(data)
                    let object:[String:Any] = try JSONSerialization.jsonObject(with: (data)!, options: .mutableContainers) as! [String:Any]
                    logPrint(object)
                    if let error = object["error"]{
                        appDelegate.showAlert(message: (error as? [String:Any])!["message"]! as! String)
                        completionHandler(false, nil, error as? Error)
                    }else if let data = object["data"]{
                        print(data)
                        completionHandler(true, data, nil)
                    }else{
                        appDelegate.showAlert(message: "Unexpected Error occorred!")
                        completionHandler(false, nil, nil)
                    }
                }catch{
                    appDelegate.showAlert(message: "Unexpected Error occorred!")
                    completionHandler(false, nil, error)
                }
                
            }
            }.resume()
    }
    
    
    //    MARK: - Login
    
    func login(email: String, password: String, completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        var body = ["email": email, "password": password]
        body.appendDeviceInfo()
        let params = ["endPoint": "login", "body":body] as [String : Any]
        self.makeRequest(params: params, methodType: "POST", completionHandler: completionHandler)
    }
    
    func getLoginData(completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        var body = ["":""]
        body.appendDeviceInfo()
        let params = ["endPoint": "get_login", "body":body] as [String : Any]
        self.makeRequest(params: params, methodType: "POST", completionHandler: completionHandler)
    }
    
    func refreshAccessToken(completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        if let refresh_token = UserDefaults.standard.string(forKey: UserRefreshToken){
            var body = ["refresh_token":refresh_token]
            body.appendDeviceInfo()
            let params = ["endPoint": "refresh_access_token", "body":body] as [String : Any]
            self.makeRequest(params: params, methodType: "POST", completionHandler: completionHandler)
        }else{
            completionHandler(false, nil, nil)
        }
    }
    
    func forgotPassword(email: String, completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        var body = ["email": email]
        body.appendDeviceInfo()
        let params = ["endPoint": "forgot_password", "body":body] as [String : Any]
        self.makeRequest(params: params, methodType: "POST", completionHandler: completionHandler)
    }
    
    func signUp(email: String,
                password: String,
                firstName:String,
                lastName:String,
                dateOfBirth:String?,
                gender:String?,
                completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        var body = ["email": email, "password": password, "first_name": firstName, "last_name": lastName]
        if(dateOfBirth != nil){
            body["dob"] = dateOfBirth
        }
        
//        body["zip_code"] = "0000"
    
        if(gender != nil){
            body["gender"] = gender
        }
        body.appendDeviceInfo()
        let params = ["endPoint": "signup_user", "body":body] as [String : Any]
        self.makeRequest(params: params, methodType: "POST", completionHandler: completionHandler)
    }
    
    func facebookLogin(accessToken: String, fbDetails: NSDictionary, completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        let fbDetails = fbDetails
        let id = fbDetails.value(forKey: "id") as! String
        let email = fbDetails.value(forKey: "email") as! String
        let first_name = fbDetails.value(forKey: "first_name") as! String
        let last_name = fbDetails.value(forKey: "last_name") as! String
        let name = fbDetails.value(forKey: "name") as! String
        let gender = fbDetails.value(forKey: "gender") as! String
        let pictureObj = fbDetails.value(forKey: "picture") as! NSDictionary
        let pictureData = pictureObj.value(forKey: "data") as! NSDictionary
        let pictureURL = pictureData.value(forKey: "url") as! String
        
        var body = ["fb_access_token": accessToken,"id":id, "name":name, "first_name":first_name, "last_name": last_name, "gender": gender, "pictureUrl": pictureURL, "email": email]
        body.appendDeviceInfo()
        let params = ["endPoint": "facebook_login", "body":body] as [String : Any]
        self.makeRequest(params: params, methodType: "POST", completionHandler: completionHandler)
    }
    
    
    //    MARK: - Favorite/Unfavorite Stores
    
    func getAllStores(completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        if(isUserAccessTokenExpired()){
            self.refreshUserAccessToken(handler: { (success, data, error) in
                if(success){
                    AppDelegate.updateUserSessionData(data as! [String : Any])
                    
                    if let accessToken = self.userAccessToken(){
                        let params = ["endPoint": "get_all_stores", "accessToken": accessToken] as [String : Any]
                        self.makeRequest(params: params, methodType: "GET", completionHandler: completionHandler)
                    }else{
                        completionHandler(false, nil, nil)
                    }
                }
            })
        }else{
            if let accessToken = self.userAccessToken(){
                let params = ["endPoint": "get_all_stores", "accessToken": accessToken] as [String : Any]
                self.makeRequest(params: params, methodType: "GET", completionHandler: completionHandler)
            }else{
                completionHandler(false, nil, nil)
            }
        }
    }
    
    func addFavoriteStores(stores:[String], completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        if(isUserAccessTokenExpired()){
            self.refreshUserAccessToken(handler: { (success, data, error) in
                if(success){
                    AppDelegate.updateUserSessionData(data as! [String : Any])
                    
                    if let accessToken = self.userAccessToken(){
                        let body = ["store_ids": stores]
                        let params = ["endPoint": "add_favourite_stores", "accessToken": accessToken, "body":body] as [String : Any]
                        self.makeRequest(params: params, methodType: "POST", completionHandler: completionHandler)
                    }else{
                        completionHandler(false, nil, nil)
                    }
                }
            })
        }else{
            if let accessToken = self.userAccessToken(){
                let body = ["store_ids": stores]
                let params = ["endPoint": "add_favourite_stores", "accessToken": accessToken, "body":body] as [String : Any]
                self.makeRequest(params: params, methodType: "POST", completionHandler: completionHandler)
            }else{
                completionHandler(false, nil, nil)
            }
        }
    }
    
    func removeFavoriteStores(stores:[String], completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        if(isUserAccessTokenExpired()){
            self.refreshUserAccessToken(handler: { (success, data, error) in
                if(success){
                    AppDelegate.updateUserSessionData(data as! [String : Any])
                    
                    if let accessToken = self.userAccessToken(){
                        let body = ["store_ids": stores]
                        let params = ["endPoint": "remove_favourite_stores", "accessToken": accessToken, "body":body] as [String : Any]
                        self.makeRequest(params: params, methodType: "POST", completionHandler: completionHandler)
                    }else{
                        completionHandler(false, nil, nil)
                    }
                }
            })
        }else{
            if let accessToken = self.userAccessToken(){
                let body = ["store_ids": stores]
                let params = ["endPoint": "remove_favourite_stores", "accessToken": accessToken, "body":body] as [String : Any]
                self.makeRequest(params: params, methodType: "POST", completionHandler: completionHandler)
            }else{
                completionHandler(false, nil, nil)
            }
        }
    }
    
    func getFeatured(completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        if(isUserAccessTokenExpired()){
            self.refreshUserAccessToken(handler: { (success, data, error) in
                if(success){
                    AppDelegate.updateUserSessionData(data as! [String : Any])
                    
                    if let accessToken = self.userAccessToken(){
                        let params = ["endPoint": "get_featured_stores", "accessToken": accessToken] as [String : Any]
                        self.makeRequest(params: params, methodType: "GET", completionHandler: completionHandler)
                    }else{
                        completionHandler(false, nil, nil)
                    }
                }
            })
        }else{
            if let accessToken = self.userAccessToken(){
                let params = ["endPoint": "get_featured_stores", "accessToken": accessToken] as [String : Any]
                self.makeRequest(params: params, methodType: "GET", completionHandler: completionHandler)
            }else{
                completionHandler(false, nil, nil)
            }
        }
    }
    
    // MARK: - User profile
    func updateProfile(email: String,
                firstName:String,
                lastName:String,
                dateOfBirth:String?,
                gender:String?,
                completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        var body = ["email": email, "first_name": firstName, "last_name": lastName]
        if(dateOfBirth != nil){
            body["dob"] = dateOfBirth
        }
    
        if(gender != nil){
            body["gender"] = gender
        }
        body.appendDeviceInfo()
        let params = ["endPoint": "update_user", "body":body] as [String : Any]
        self.makeRequest(params: params, methodType: "POST", completionHandler: completionHandler)
    }
    
    //    MARK: - Search
    
    func getSearchResult(searchKeyword:String, filter:String, completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        
        var requestParams:[String] = []
        requestParams.append(searchKeyword)
        if(filter.count > 0){
            requestParams.append(filter)
        }
        
        if(isUserAccessTokenExpired()){
            self.refreshUserAccessToken(handler: { (success, data, error) in
                if(success){
                    AppDelegate.updateUserSessionData(data as! [String : Any])
                    
                    if let accessToken = self.userAccessToken(){
                        let params = ["endPoint": "search", "accessToken": accessToken, "requestParams" : requestParams] as [String : Any]
                        self.makeRequest(params: params, methodType: "GET", completionHandler: completionHandler)
                    }else{
                        completionHandler(false, nil, nil)
                    }
                }
            })
        }else{
            if let accessToken = self.userAccessToken(){
                let params = ["endPoint": "search", "accessToken": accessToken, "requestParams" : requestParams] as [String : Any]
                self.makeRequest(params: params, methodType: "GET", completionHandler: completionHandler)
            }else{
                completionHandler(false, nil, nil)
            }
        }
    }
    
    //    MARK: - Find Rebates
    
    func getCategories(completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        if(isUserAccessTokenExpired()){
            self.refreshUserAccessToken(handler: { (success, data, error) in
                if(success){
                    AppDelegate.updateUserSessionData(data as! [String : Any])
                    if let accessToken = self.userAccessToken(){
                        let params = ["endPoint": "get_categories", "accessToken": accessToken] as [String : Any]
                        self.makeRequest(params: params, methodType: "GET", completionHandler: completionHandler)
                    }else{
                        completionHandler(false, nil, nil)
                    }
                }
            })
        }else{
            if let accessToken = self.userAccessToken(){
                let params = ["endPoint": "get_categories", "accessToken": accessToken] as [String : Any]
                self.makeRequest(params: params, methodType: "GET", completionHandler: completionHandler)
            }else{
                completionHandler(false, nil, nil)
            }
        }
    }
    
    func getStoresForCategory(categoryId:String, completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        if(isUserAccessTokenExpired()){
            self.refreshUserAccessToken(handler: { (success, data, error) in
                if(success){
                    AppDelegate.updateUserSessionData(data as! [String : Any])
                    
                    if let accessToken = self.userAccessToken(){
                        let params = ["endPoint": "get_sub_category_stores", "accessToken": accessToken, "requestParams" : [categoryId]] as [String : Any]
                        self.makeRequest(params: params, methodType: "GET", completionHandler: completionHandler)
                    }else{
                        completionHandler(false, nil, nil)
                    }
                }
            })
        }else{
            if let accessToken = self.userAccessToken(){
                let params = ["endPoint": "get_sub_category_stores", "accessToken": accessToken, "requestParams" : [categoryId]] as [String : Any]
                self.makeRequest(params: params, methodType: "GET", completionHandler: completionHandler)
            }else{
                completionHandler(false, nil, nil)
            }
        }
    }
    
    func getStoreProducts(storeId:String, completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        if(isUserAccessTokenExpired()){
            self.refreshUserAccessToken(handler: { (success, data, error) in
                if(success){
                    AppDelegate.updateUserSessionData(data as! [String : Any])
                    
                    if let accessToken = self.userAccessToken(){
                        let params = ["endPoint": "get_store_products", "accessToken": accessToken, "requestParams" : [storeId]] as [String : Any]
                        self.makeRequest(params: params, methodType: "GET", completionHandler: completionHandler)
                    }else{
                        completionHandler(false, nil, nil)
                    }
                }
            })
        }else{
            if let accessToken = self.userAccessToken(){
                let params = ["endPoint": "get_store_products", "accessToken": accessToken, "requestParams" : [storeId]] as [String : Any]
                self.makeRequest(params: params, methodType: "GET", completionHandler: completionHandler)
            }else{
                completionHandler(false, nil, nil)
            }
        }
    }
    
    func getProductDetails(productId:String, completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        if(isUserAccessTokenExpired()){
            self.refreshUserAccessToken(handler: { (success, data, error) in
                if(success){
                    AppDelegate.updateUserSessionData(data as! [String : Any])
                    
                    if let accessToken = self.userAccessToken(){
                        let params = ["endPoint": "get_product_detail", "accessToken": accessToken, "requestParams" : [productId]] as [String : Any]
                        self.makeRequest(params: params, methodType: "GET", completionHandler: completionHandler)
                    }else{
                        completionHandler(false, nil, nil)
                    }
                }
            })
        }else{
            if let accessToken = self.userAccessToken(){
                let params = ["endPoint": "get_product_detail", "accessToken": accessToken, "requestParams" : [productId]] as [String : Any]
                self.makeRequest(params: params, methodType: "GET", completionHandler: completionHandler)
            }else{
                completionHandler(false, nil, nil)
            }
        }
    }
    
    func getMyRebates(completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        if(isUserAccessTokenExpired()){
            self.refreshUserAccessToken(handler: { (success, data, error) in
                if(success){
                    AppDelegate.updateUserSessionData(data as! [String : Any])
                    
                    if let accessToken = self.userAccessToken(){
                        let params = ["endPoint": "get_applied_rebates", "accessToken": accessToken] as [String : Any]
                        self.makeRequest(params: params, methodType: "GET", completionHandler: completionHandler)
                    }else{
                        completionHandler(false, nil, nil)
                    }
                }
            })
        }else{
            if let accessToken = self.userAccessToken(){
                let params = ["endPoint": "get_applied_rebates", "accessToken": accessToken] as [String : Any]
                self.makeRequest(params: params, methodType: "GET", completionHandler: completionHandler)
            }else{
                completionHandler(false, nil, nil)
            }
        }
    }
    
    func saveRebate(storeId:String, productId:String, completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        if(isUserAccessTokenExpired()){
            self.refreshUserAccessToken(handler: { (success, data, error) in
                if(success){
                    AppDelegate.updateUserSessionData(data as! [String : Any])
                    
                    if let accessToken = self.userAccessToken(){
                        let body = ["store_id": storeId, "product_id": productId]
                        let params = ["endPoint": "save_rebate", "accessToken": accessToken, "body":body] as [String : Any]
                        self.makeRequest(params: params, methodType: "POST", completionHandler: completionHandler)
                    }else{
                        completionHandler(false, nil, nil)
                    }
                }
            })
        }else{
            if let accessToken = self.userAccessToken(){
                let body = ["store_id": storeId, "product_id": productId]
                let params = ["endPoint": "save_rebate", "accessToken": accessToken, "body":body] as [String : Any]
                self.makeRequest(params: params, methodType: "POST", completionHandler: completionHandler)
            }else{
                completionHandler(false, nil, nil)
            }
        }
    }
    
    func removeRebate(storeId:String, productId:String, completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        if(isUserAccessTokenExpired()){
            self.refreshUserAccessToken(handler: { (success, data, error) in
                if(success){
                    AppDelegate.updateUserSessionData(data as! [String : Any])
                    
                    if let accessToken = self.userAccessToken(){
                        let body = ["store_id": storeId, "product_id": productId]
                        let params = ["endPoint": "remove_rebate", "accessToken": accessToken, "body":body] as [String : Any]
                        self.makeRequest(params: params, methodType: "POST", completionHandler: completionHandler)
                    }else{
                        completionHandler(false, nil, nil)
                    }
                }
            })
        }else{
            if let accessToken = self.userAccessToken(){
                let body = ["store_id": storeId, "product_id": productId]
                let params = ["endPoint": "remove_rebate", "accessToken": accessToken, "body":body] as [String : Any]
                self.makeRequest(params: params, methodType: "POST", completionHandler: completionHandler)
            }else{
                completionHandler(false, nil, nil)
            }
        }
    }
    
    func getGiftCards(completionHandler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        if(isUserAccessTokenExpired()){
            self.refreshUserAccessToken(handler: { (success, data, error) in
                if(success){
                    AppDelegate.updateUserSessionData(data as! [String : Any])
                    
                    if let accessToken = self.userAccessToken(){
                        let params = ["endPoint": "get_all_gifts", "accessToken": accessToken] as [String : Any]
                        self.makeRequest(params: params, methodType: "GET", completionHandler: completionHandler)
                    }else{
                        completionHandler(false, nil, nil)
                    }
                }
            })
        }else{
            if let accessToken = self.userAccessToken(){
                let params = ["endPoint": "get_all_gifts", "accessToken": accessToken] as [String : Any]
                self.makeRequest(params: params, methodType: "GET", completionHandler: completionHandler)
            }else{
                completionHandler(false, nil, nil)
            }
        }
    }
    
    func userAccessToken() -> String?{
        if let token = UserDefaults.standard.string(forKey: UserAccessToken){
            return token
        }
        return nil
    }
    
    func isUserAccessTokenExpired() -> Bool{
        if let expireDate = UserDefaults.standard.object(forKey: UserAccessTokenExpireDate) as? Date{
            return expireDate.isExpire()
        }
        return true
    }
    
    private func refreshUserAccessToken(handler: @escaping (_ success: Bool, _ data: Any?, _ error: Error?) -> ()) {
        self.refreshAccessToken(completionHandler: handler)
    }
}
