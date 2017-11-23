//
//  SettingsViewController.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 09/08/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableVw:UITableView!
    
    let sectionHeight:CGFloat = 50.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableVw.separatorColor = UIColor.separatorGrayColor()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewCont = segue.destination as? SignUpProfileViewController{
            viewCont.updateProfile = true
        }
    }
    
    
    //    MARK: -  Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: sectionHeight))
        view.backgroundColor = UIColor.white
        var label = UILabel.init(frame: CGRect(x: 10, y: sectionHeight * 0.4, width: SCREEN_WIDTH-20.0, height: sectionHeight * 0.4))
        label.font = UIFont.appBoldFont(15.0)
        label.textColor =  UIColor.titleGrayColor()
        label.text = section == 0 ? "ACCOUNT" : "ABOUT"
        view.addSubview(label)
        
        label = UILabel.init(frame: CGRect(x: 20, y: sectionHeight - 0.5, width: SCREEN_WIDTH-20.0, height: 1))
        label.backgroundColor = UIColor.separatorGrayColor()
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        default:
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let label = cell!.textLabel
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                label?.text = "Update Profile"
                break
            case 1:
                label?.text = "Connected Accounts"
                break
            default:
                label?.text = "Preferences"
            }
            break
        default:
            switch indexPath.row {
            case 0:
                label?.text = "Privacy Policy"
                break
            case 1:
                label?.text = "Terms of Use"
                break
            case 2:
                label?.text = "End User License Agreement"
                break
            default:
                label?.text = "Third Party Acknowledgements"
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "updateProfile", sender: nil)
                break
            case 1:
                self.performSegue(withIdentifier: "connectedAccounts", sender: nil)
                break
            default:
                self.performSegue(withIdentifier: "preferences", sender: nil)
                break
            }
            break
        default:
            switch indexPath.row {
            case 0:
                break
            case 1:
                break
            case 2:
                break
            default: break
            }
        }
    }
    
    
    //    MARK: - IBActions
    
    @IBAction func dismissView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
 
}
