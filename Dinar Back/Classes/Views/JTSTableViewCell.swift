//
//  JTSTableViewCell.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 22/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class JTSTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var textField:UITextField!
    @IBOutlet weak var separatorLabel:UILabel!
    @IBOutlet weak var titleLabelTopConstraint:NSLayoutConstraint!
    
    let animationInterval = 0.6
    let awakeAnimationInterval = 0.2
    let titleLabelTopConstraintUnhiddenVal = 2.0
    let titleLabelTopConstraintHiddenVal = 2.0
    
    var wasEmpty:Bool! = true
    var hadError:Bool! = false
    var showError:Bool! = false
    var hasError:Bool! = false
    var shouldValidate:Bool! = false
    var mandatoryField:Bool! = true
    
    var cellIdentifier:String!
    var placeholder:String!
    var emptyPlaceholder:String!
    var invalidPlaceholder:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.alpha = 0.0
        Timer.scheduledTimer(withTimeInterval: awakeAnimationInterval, repeats: false) { (aTimer) in
            aTimer.invalidate()
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.awakeAnimationInterval) {
                    self.separatorLabel.backgroundColor = UIColor.separatorGrayColor()
                }
            }
        }
        if(self.textField.isSecureTextEntry){
            let button = UIButton.init(type: .custom)
            button.setImage(UIImage.init(named: "icon_password_show"), for: .normal)
            button.setImage(UIImage.init(named: "icon_password_hide"), for: .selected)
            button.addTarget(self, action: #selector(changeSecureEntry), for: .touchUpInside)
            button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            self.textField.rightView = button
            self.textField.rightViewMode = .always
        }
        if let id = self.reuseIdentifier{
            self.cellIdentifier = id
            let path = Bundle.main.path(forResource: "Login", ofType: "plist")
            var dict = NSDictionary.init(contentsOfFile: path!)
            dict = dict?.object(forKey: id) as? NSDictionary
            self.placeholder = dict?.object(forKey: "placeholder") as? String
            if let optional = dict?.object(forKey: "optional"){
                self.mandatoryField = !((optional as? Bool)!)
            }else{
                self.emptyPlaceholder = dict?.object(forKey: "emptyPlaceholder") as? String
                self.invalidPlaceholder = dict?.object(forKey: "invalidPlaceholder") as? String
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func textFieldTextChanged(field: UITextField){
        if(shouldValidate){
            if(self.cellIdentifier == "email"){
                self.hasError = !field.validateEmail()
            }else if(self.cellIdentifier == "phone"){
                self.hasError = !field.validatePhoneNumber()
            }else if(self.cellIdentifier == "password"){
                self.hasError = !field.validatePassword()
            }else if(self.cellIdentifier == "first_name" || self.cellIdentifier == "last_name" || self.cellIdentifier == "bar_code"){
                self.hasError = !field.validateBlank()
            }else if(self.cellIdentifier == "zip"){
                self.hasError = !field.validateZip()
            }else if(self.cellIdentifier == "dob"){
                self.hasError = !field.validateDob()
            }
        }
        self.animateTitleLabel(empty: (field.text?.isEmpty)!)
        if(self.mandatoryField == true){
            NotificationCenter.default.post(name: FormValidityChangedNotificationName, object: self, userInfo: nil)
        }
    }
    
    func animateTitleLabel(empty:Bool){
        if(wasEmpty == empty && hadError == hasError){
            return
        }
        wasEmpty = empty
        hadError = hasError
        UIView.animate(withDuration: self.animationInterval) {
            self.titleLabelTopConstraint.constant = CGFloat(empty ? self.titleLabelTopConstraintHiddenVal : self.titleLabelTopConstraintUnhiddenVal)
            if(self.mandatoryField == true){
                self.titleLabel.alpha = empty ? 0.0 : 1.0
                self.titleLabel.textColor = self.hasError || empty ? UIColor.titleRedColor() : UIColor.titleDarkGrayColor()
                self.separatorLabel.backgroundColor = self.hasError || empty ? UIColor.separatorRedColor() : UIColor.separatorGreenColor()
                if(empty == true){
                    self.textField.placeholder = self.hasError == true ? self.invalidPlaceholder : self.emptyPlaceholder
                }else{
                    self.titleLabel.text = self.hasError == true ? self.invalidPlaceholder : self.placeholder
                }
            }
        }
    }
    
    func changeSecureEntry(button: UIButton){
        button.isSelected = !button.isSelected
        self.textField.isSecureTextEntry = !button.isSelected
    }
    
}
