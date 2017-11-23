//
//  SignUpProfileViewController.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 22/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class SignUpProfileViewController: LoginUIControlsViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var tableVw: UITableView!
    
    @IBOutlet var zipAccessoryView: UIToolbar!
    
    @IBOutlet weak var firstNameCell: JTSTableViewCell!
    @IBOutlet weak var lastNameCell: JTSTableViewCell!
    @IBOutlet weak var emailCell: JTSTableViewCell!
    @IBOutlet weak var passwordCell: JTSTableViewCell!
    @IBOutlet weak var dobCell: JTSTableViewCell!
    @IBOutlet weak var zipCell: JTSTableViewCell!
    @IBOutlet weak var genderCell: JTSTableViewCell!
    @IBOutlet weak var zipTextField: UITextField!
    
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerContainer: UIView!
    
    let genderPickerArray:[String]! = ["", "Male", "Female"]
    var updateProfile:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.cells = updateProfile ? [firstNameCell, lastNameCell, emailCell, dobCell/*, zipCell*/] : [firstNameCell, lastNameCell, emailCell, passwordCell, dobCell/*, zipCell*/]
        self.zipTextField.inputAccessoryView = zipAccessoryView
        self.pickerContainer.isHidden = true
        self.datePicker.maximumDate = NSDate() as Date
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPickerContainer(cell: JTSTableViewCell?) {
        let duration:TimeInterval = 0.3
        
        if cell != nil {
            self.bottomViewConstraint?.constant = 260.0
        } else {
            self.bottomViewConstraint?.constant = 0.0
        }
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            if(cell != nil){
                self.tableVw.scrollToRow(at: self.tableVw.indexPath(for: cell!)!, at: .top, animated: false)
            }
        })
    }
    
    
    // MARK: - Text Field Delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let superview = textField.tableViewCell(){
            let cell:JTSTableViewCell = superview as! JTSTableViewCell
            if(cell.cellIdentifier == "dob" || cell.cellIdentifier == "gender"){
                self.view.endEditing(true)
                self.pickerContainer.isHidden = false
                self.datePicker.isHidden = !(cell.cellIdentifier == "dob")
                self.genderPicker.isHidden = !(cell.cellIdentifier == "gender")
                showPickerContainer(cell: cell)
                return false
            }else{
                self.pickerContainer.isHidden = true
            }
        }
        return true
    }
    
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updateProfile == true ? 5 : 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(updateProfile){
            return 70.0
        }else{
            switch indexPath.row {
            case 3:
                return 90.0
            default:
                return 70.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(updateProfile){
            switch indexPath.row {
            case 0:
                if let firstName = appDelegate.userInfo["first_name"] as? String{
                    firstNameCell.textField.text = firstName
                }
                return firstNameCell
            case 1:
                if let lastName = appDelegate.userInfo["last_name"] as? String{
                    lastNameCell.textField.text = lastName
                }
                return lastNameCell
            case 2:
                if let email = appDelegate.userInfo["email"] as? String{
                    emailCell.textField.text = email
                }
                return emailCell
            case 3:
                if let dob = appDelegate.userInfo["dob"] as? String{
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let date = dateFormatter.date(from: dob)
                    dateFormatter.dateFormat = "MMM dd, yyyy"
                    let dateOfBirth = dateFormatter.string(from: date!)
                    
                    dobCell.textField.text = dateOfBirth
                }
                return dobCell
            /*case 4:
                return zipCell*/
            default:
                if let gender = appDelegate.userInfo["gender"] as? String{
                    genderCell.textField.text = gender
                }
                return genderCell
            }
        }else{
            switch indexPath.row {
            case 0:
                return firstNameCell
            case 1:
                return lastNameCell
            case 2:
                return emailCell
            case 3:
                return passwordCell
            case 4:
                return dobCell
            /*case 5:
                return zipCell*/
            default:
                return genderCell
            }
        }
    }
    
    
    // MARK: - Picker View Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderPickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderPickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.genderCell.textField.text = genderPickerArray[row]
        self.genderCell.animateTitleLabel(empty: (self.genderCell.textField.text?.isEmpty)!)
        NotificationCenter.default.post(name: FormValidityChangedNotificationName, object: self.genderCell, userInfo: nil)
    }
    
    
    // MARK: - IBActions
    
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        zipTextField.resignFirstResponder()
    }
    
    @IBAction func pickerContainerDoneClicked(_ sender: UIBarButtonItem) {
        showPickerContainer(cell: nil)
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        self.dobCell.textField.text = dateFormatter.string(from: sender.date)
        self.dobCell.animateTitleLabel(empty: (self.dobCell.textField.text?.isEmpty)!)
        NotificationCenter.default.post(name: FormValidityChangedNotificationName, object: self.dobCell, userInfo: nil)
    }
    
    @IBAction func signUpClicked(){
        self.view.endEditing(true)
        self.showProgressView()
        var dateOfBirth:String! = nil
        if(!(dobCell.textField.text?.isEmpty)!){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let date = dateFormatter.date(from: dobCell.textField.text!)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateOfBirth = dateFormatter.string(from: date!)
        }
        
        if(updateProfile){
            RestAPI.shared.updateProfile(email: emailCell.textField.text!, firstName: firstNameCell.textField.text!, lastName: lastNameCell.textField.text!, dateOfBirth: dateOfBirth, gender: genderCell.textField.text!, completionHandler: { (success, data, error) in
                 DispatchQueue.main.async {
                    self.hideProgressView()
                    if(success){
                       
                            appDelegate.userInfo["email"] = self.emailCell.textField.text!
                            appDelegate.userInfo["first_name"] = self.firstNameCell.textField.text!
                            appDelegate.userInfo["last_name"] = self.lastNameCell.textField.text!
                            appDelegate.userInfo["gender"] = self.genderCell.textField.text!
                            appDelegate.userInfo["dob"] = dateOfBirth
                        
                            self.navigationController?.popViewController(animated: true)
                        }
                }
            })
        }else{
            DispatchQueue.main.async {
                RestAPI.shared.signUp(email: self.emailCell.textField.text!, password: self.passwordCell.textField.text!, firstName: self.firstNameCell.textField.text!, lastName: self.lastNameCell.textField.text!, dateOfBirth: dateOfBirth, gender: self.genderCell.textField.text!, completionHandler: { (success, data, error) in
                    self.hideProgressView()
                    if(success){
                        if data != nil{
                            AppDelegate.loginSuccessful(data)
                        }
                    }
                })
            }
            
        }
    }
}
