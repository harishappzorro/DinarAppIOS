//
//  BarCodeEnterViewController.swift
//  Dinar Back
//
//  Created by Macbook01 on 13/10/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class BarCodeEnterViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var barcodeCell: JTSTableViewCell!
    @IBOutlet weak var txtFieldBarCode: UITextField!
    @IBOutlet var tableVw: UITableView!
    @IBOutlet var sumbitButton: JTSFormButton!
    
    public var delegate:BarCodeResultDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sumbitButton.enabled(enabled: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitBarCode(_ sender: Any) {
        if(self.txtFieldBarCode.text!.characters.count > 0 && delegate != nil){
            delegate?.captureBarCodeResult(barCodeString: self.txtFieldBarCode.text!)
            self.dismiss(animated: true, completion: nil)
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

    
    // MARK: - Table View Data Source & Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return barcodeCell
    }
    
    
}
