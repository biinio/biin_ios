//  GiftsView.swift
//  Biin
//  Created by Esteban Padilla on 7/2/16.
//  Copyright © 2016 Esteban Padilla. All rights reserved.

import Foundation
import UIKit

class GiftsView: BNView, GiftView_Delegate {

    var title:UILabel?
    var backBtn:BNUIButton_Back?
    
    var delegate:GiftsView_Delegate?
    //var elementContainers:Array <MainView_Container_Elements>?
    var scroll:BNScroll?
    
    weak var lastViewOpen:GiftView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, father:BNView?) {
        super.init(frame: frame, father:father )
        
        //NSLog("MainViewContainer init()")
        
        self.backgroundColor = UIColor.appBackground()
        
        let screenWidth = SharedUIManager.instance.screenWidth
        let screenHeight = SharedUIManager.instance.screenHeight
        
        var ypos:CGFloat = 27
        title = UILabel(frame: CGRectMake(6, ypos, screenWidth, (SharedUIManager.instance.mainView_TitleSize + 3)))
        title!.font = UIFont(name:"Lato-Black", size:SharedUIManager.instance.mainView_TitleSize)
        let titleText = NSLocalizedString("TresureChest", comment: "TresureChest").uppercaseString
        let attributedString = NSMutableAttributedString(string:titleText)
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(3), range: NSRange(location: 0, length:(titleText.characters.count)))
        title!.attributedText = attributedString
        title!.textColor = UIColor.appTitleColor()
        title!.textAlignment = NSTextAlignment.Center
        self.addSubview(title!)
        
        backBtn = BNUIButton_Back(frame: CGRectMake(5,15, 50, 50))
        backBtn!.addTarget(self, action: #selector(self.backBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(backBtn!)
        
        ypos = SharedUIManager.instance.mainView_HeaderSize
        self.scroll = BNScroll(frame: CGRectMake(0, ypos, screenWidth, (screenHeight - (SharedUIManager.instance.mainView_HeaderSize + SharedUIManager.instance.mainView_StatusBarHeight))), father: self, direction: BNScroll_Direction.VERTICAL, space: 2, extraSpace: 0, color: UIColor.appBackground(), delegate: nil)
        self.addSubview(scroll!)
        
        //elementContainers = Array<MainView_Container_Elements>()
        updateGifts()
    }
    
    func updateGifts(){
        
        self.scroll!.clean()
        self.scroll!.leftSpace = 0
        
        if let biinie = BNAppSharedManager.instance.dataManager.biinie {
            for gift in biinie.gifts {
                let giftView = GiftView(frame: CGRectMake(0, 0, SharedUIManager.instance.screenWidth, SharedUIManager.instance.giftView_height) , father: self, gift: gift)
                giftView.delegate = self
                scroll!.addChild(giftView)
            }
        }
        
        self.scroll!.setChildrenPosition()
    }
    
    override func transitionIn() {
        
        UIView.animateWithDuration(0.25, animations: {()->Void in
            self.frame.origin.x = 0
        })
    }
    
    override func transitionOut( state:BNState? ) {
        state!.action()
        
        //        if state!.stateType == BNStateType.MainViewContainerState
        //            || state!.stateType == BNStateType.SiteState {
        
        UIView.animateWithDuration(0.25, animations: {()-> Void in
            self.frame.origin.x = SharedUIManager.instance.screenWidth
        })
        //        } else {
        
        //            NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.hideView(_:)), userInfo: nil, repeats: false)
        //        }
    }
    
    override func setNextState(goto:BNGoto){
        father!.setNextState(goto)
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
    
    override func refresh() { }

    override func clean(){

        scroll!.removeFromSuperview()
        fade!.removeFromSuperview()
    }
    
    func backBtnAction(sender:UIButton) {
        
        delegate!.hideGiftsView!()
        
        if lastViewOpen != nil {
            lastViewOpen!.hideRemoveBtn(UISwipeGestureRecognizer())
        }
        
        BNAppSharedManager.instance.dataManager.biinie!.viewedAllGifts()
        BNAppSharedManager.instance.updateGiftCounter()

    }
    
    func resizeScrollOnRemoved(view: GiftView) {
        self.scroll!.removeChildByIdentifier(view.model!.identifier!)
    }
    
    func updateGifts(siteIdentifier:String?){
        for giftView in self.scroll!.children {
            if let gift = (giftView as! GiftView).model {
                for site in (gift as! BNGift).sites! {
                    if site == siteIdentifier {
                        //Send local notification
                        (giftView as! GiftView).updateToClaimNow()
                        break
                    }
                    //else {
                      //  (giftView as! GiftView).updateActionBtnStatus()
                    //}
                }
            }
        }
    }
    
    func hideOtherViewsOpen(view: GiftView) {
        
        if lastViewOpen != nil {
            lastViewOpen!.hideRemoveBtn(UISwipeGestureRecognizer())
        }
        
        lastViewOpen = view
    }
    
    func removeFromOtherViewsOpen(view: GiftView) {
        lastViewOpen = nil
    }
}


@objc protocol GiftsView_Delegate:NSObjectProtocol {
    optional func hideGiftsView()
}