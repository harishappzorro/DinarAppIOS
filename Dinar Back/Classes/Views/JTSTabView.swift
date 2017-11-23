//
//  JTSTabView.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 27/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class JTSTabView: UIView {
    
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    
    var selected:Bool!
    
    override func awakeFromNib() {
        self.selected(select:false)
    }
    
    func selected(select:Bool) {
        self.selected = select
        self.imageView.isHighlighted = select
        self.titleLabel.textColor = select ? UIColor.titleRedColor() : UIColor.titleGrayColor()
        if(select){
//            self.highlight()
        }
    }
    
    func highlight() {
        self.highlight(counter: 0)
    }
    
    func highlight(counter:Int){
        if(counter >= 3){
            return
        }
        let center = CGPoint(x: imageView.frame.size.width/2.0, y: imageView.frame.size.height/2.0)
        let view:UIView = UIView.init(frame: CGRect(origin: center, size: CGSize(width: 2.0, height: 2.0)))
        view.layer.cornerRadius = 1
        view.alpha = 0.5
        view.backgroundColor = UIColor.appGreenColor()
        imageView.addSubview(view)
        imageView.sendSubview(toBack: view)
        let finalSize = UIScreen.main.bounds.size.width*0.25
        
        UIView.animate(withDuration: 0.4, animations: {
            view.transform = CGAffineTransform(scaleX: finalSize, y: finalSize)
        }) { (completed) in
            view.removeFromSuperview()
            let newCounter = counter + 1
            self.highlight(counter: newCounter)
        }
    }

}
