//  ElementMiniView.swift
//  biin
//  Created by Esteban Padilla on 1/16/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation
import UIKit

class ElementMiniView: BNView {
    
    var delegate:ElementMiniView_Delegate?
    var element:BNElement?
    var image:BNUIImageView?
    var header:ElementMiniView_Header?
    var imageRequested = false
    
    var biinItButton:BNUIButton_BiinIt?
    var shareItButton:BNUIButton_ShareIt?
    var removeItButton:BNUIButton_RemoveIt?
    var stickerView:BNUIStickerView?
    var discountView:BNUIDiscountView?
    var priceView:BNUIPricesView?
    
    var collectionScrollPosition:Int = 0
    
    var animationView:BiinItAnimationView?
    
//    override init() {
//        super.init()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, father:BNView?) {
        super.init(frame: frame, father:father )
    }
    
    convenience init(frame:CGRect, father:BNView?, element:BNElement?, elementPosition:Int, showRemoveBtn:Bool){
        self.init(frame: frame, father:father )
        
        self.layer.borderColor = UIColor.appMainColor().CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        //self.layer.shadowOffset = CGSizeMake(0, 0.5)
        //self.layer.shadowRadius = 1
        //self.layer.shadowOpacity = 0.25
        self.element = BNAppSharedManager.instance.dataManager.elements[element!._id!]
        
        if let color = self.element!.media[0].domainColor {
            self.backgroundColor = color
        } else {
            self.backgroundColor = UIColor.appMainColor()
        }
        
        //Positioning image
        var imageSize = frame.height - SharedUIManager.instance.miniView_headerHeight
        var xpos = ((imageSize - frame.width) / 2 ) * -1
        image = BNUIImageView(frame: CGRectMake(xpos, SharedUIManager.instance.miniView_headerHeight, imageSize, imageSize))
        //image!.alpha = 1
        self.addSubview(image!)
        
        header = ElementMiniView_Header(frame: CGRectMake(0, 0, frame.width, SharedUIManager.instance.miniView_headerHeight), father: self, element:self.element, elementPosition:elementPosition, showCircle:!showRemoveBtn)
        self.addSubview(header!)
        header!.updateSocialButtonsForElement(self.element)
        
        
        var ypos:CGFloat = SharedUIManager.instance.siteView_headerHeight - 5
        /*
        if self.element!.hasDiscount {
            discountView = BNUIDiscountView(frame: CGRectMake(-5, ypos, 40, 35), text: self.element!.discount!)
            self.addSubview(discountView!)
            ypos += 40
        }
        */
        
        if element!.hasPrice && !element!.hasListPrice && !element!.hasFromPrice {
            
            priceView = BNUIPricesView(frame: CGRectMake(5, ypos, 100, 25), price: "\(element!.currency!)\(element!.price!)", isMini:true)
            self.addSubview(priceView!)
            ypos += 40
            
        } else if element!.hasPrice &&  element!.hasListPrice {
            
            priceView = BNUIPricesView(frame: CGRectMake(5, ypos, 100, 38), oldPrice:"\(element!.currency!)\(element!.listPrice!)", newPrice:"\(element!.currency!)\(element!.price!)", isMini:true)
            self.addSubview(priceView!)
            ypos += 40
            
        } else if element!.hasPrice &&  element!.hasFromPrice {

            priceView = BNUIPricesView(frame: CGRectMake(5, ypos, 100, 37), price: "\(element!.currency!)\(element!.price!)", from:NSLocalizedString("From", comment: "From")
 , isMini:true)
            self.addSubview(priceView!)

            ypos += 40
        }
        
        /*
        if self.element!.hasSticker {
            stickerView = BNUIStickerView(frame:CGRectMake((SharedUIManager.instance.miniView_width - 55), (SharedUIManager.instance.miniView_headerHeight + 5), 50, 50), type:self.element!.sticker!.type, color:self.element!.sticker!.color! )
            self.addSubview(stickerView!)
        }
        */

        
        xpos = 5
        if showRemoveBtn {
            removeItButton = BNUIButton_RemoveIt(frame: CGRectMake((frame.width - 19), 4, 15, 15))
            removeItButton!.addTarget(self, action: "unBiinit:", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(removeItButton!)
        } else {
            
            biinItButton = BNUIButton_BiinIt(frame: CGRectMake(xpos, (frame.height - 42), 37, 37))
            biinItButton!.addTarget(self, action: "biinit:", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(biinItButton!)
            xpos += 37
            
            if self.element!.userBiined {
                biinItButton!.showDisable()
            }
        }
        
        shareItButton = BNUIButton_ShareIt(frame: CGRectMake(xpos, (frame.height - 42), 37, 37))
        shareItButton!.addTarget(self, action: "shareit:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(shareItButton!)
        
        animationView = BiinItAnimationView(frame:CGRectMake(0, 0, frame.width, frame.height))
        animationView!.alpha = 0
        self.addSubview(animationView!)
        
        var tap = UITapGestureRecognizer(target: self, action: "handleTap:")
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
        self.isFirstResponder()
    }
    
    override func transitionIn() {

    }
    
    override func transitionOut( state:BNState? ) {

    }
    
    override func setNextState(option:Int){
        //Start transition on root view controller
        father!.setNextState(option)
    }
    
    override func showUserControl(value:Bool, son:BNView, point:CGPoint){
        if father == nil {

        }else{
            father!.showUserControl(value, son:son, point:point)
        }
    }
    
    override func updateUserControl(position:CGPoint){
        if father == nil {

        }else{
            father!.updateUserControl(position)
        }
    }
    
    func requestImage(){
        
        if imageRequested { return }
        
        imageRequested = true
        BNAppSharedManager.instance.networkManager.requestImageData(element!.media[0].url!, image: image)
    }
    
    /* Gesture hadlers */
    func handleTap(sender:UITapGestureRecognizer) {
        delegate!.showElementView!(self, position:CGRectMake(0, 0, 0, 0))
    }
    
    func userViewedElement(){
        element!.userViewed  = true
        header!.circleLabel?.animateCircleIn()
    }
    
    func biinit(sender:BNUIButton_BiinIt){
        BNAppSharedManager.instance.biinit(element!._id!, isElement:true)
        header!.updateSocialButtonsForElement(element!)        
        biinItButton!.showDisable()
        animationView!.animate()
    }
    
    func shareit(sender:BNUIButton_ShareIt){
//        BNAppSharedManager.instance.shareit(element!._id!)
        BNAppSharedManager.instance.shareIt(element!._id!, isElement: true)
        element!.userShared = true
        header!.updateSocialButtonsForElement(element!)
    }
    
    func unBiinit(sender:BNUIButton_ShareIt){
        
        UIView.animateWithDuration(0.1, animations: {()->Void in
                self.alpha = 0
            }, completion: {(completed:Bool)->Void in
                self.delegate!.resizeScrollOnRemoved!(self)
                BNAppSharedManager.instance.unBiinit(self.element!.identifier!, isElement:true)
                self.removeFromSuperview()
        })
    }
    
    override func refresh() {
        
        if element!.userBiined {
            header!.updateSocialButtonsForElement(element!)
            biinItButton?.showDisable()
        }
    }
}

@objc protocol ElementMiniView_Delegate:NSObjectProtocol {
    optional func showElementView(view:ElementMiniView, position:CGRect)
    optional func resizeScrollOnRemoved(view:ElementMiniView)
}
