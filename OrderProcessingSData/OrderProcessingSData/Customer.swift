//
//  Customer.swift
//  OrderProcessingSData
/*
* *********************************************************************************************************************
*
*  BACKENDLESS.COM CONFIDENTIAL
*
*  ********************************************************************************************************************
*
*  Copyright 2014 BACKENDLESS.COM. All Rights Reserved.
*
*  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
*  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
*  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
*  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
*  unless prior written permission is obtained from Backendless.com.
*
*  ********************************************************************************************************************
*/

import Foundation

class Customer : NSObject {
    
    var objectId : String?
    var ownerId : String?
    var name : String?
    var user : BackendlessUser?
    var friends : [Customer]?
    
    func addFriend(friend: Customer?) {
        
        if (friend == nil) {
            return
        }
        
        if (friends == nil) {
            friends = [Customer]()
        }
        
        friends?.append(friend!)
    }
    
    // description func
    func description() -> NSString {
        return "<Customer {\(self.objectId)}> '\(self.name)' {\(self.ownerId)} \(self.user) [\(self.friends)]"
    }
}
