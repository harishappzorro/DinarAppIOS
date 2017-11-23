//
//  AccountViewController.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 27/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class AccountViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableVw:UITableView!
    @IBOutlet weak var zeroBalanceViewHeight: NSLayoutConstraint!
    @IBOutlet weak var zeroBalanceView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var availableBalanceLabel: UILabel!
    @IBOutlet weak var lifetimeEarningsLabel: UILabel!
    @IBOutlet weak var accountPictureImageView: UIImageView!
    
    let sectionHeight:CGFloat = 50.0
    
    var data:[String:Any]!
    var giftCards:[[String:Any]]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableVw.register(UINib.init(nibName: "GiftCardTableViewCell", bundle: nil), forCellReuseIdentifier: "GiftCardTableViewCell")
        self.getGiftCards()
//        self.data = Array()
//        for _ in 0..<2 {
//            dataArray.append(Int(arc4random() % 13) + 1)
//        }
//        hideZeroBalanceView()
        print(appDelegate.userInfo)
        
        if let image_url = appDelegate.userInfo["image_url"] as? String{
            print(image_url)
            let catPictureURL = URL(string: image_url)!
            let session = URLSession(configuration: .default)
            
            // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
            let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
                // The download has finished.
                if let e = error {
                    print("Error downloading cat picture: \(e)")
                } else {
                    // No errors found.
                    // It would be weird if we didn't have a response, so check for that too.
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded cat picture with response code \(res.statusCode)")
                        if let imageData = data {
                            // Finally convert that Data into an image and do what you wish with it.
                            let image = UIImage(data: imageData)
                            // Do something with your image.
                            DispatchQueue.main.async {
                                self.accountPictureImageView.image = image
                            }
                            
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }
            
            downloadPicTask.resume()        }else{
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(displayP3Red: 236/255, green: 237/255, blue: 244/255, alpha: 1)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = .clear
    }
    @IBAction func logOutClicked(_ sender: UIButton) {
        AppDelegate.logoutSuccessful(nil)
        
    }
    
    
    func getGiftCards(){

        self.showProgressView()
        RestAPI.shared.getGiftCards { (success, data, error) in
            DispatchQueue.main.async {
                self.hideProgressView()
                if(success){
                    if(data != nil){
                        logPrint(data)
                        if let object = data as? [String:Any]{
                            self.data = object
                            
                                if let name = appDelegate.userInfo["first_name"] as? String{
                                    self.nameLabel.text = String.init(format: "%@", name.capitalized)
                                }
                                if let lifeTimeEarnings = object["lifetime_earning"] as? String{
                                    let lifeTimeEarnings = "12387893"
                                    let largeNumber = Double(lifeTimeEarnings)
                                    let numberFormatter = NumberFormatter()
                                    numberFormatter.numberStyle = NumberFormatter.Style.decimal
                                    let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber!))
                                    self.lifetimeEarningsLabel.text = formattedNumber
                                }
                                if let balance = object["balance"] as? String{
//                                    let string = NSMutableAttributedString(string: "IQD")
//                                    string.addAttribute(NSFontAttributeName, value: UIFont.appBoldFont(20.0), range: NSRange.init(location: 0, length: 1))
//                                    let price = NSMutableAttributedString(string: balance)
//                                    price.addAttribute(NSFontAttributeName, value: UIFont.appBoldFont(20.0), range: NSRange.init(location: 0, length: price.length))
//                                    string.append(price)
//                                    let location = string.length
//                                    string.append(NSAttributedString(string:"\nAvailable for withdrawal"))
//                                    let length = string.length - location
//                                    string.addAttribute(NSFontAttributeName, value: UIFont.appBoldFont(13.0), range: NSRange.init(location: location, length: length))
//
//                                    string.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange.init(location: 0, length: string.length - 1))
                                    let balance = "2343"
                                    let largeNumber = Double(balance)
                                    let numberFormatter = NumberFormatter()
                                    numberFormatter.numberStyle = NumberFormatter.Style.decimal
                                    let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber!))
                                    self.availableBalanceLabel.text = formattedNumber
                                }
                                if let gifts = object["data"] as? [[String:Any]]{
                                    self.giftCards = gifts
                                    self.tableVw.reloadData()
                                }
                            }
                        }
                    }
            }
        }
    }
    
    func hideZeroBalanceView(){
        DispatchQueue.main.async {
            if let headerView = self.tableVw.tableHeaderView{
                var frame = headerView.frame
                frame.size.height -= self.zeroBalanceViewHeight.constant
                headerView.frame = frame
            }
            self.zeroBalanceViewHeight.constant = 0
            self.zeroBalanceView.layoutIfNeeded()
            self.tableVw.reloadData()
        }
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
        return self.giftCards == nil ? 0 : 1
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: sectionHeight))
//        view.backgroundColor = UIColor.white
//        var label = UILabel.init(frame: CGRect(x: 20, y: sectionHeight * 0.4, width: SCREEN_WIDTH-20.0, height: sectionHeight * 0.4))
//        label.font = UIFont.appBoldFont(17.0)
//        label.textColor =  UIColor.titleGrayColor()
//        label.text = section == 0 ? "FEATURED GIFT CARDS" : "GIFT CARDS"
//        view.addSubview(label)
//
//        label = UILabel.init(frame: CGRect(x: 20, y: sectionHeight - 0.5, width: SCREEN_WIDTH-20.0, height: 1))
//        label.backgroundColor = UIColor.separatorGrayColor()
//        view.addSubview(label)
//
//        return view
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let count = giftCards[indexPath.row].count
        var collectionViewHeight:Float = 0.0
        if (count % 3 == 0){
            collectionViewHeight = (130.0 * Float(count/3) + (Float(count/3 + 1)) * 10.0)
        }else{
            collectionViewHeight = (130.0 * Float(count/3 + 1) + (Float(count/3 + 2)) * 10.0)
        }
        return CGFloat(collectionViewHeight) * SCREEN_WIDTH/375.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GiftCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GiftCardTableViewCell") as! GiftCardTableViewCell
        cell.bind(params: giftCards)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1:
            self.performSegue(withIdentifier: "showSettings", sender: nil)
            break
        case 2:
            break
        default:
            break
        }
    }

}
