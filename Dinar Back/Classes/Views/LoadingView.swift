//
//  LoadingView.swift
//  Dinar Back
//
//  Created by bo on 10/31/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    @IBOutlet weak var loadingBackgroundView: UIView!
    var animationView: LOTAnimationView!
    
    func instanceFromNib(){
        
        animationView = LOTAnimationView(name: "loader_ring")
        animationView.loopAnimation = true
        self.loadingBackgroundView.addSubview(animationView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.animationView.frame = self.loadingBackgroundView.bounds
    }
    
    func loadingPlay(){
        animationView.play()
    }
    
    func loadingStop(){
        animationView.stop()
    }
    
}
