//
//  ForgotPasswordViewController.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 22/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: LoginUIControlsViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var emailCell: JTSTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cells = [emailCell]
        // Do any additional setup after loading the view.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return emailCell
    }

    @IBAction func forgotPasswordClicked(_ sender: JTSFormButton) {
        self.view.endEditing(true)
        self.showProgressView()
        DispatchQueue.main.async {
            RestAPI.shared.forgotPassword(email: self.emailCell.textField.text!) { (success, data, error) in
                
                self.hideProgressView()
                if(success){
                    if data != nil{
                        appDelegate.showAlert(message: "Instructions have been sent to your registered email.")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
                       
        }
    }
}
