//  BNRequest_Categories.swift
//  biin
//  Created by Alison Padilla on 9/3/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation

class BNRequest_Categories: BNRequest {
    override init(){
        super.init()
    }
    
    deinit{
        
    }
    
    convenience init(requestString:String, errorManager:BNErrorManager, networkManager:BNNetworkManager){
        self.init()
        self.identifier = BNRequestData.requestCounter++
        self.requestString = requestString
        self.dataIdentifier = ""
        self.requestType = BNRequestType.CategoriesData
        self.errorManager = errorManager
        self.networkManager = networkManager
        
    }
    
    override func run() {
        
        println("BNRequest_Categories.run()")
        isRunning = true
        
        self.networkManager!.epsNetwork!.getJson(false, url:self.requestString, callback:{
            (data: Dictionary<String, AnyObject>, error: NSError?) -> Void in
            
            if (error != nil) {
                println("Error on requestUserCategoriesData()")
                self.networkManager!.handleFailedRequest(self, error: error )
            } else {
                
                if let dataData = data["data"] as? NSDictionary {
                    
                    var categories = Array<BNCategory>()
                    var categoriesData = BNParser.findNSArray("categories", dictionary: dataData)
                    
                    for var i = 0; i < categoriesData?.count; i++ {
                        
                        var categoryData = categoriesData!.objectAtIndex(i) as! NSDictionary
                        var category = BNCategory(identifier: BNParser.findString("identifier", dictionary: categoryData)!)
                        
                        category.name = BNParser.findString("name", dictionary: categoryData)
                        category.hasSites = BNParser.findBool("hasSites", dictionary: categoryData)
                        
                        if category.hasSites {
                            var sites = BNParser.findNSArray("sites", dictionary: categoryData)
                            
                            for var j = 0; j < sites?.count; j++ {
                                
                                var siteData = sites!.objectAtIndex(j) as! NSDictionary
                                
                                //TODO: Add site details to category here.
                                var siteDetails = BNCategorySiteDetails()
                                siteDetails.identifier = BNParser.findString("identifier", dictionary: siteData)
                                siteDetails.json = BNParser.findString("jsonUrl", dictionary: siteData)
                                siteDetails.biinieProximity = BNParser.findFloat("biinieProximity", dictionary: siteData)
                                category.sitesDetails.append(siteDetails)
                                
                            }
                        }
                        
                        if category.sitesDetails.count == 0 {
                            println("Category issue")
                        }
                        
                        categories.append(category)
                    }
   
                    self.networkManager!.delegateDM!.manager!(self.networkManager!, didReceivedUserCategories:categories)
                    self.inCompleted = true
                    self.networkManager!.removeFromQueue(self)
                }
            }
        })
    }
}