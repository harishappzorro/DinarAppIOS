//
//  Date+Extension.swift
//  Dinar Back
//
//  Created by Macbook01 on 22/09/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import Foundation

extension Date{
    func isExpire() -> Bool{
        let currentDate = Date.init()
        let result = self.compare(currentDate)
        return result == ComparisonResult.orderedAscending
    }
}
