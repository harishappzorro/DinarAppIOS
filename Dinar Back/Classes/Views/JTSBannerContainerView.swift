//
//  JTSBannerContainerView.swift
//  Dinar Back
//
//  Created by Madhup Yadav on 27/07/17.
//  Copyright © 2017 Jixtra Technologies LLP. All rights reserved.
//

import UIKit
//import PureLayout

class JTSBannerContainerView: UIView {
    
    @IBOutlet weak var bannerContainer:UIScrollView!
    @IBOutlet weak var indicatorView:UIActivityIndicatorView!
    var data:[[String:Any]]!
    
    func bindData(params:[[String:Any]]){
        self.data = params
        for view in self.bannerContainer.subviews{
            view.removeFromSuperview()
        }
        let frame = self.bounds
        let width = SCREEN_WIDTH
        var x:CGFloat = 0.0
        let height = frame.size.height
        //        var banners = Array()
        var bannerView:JTSBannerView!
        for bannerData in params{
            bannerView = Bundle.main.loadNibNamed("JTSBannerView", owner: self, options: nil)?[0] as! JTSBannerView
            bannerView.frame = CGRect(origin: CGPoint(x: x, y: 0), size: CGSize(width: width, height: height))
            bannerView.bindData(params: bannerData)
            bannerContainer.addSubview(bannerView)
            //            bannerView.snp.makeConstraints({ (make) in
            //                make.top.equalTo(bannerContainer).offset(0)
            //                make.bottom.equalTo(bannerContainer).offset(0)
            //                make.width.equalTo(SCREEN_WIDTH)
            //                if(index == 0){
            //                    make.left.equalTo(bannerContainer).offset(0)
            //                }else{
            //                    make.trailing.equalTo(lastBanner).offset(0)
            //                }
            //                if(index == count - 1){
            //                    make.right.equalTo(bannerContainer).offset(0)
            //                }
            //            })
            //            lastBanner = bannerView
            x = x + width
            //        (bannerContainer.subviews as NSArray)
        }
        bannerContainer.contentSize = CGSize(width: x, height: height)
        self.indicatorView.stopAnimating()
    }
}
