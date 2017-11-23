//
//  ActivityViewController.swift
//  Dinar Back
//
//  Created by Appzorro on 22/11/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit


class cellForActivity: UITableViewCell
{
    @IBOutlet var activutLbl: UILabel!
    
    @IBOutlet var activityIbImg: UIImageView!
}
class ActivityViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        // Do any additional setup after loading the view.
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "cellActivity"
        let cell:cellForActivity = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! cellForActivity!
        
        // set the text from the data model
       // cell.activutLbl.text = " Activity lable"
       // cell.backgroundColor = UIColor.red
        
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
