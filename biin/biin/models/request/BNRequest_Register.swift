//  BNRequest_Register.swift
//  biin
//  Created by Alison Padilla on 9/3/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation

class BNRequest_Register: BNRequest {

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
        self.requestType = BNRequestType.Register
        self.errorManager = errorManager
        self.networkManager = networkManager
        
    }
    
    override func run() {
        
        println("BNRequest_Register.run()")
        isRunning = true

        var response:BNResponse?

        self.networkManager!.epsNetwork!.getJson(false, url: requestString, callback: {
            (data: Dictionary<String, AnyObject>, error: NSError?) -> Void in
            
            if (error != nil) {
                self.networkManager!.handleFailedRequest(self, error: error )
                response = BNResponse(code:10, type: BNResponse_Type.Suck)
            } else {
                
                if let registerData = data["data"] as? NSDictionary {
                    
                    var status = BNParser.findInt("status", dictionary: data)
                    var result = BNParser.findBool("result", dictionary: data)
                    var identifier = BNParser.findString("identifier", dictionary: registerData)
                    
                    if result {
                        response = BNResponse(code:status!, type: BNResponse_Type.Cool)
                        self.networkManager!.delegateDM!.manager!(self.networkManager!, didReceivedUserIdentifier: identifier)
                        
                    } else {
                        response = BNResponse(code:status!, type: BNResponse_Type.Suck)
                        println("*** Register for user \(self.requestString) SUCK!")
                    }
                    
                    self.networkManager!.delegateVC!.manager!(self.networkManager!, didReceivedRegisterConfirmation: response)
                }
                
                self.inCompleted = true
                self.networkManager!.removeFromQueue(self)
            }
        })
    }
}