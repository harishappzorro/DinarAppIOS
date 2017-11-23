//
//  RequestBody+Extension.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 23/08/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit
import Foundation

extension Dictionary where Key == String, Value == String{
    
    mutating func appendDeviceInfo(){
        self["device_id"] = UUID().uuidString
        if(getWiFiAddress() != nil){
            self["ip_address"] = getWiFiAddress()
        }else{
            self["ip_address"] = "000.000.000.000"
        }
        logPrint("Append Device Info \(self)")
    }
    
}
