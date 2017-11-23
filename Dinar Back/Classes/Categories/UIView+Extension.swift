//
//  UIView+Extension.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 12/08/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

extension UIView {
    func tableViewCell() -> UITableViewCell? {
        var view = self.superview
        while !((view?.isKind(of: UITableViewCell.self))!) {
            view = view?.superview
            if (view?.superview) == nil{
                break
            }
        }
        return view as? UITableViewCell
    }
}
