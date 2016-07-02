//  MenuView.swift
//  Biin
//  Created by Esteban Padilla on 7/21/14.
//  Copyright (c) 2014 Biin. All rights reserved.

import Foundation
import UIKit

class MenuView:UIView {
    
    var delegate:MenuViewDelegate?
    var isMenuHidden = true
    
    var profileBtn:BNUIButton_Menu?
    var homeBtn:BNUIButton_Menu?
    var collectionsBtn:BNUIButton_Menu?
    var loyaltyBtn:BNUIButton_Menu?
    var notificationsBtn:BNUIButton_Menu?
    var inviteFriendsBtn:BNUIButton_Menu?
    var settingsBtn:BNUIButton_Menu?
    var searchBtn:BNUIButton_Menu?
    var aboutBtn:BNUIButton_Menu?
    
    var developmentBtn:BNUIButton_Menu?
    
    var buttons = Array<BNUIButton_Menu>()

//    override init() {
//        super.init()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.darkGrayColor()
//        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        var ypos:CGFloat = 10
        let distance:CGFloat = 10
        let buttonHeight:CGFloat = 50
        let buttonWidth:CGFloat = 160

        /*
        Profile = "Profile";
        Home = "Inicio";
        Collections = "Collecciones";
        Loyalty = "Lealtad";
        Notifications = "Notificaciones";
        InviteFriends = "Invitar Amigos";
        Settings = "Ajustes";
        Search = "Buscar";
        */
        
        profileBtn = BNUIButton_Menu(frame: CGRectMake(40, ypos, buttonWidth, buttonHeight), text:NSLocalizedString("Profile", comment: "profile button title").uppercaseString, iconType: BNIconType.none)
        profileBtn!.addTarget(self, action: #selector(self.profileBtnActon(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(profileBtn!)
        
//        ypos += (distance + buttonHeight)
//        homeBtn = BNUIButton_Menu(frame: CGRectMake(40, ypos, buttonWidth, 60), text:NSLocalizedString("Home", comment: "home button title").uppercaseString, iconType: BNIconType.none)
//        homeBtn!.addTarget(self, action: "homeBtnActon:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.addSubview(homeBtn!)
//        homeBtn!.showSelected()

        ypos += (distance + buttonHeight)
        collectionsBtn = BNUIButton_Menu(frame: CGRectMake(40, ypos, buttonWidth, buttonHeight), text:NSLocalizedString("Collections", comment: "collections button title").uppercaseString, iconType: BNIconType.none)
        collectionsBtn!.addTarget(self, action: #selector(self.collectionsBtnActon(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(collectionsBtn!)
        //collectionsBtn!.showDisable()
        
        //ypos += (distance + buttonHeight)
        loyaltyBtn = BNUIButton_Menu(frame: CGRectMake(40, ypos, buttonWidth, buttonHeight), text:NSLocalizedString("Loyalty", comment: "loyalty button title").uppercaseString, iconType: BNIconType.none)
        loyaltyBtn!.addTarget(self, action: #selector(self.loyaltyBtnActon(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        //self.addSubview(loyaltyBtn!)

//        ypos += distance
//        notificationsBtn = BNUIButton_Menu(frame: CGRectMake(40, ypos, 100, 60), text:NSLocalizedString("Notifications", comment: "notifications button title"), iconType: BNIconType.notificationMedium)
//        notificationsBtn!.addTarget(self, action: "notificationsBtnActon:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.addSubview(notificationsBtn!)
        
        ypos += (distance + buttonHeight)
        inviteFriendsBtn = BNUIButton_Menu(frame: CGRectMake(40, ypos, buttonWidth, buttonHeight), text:NSLocalizedString("InviteFriends", comment: "invite friends button title").uppercaseString, iconType: BNIconType.none)
        inviteFriendsBtn!.addTarget(self, action: #selector(self.inviteFriendsBtnActon(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(inviteFriendsBtn!)

//        ypos += distance
//        settingsBtn = BNUIButton_Menu(frame: CGRectMake(40, ypos, 100, 60), text:NSLocalizedString("Settings", comment: "settings button title"), iconType: BNIconType.settingsMedium)
//        settingsBtn!.addTarget(self, action: "settingsBtnActon:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.addSubview(settingsBtn!)
//        
//        ypos += distance
//        searchBtn = BNUIButton_Menu(frame: CGRectMake(40, ypos, 100, 60), text:NSLocalizedString("Search", comment: "search button title"), iconType: BNIconType.searchMedium)
//        searchBtn!.addTarget(self, action: "searchBtnActon:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.addSubview(searchBtn!)
        
        if BNAppSharedManager.instance.IS_DEVELOPMENT_BUILD {
            ypos += (distance + buttonHeight)
            developmentBtn = BNUIButton_Menu(frame: CGRectMake(40, ypos, buttonWidth, buttonHeight), text:"DEVELOPMENT", iconType: BNIconType.none)
            developmentBtn!.addTarget(self, action: #selector(self.developmentBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(developmentBtn!)
        }
        
        aboutBtn = BNUIButton_Menu(frame: CGRectMake(40, (SharedUIManager.instance.screenHeight - 80), buttonWidth, buttonHeight), text:NSLocalizedString("About", comment: "About").uppercaseString, iconType: BNIconType.none)
        aboutBtn!.addTarget(self, action: #selector(self.aboutBtnActon(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(aboutBtn!)
        
        
        buttons.append(profileBtn!)
        //buttons.append(homeBtn!)
        buttons.append(collectionsBtn!)
        buttons.append(loyaltyBtn!)
//        buttons.append(notificationsBtn!)
        buttons.append(inviteFriendsBtn!)
//        buttons.append(settingsBtn!)
//        buttons.append(searchBtn!)
        
        //TODO:Disable buttons for version 0.1.8
        //loyaltyBtn!.enabled = false
        //notificationsBtn!.enabled = false
//        inviteFriendsBtn!.enabled = false
        //settingsBtn!.enabled = false
        //searchBtn!.enabled = false
        
        //loyaltyBtn!.showDisable()
        //notificationsBtn!.showDisable()
        inviteFriendsBtn!.showEnable()
        //settingsBtn!.showDisable()
        //searchBtn!.showDisable()
    }
    
    func profileBtnActon(sender:BNUIButton) {
        //disableButton(0)
        delegate!.menuView!(self, showProfile: true)
    }
    
    func homeBtnActon(sender:BNUIButton) {
        //disableButton(1)
        delegate!.menuView!(self, showHome: true)
    }
    
    func collectionsBtnActon(sender:BNUIButton) {
        //disableButton(2)
        delegate!.menuView!(self, showCollections: true)
    }
    
    func loyaltyBtnActon(sender:BNUIButton) {
        //disableButton(3)
        delegate!.menuView!(self, showLoyalty: true)
    }

    func developmentBtnAction(sender:BNUIButton) {
        delegate!.menuView!(self, showDevelopmentView: true)
    }
    
    func notificationsBtnActon(sender:BNUIButton) {
        //disableButton(4)
        //delegate!.menuView!(self, showNotifications: true)
    }
    
    func inviteFriendsBtnActon(sender:BNUIButton) {
        //disableButton(5)
        delegate!.menuView!(self, showInviteFriends: true)
    }

    func settingsBtnActon(sender:BNUIButton) {
        //disableButton(6)
        //delegate!.menuView!(self, showSettings: true)
    }
    
    func searchBtnActon(sender:BNUIButton) {
        //disableButton(7)
        //delegate!.menuView!(self, showSearch: true)
    }
    
    func aboutBtnActon(sender:BNUIButton ) {
        delegate!.menuView!(self, showAbout: true)
    }

    func disableButton(index:Int) {
//        for var i = 0; i < buttons.count; i++ {
//            if i == index {
//                buttons[i].showSelected()
//                buttons[i].enabled = false
//            } else {
//
//                buttons[i].showEnable()
//                buttons[i].enabled = true
//
//            }
//        }
    }
}

@objc protocol MenuViewDelegate:NSObjectProtocol {
    optional func menuView(menuView:MenuView!, showHome value:Bool)
    optional func menuView(menuView:MenuView!, showProfile value:Bool)
    optional func menuView(menuView:MenuView!, showCollections value:Bool)
    optional func menuView(menuView:MenuView!, showLoyalty value:Bool)
    optional func menuView(menuView:MenuView!, showNotifications value:Bool)
    optional func menuView(menuView:MenuView!, showInviteFriends value:Bool)
    optional func menuView(menuView:MenuView!, showSettings value:Bool)
    optional func menuView(menuView:MenuView!, showSearch value:Bool)
    optional func menuView(menuView:MenuView!, showAbout value:Bool)
    optional func menuView(menuView:MenuView!, showDevelopmentView value:Bool)
}