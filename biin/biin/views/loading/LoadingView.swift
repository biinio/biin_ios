//  LoadingView.swift
//  biin
//  Created by Esteban Padilla on 1/15/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation
import UIKit

class LoadingView:UIView {

    var loadingLbl:UILabel?
    var biinLogo:BNUIBiinView?
    var loadingIndicator:UIActivityIndicatorView?
    var progressView:UIProgressView?
//    override init() {
//        super.init()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
//        biinLogo = UIImageView(frame: CGRectMake(0, 100, 320, 320))
//        biinLogo!.image = UIImage(named: "biinLogoLS.png")
//        self.addSubview(biinLogo!)
        
        var screenWidth = SharedUIManager.instance.screenWidth
        var screenHeight = SharedUIManager.instance.screenHeight
        
        biinLogo = BNUIBiinView(position:CGPoint(x:((screenWidth - 110) / 2), y:0), scale:SharedUIManager.instance.loadingView_logoSize)
        biinLogo!.frame.origin.x = ((screenWidth - biinLogo!.frame.width) / 2)
        biinLogo!.frame.origin.y = (((screenHeight - biinLogo!.frame.height) / 2) - 50)
        
        self.addSubview(biinLogo!)
        biinLogo!.setNeedsDisplay()
        

        var barWidth:CGFloat = biinLogo!.frame.width - 20.0
        var xpos:CGFloat = ((screenWidth - barWidth ) / 2)
        var ypos:CGFloat = biinLogo!.frame.height + biinLogo!.frame.origin.y
        ypos += 10
        
        var loadingView = UIView()
        loadingView.frame = CGRectMake((xpos - 3), (ypos - 3), (barWidth + 6), 9)
        loadingView.backgroundColor = UIColor.appBackground()
        loadingView.layer.cornerRadius = 3
        loadingView.layer.masksToBounds = true
        loadingView.layer.borderColor = UIColor.biinColor().CGColor
        loadingView.layer.borderWidth = 1
        self.addSubview(loadingView)
        
        progressView = UIProgressView(frame: CGRectMake(xpos, ypos, barWidth, 8))
        progressView!.setProgress(0.0, animated: false)
        progressView!.progressViewStyle = UIProgressViewStyle.Bar
        progressView!.trackTintColor = UIColor.grayColor()
        progressView!.progressTintColor = UIColor.biinColor()
        self.addSubview(progressView!)
        
        ypos += 8
        loadingLbl = UILabel(frame: CGRect(x:0, y:ypos, width:frame.width, height:18))
        loadingLbl!.font = UIFont(name: "Lato-Light", size: 15)
        loadingLbl!.textColor = UIColor.appTextColor()
        loadingLbl!.textAlignment = NSTextAlignment.Center
        loadingLbl!.numberOfLines = 0
        loadingLbl!.text = NSLocalizedString("Loading", comment: "the Loading title")
        self.addSubview(loadingLbl!)
        
  
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateProgressView(value:Float){
        progressView!.setProgress(value, animated: true)
    }
    
    func showHardwareError() {
        
        loadingLbl!.alpha = 0
        biinLogo!.alpha = 0
        
        var labelHeight:CGFloat = 80.0
        var ypos:CGFloat = (frame.height / 2) - (labelHeight / 2)
        var errorLbl = UILabel(frame: CGRect(x:25, y:ypos, width:(self.frame.width - 50), height:labelHeight))
        errorLbl.font = UIFont(name: "Lato-Light", size: 18)
        errorLbl.text = NSLocalizedString("HardwareError", comment: "HardwareError")
        errorLbl.textColor = UIColor.blackColor()
        errorLbl.textAlignment = NSTextAlignment.Center
        errorLbl.numberOfLines = 3

        self.addSubview(errorLbl)

    }
}