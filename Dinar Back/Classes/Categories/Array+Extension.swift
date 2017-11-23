//
//  Array+Extension.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 18/09/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import Foundation

extension Array {
    
    func uniqueCategories() -> [String]{
        var uniqueValues: [String] = []
        for item in self{
            let category = ((item as? [String:Any])!["category"] as! String)
            if !uniqueValues.contains(category) {
                uniqueValues += [category]
            }
        }
        return uniqueValues
    }
}
