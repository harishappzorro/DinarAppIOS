//
//  PreferencesViewController.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 09/08/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class PreferencesViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    let sectionHeight:CGFloat = 50.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //    MARK: - Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: sectionHeight))
        view.backgroundColor = UIColor.white
        var label = UILabel.init(frame: CGRect(x: 20, y: sectionHeight * 0.4, width: SCREEN_WIDTH-20.0, height: sectionHeight * 0.4))
        label.font = UIFont.appBoldFont(17.0)
        label.textColor =  UIColor.titleGrayColor()
        label.text = section == 0 ? "Email Alerts" : "App Alerts"
        view.addSubview(label)
        
        label = UILabel.init(frame: CGRect(x: 20, y: sectionHeight - 0.5, width: SCREEN_WIDTH-20.0, height: 1))
        label.backgroundColor = UIColor.separatorGrayColor()
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let label = cell?.textLabel
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                label?.text = "Receipt Status"
                break
            case 1:
                label?.text = "Cash Withdrawals"
                break
            default:
                label?.text = "News Letters"
            }
            break
        default:
            switch indexPath.row {
            case 0:
                label?.text = "Receipt Status"
                break
            case 1:
                label?.text = "Cash Withdrawals"
                break
            default:
                label?.text = "Weekly Shopping List"
            }
        }
        return cell!
    }

}
