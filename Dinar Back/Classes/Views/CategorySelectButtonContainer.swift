//
//  CategorySelectButtonContainer.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 28/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class CategorySelectButtonContainer: UIScrollView {

    var categoryButtons:[CategorySelectButton]!
    
    private var _selectedIndex:Int = 0
    var selectedIndex:Int{
        set {
            _selectedIndex = newValue
            highlightCategory(newValue)
        }
        get {
            return _selectedIndex
        }
    }
    
    private func highlightCategory(_ index: Int){
        for categoryButton in categoryButtons{
            categoryButton.changeState(categoryButtons.index(of: categoryButton) == index)
        }
    }
    
    func highlightCategory(button:CategorySelectButton){
        self.selectedIndex = categoryButtons.index(of: button)!
    }

}
