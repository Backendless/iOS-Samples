//
//  Customer.swift
//  PersistanceService
//
//  Created by Vyacheslav Vdovichenko on 10/17/14.
//  Copyright (c) 2014 BACKENDLESS.COM. All rights reserved.
//

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
