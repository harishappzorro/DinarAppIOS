//
//  LoginUIControlsViewController.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 24/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class LoginUIControlsViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var bottomViewConstraint:NSLayoutConstraint!
    @IBOutlet weak var formButton:JTSFormButton!
    
    var cells:[JTSTableViewCell]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Note that SO highlighting makes the new selector syntax (#selector()) look
        // like a comment but it isn't one
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginUIControlsViewController.validityChanged), name:FormValidityChangedNotificationName, object: nil)
        self.formButton.isEnabled = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.bottomViewConstraint?.constant = 0.0
            } else {
                self.bottomViewConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let superview = textField.tableViewCell(){
            let cell:JTSTableViewCell = superview as! JTSTableViewCell
            cell.shouldValidate = true
            if cell.cellIdentifier == "email"{
                cell.hasError = !textField.validateEmail()
                cell.animateTitleLabel(empty: (textField.text?.isEmpty)!)
            }else if(cell.cellIdentifier == "phone"){
                cell.hasError = !textField.validatePhoneNumber()
                cell.animateTitleLabel(empty: (textField.text?.isEmpty)!)
            }else if(cell.cellIdentifier == "password"){
                cell.hasError = !textField.validatePassword()
                cell.animateTitleLabel(empty: (textField.text?.isEmpty)!)
            }else if(cell.cellIdentifier == "first_name" || cell.cellIdentifier == "last_name"){
                cell.hasError = !textField.validateBlank()
                cell.animateTitleLabel(empty: (textField.text?.isEmpty)!)
            }else if(cell.cellIdentifier == "dob"){
                cell.hasError = !textField.validateDob()
                cell.animateTitleLabel(empty: (textField.text?.isEmpty)!)
            }else if(cell.cellIdentifier == "zip"){
                cell.hasError = !textField.validateZip()
                cell.animateTitleLabel(empty: (textField.text?.isEmpty)!)
            }
        }
    }
    
    func validityChanged(nc : Notification){
        var enabled:Bool = true
        for cell in cells{
            enabled = (enabled && !cell.hasError)
            if cell.cellIdentifier == "email"{
                enabled = (enabled && cell.textField.validateEmail())
            }else if(cell.cellIdentifier == "phone"){
                enabled = (enabled && cell.textField.validatePhoneNumber())
            }else if(cell.cellIdentifier == "password"){
                enabled = (enabled && cell.textField.validatePassword())
            }else if(cell.cellIdentifier == "first_name" || cell.cellIdentifier == "last_name"){
                enabled = (enabled && cell.textField.validateBlank())
            }else if(cell.cellIdentifier == "dob"){
                enabled = (enabled && cell.textField.validateDob())
            }else if(cell.cellIdentifier == "zip"){
                enabled = (enabled && cell.textField.validateZip())
            }
        }
        self.formButton.enabled(enabled: enabled)
    }
    
}
