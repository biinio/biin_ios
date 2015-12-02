//  BNRequest_ElementsForShowcase.swift
//  biin
//  Created by Esteban Padilla on 11/19/15.
//  Copyright © 2015 Esteban Padilla. All rights reserved.

import Foundation
import UIKit

class BNRequest_ElementsForShowcase: BNRequest {

    override init(){
        super.init()
    }
    
    deinit{
        
    }
    
    convenience init(requestString:String, errorManager:BNErrorManager, networkManager:BNNetworkManager, showcase:BNShowcase?, user:Biinie?, view:BNView?) {
        
        self.init()
        self.identifier = BNRequestData.requestCounter++
        self.requestString = requestString
        self.dataIdentifier = ""
        self.requestType = BNRequestType.ElementsForShowcase
        self.errorManager = errorManager
        self.networkManager = networkManager
        self.user  = user
        self.showcase = showcase
        self.view = view
    }
    
    override func run() {
        
        self.start = NSDate()
        
        isRunning = true
        requestAttemps++
        
        self.networkManager!.epsNetwork!.getJson(self.identifier, url: self.requestString, callback:{
            (data: Dictionary<String, AnyObject>, error: NSError?) -> Void in
            if (error != nil) {
                
                self.networkManager!.handleFailedRequest(self, error: error)
            } else {
                
                if let elementsData = data["data"] as? NSDictionary {
                    
                    //var status = BNParser.findInt("status", dictionary: data)
                    let result = BNParser.findBool("result", dictionary: data)
                    
                    if result {
                        
                        //Parse showcase element list.
//                        
//                        self.showcase!.identifier = BNParser.findString("identifier", dictionary: showcaseData)
//                        self.showcase!.lastUpdate = BNParser.findNSDate("lastUpdate", dictionary: showcaseData)
//                        self.showcase!.title = BNParser.findString("title", dictionary: showcaseData)
//                        self.showcase!.subTitle = BNParser.findString("subTitle", dictionary: showcaseData)
//                        self.showcase!.elements_quantity = BNParser.findInt("elements_quantity", dictionary: showcaseData)!
//                        
                        let elements = BNParser.findNSArray("elements", dictionary: elementsData)
                        
                        for var i = 0; i < elements?.count; i++ {
                            
                            let elementData:NSDictionary = elements!.objectAtIndex(i) as! NSDictionary
                            
                            let element = BNElement()
                            element.isDownloadCompleted = true
                            element.identifier = BNParser.findString("identifier", dictionary: elementData)
                            element._id = BNParser.findString("_id", dictionary: elementData)
                            print("add element to showcase: \(element._id!)")
                            element.title = BNParser.findString("title", dictionary: elementData)
                            element.subTitle = BNParser.findString("subTitle", dictionary: elementData)
                            element.currency = BNParser.findCurrency("currencyType", dictionary: elementData)
                            element.detailsHtml = BNParser.findString("detailsHtml", dictionary: elementData)
                            
                            element.hasCallToAction = BNParser.findBool("hasCallToAction", dictionary: elementData)
                            if element.hasCallToAction {
                                element.callToActionURL = BNParser.findString("callToActionURL", dictionary: elementData)
                                element.callToActionTitle = BNParser.findString("callToActionTitle", dictionary: elementData)
                            }
                            
                            element.hasFromPrice = BNParser.findBool("hasFromPrice", dictionary: elementData)
                            if element.hasFromPrice {
                                element.fromPrice = BNParser.findString("fromPrice", dictionary: elementData)
                            }
                            
                            element.hasListPrice = BNParser.findBool("hasListPrice", dictionary: elementData)
                            if element.hasListPrice {
                                element.listPrice = BNParser.findString("listPrice", dictionary: elementData)
                            }
                            
                            element.hasDiscount = BNParser.findBool("hasDiscount", dictionary: elementData)
                            if element.hasDiscount {
                                element.discount = BNParser.findString("discount", dictionary: elementData)
                            }
                            
                            element.hasPrice = BNParser.findBool("hasPrice", dictionary: elementData)
                            if element.hasPrice {
                                element.price = BNParser.findString("price", dictionary: elementData)
                            }
                            
                            element.hasSaving = BNParser.findBool("hasSaving", dictionary: elementData)
                            if element.hasSaving {
                                element.savings = BNParser.findString("savings", dictionary: elementData)
                            }
                            
                            element.hasTimming = BNParser.findBool("hasTimming", dictionary: elementData)
                            if element.hasTimming {
                                element.initialDate = BNParser.findNSDate("initialDate", dictionary: elementData)
                                element.expirationDate = BNParser.findNSDate("expirationDate", dictionary: elementData)
                            }
                            
                            element.hasQuantity = BNParser.findBool("hasQuantity", dictionary: elementData)
                            if element.hasQuantity {
                                element.quantity = BNParser.findString("quantity", dictionary: elementData)
                                element.reservedQuantity = BNParser.findString("reservedQuantity", dictionary: elementData)
                                element.claimedQuantity = BNParser.findString("claimedQuantity", dictionary: elementData)
                                element.actualQuantity = BNParser.findString("actualQuantity", dictionary: elementData)
                            }
                            
                            element.isHighlight = BNParser.findBool("isHighlight", dictionary: elementData)
                            
                            let mediaArray = BNParser.findNSArray("media", dictionary: elementData)
                            
                            for var j = 0; j < mediaArray?.count; j++ {
                                let mediaData = mediaArray!.objectAtIndex(j) as! NSDictionary
                                let url = BNParser.findString("url", dictionary: mediaData)!
                                let type = BNParser.findMediaType("mediaType", dictionary: mediaData)
                                let vibrantColor = BNParser.findUIColor("vibrantColor", dictionary: mediaData)!
                                let vibrantDarkColor = BNParser.findUIColor("vibrantDarkColor", dictionary: mediaData)!
                                let vibrantLightColor = BNParser.findUIColor("vibrantLightColor", dictionary: mediaData)!
                                
                                var white:CGFloat = 0.0
                                var alpha:CGFloat = 0.0
                                _ = vibrantColor.getWhite(&white, alpha: &alpha)
                                
                                if white <= 0.7 {
                                    element.useWhiteText = true
                                    
                                }
                                
                                let media = BNMedia(mediaType: type, url:url, vibrantColor: vibrantColor, vibrantDarkColor: vibrantDarkColor, vibrantLightColor:vibrantLightColor)
                                element.media.append(media)
                            }
                            
                            let categories = BNParser.findNSArray("categories", dictionary: elementData)
                            
                            for var j = 0; j < categories?.count; j++ {
                                let categoryData = categories!.objectAtIndex(j) as! NSDictionary
                                let identifier = BNParser.findString("identifier", dictionary: categoryData)!
                                BNAppSharedManager.instance.dataManager.addElementToCategory(identifier, element:element)
                            }
                            
                            element.collectCount = BNParser.findInt("collectCount", dictionary: elementData)!
                            element.userCollected = BNParser.findBool("userCollected", dictionary: elementData)
                            element.userLiked = BNParser.findBool("userLiked", dictionary: elementData)
                            element.userShared = BNParser.findBool("userShared", dictionary: elementData)
                            element.userViewed = BNParser.findBool("userViewed", dictionary: elementData)
                            
                            element.showcase = self.showcase
                            self.showcase!.elements.append(element)
                            
                            BNAppSharedManager.instance
                            BNAppSharedManager.instance.dataManager.receivedElement(element)
                        }
                        
                        BNAppSharedManager.instance.dataManager.receivedShowcase(self.showcase!)
                        //self.networkManager!.delegateDM!.manager!(self.networkManager!, didReceivedShowcase: self.showcase!)
                        
                    }
                }
                
                let end = NSDate()
                let timeInterval: Double = end.timeIntervalSinceDate(self.start!)
                print("BNRequest_ElementsForShowcase [\(timeInterval)] - \(self.requestString)")
                
                
                self.view!.requestCompleted()
                self.inCompleted = true
                self.networkManager!.removeFromQueue(self)
            }
        })
    }
}
