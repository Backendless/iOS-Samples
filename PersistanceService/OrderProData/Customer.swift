//
//  Customer.swift
//  PersistanceService
//
//  Created by Vyacheslav Vdovichenko on 10/17/14.
//  Copyright (c) 2014 BACKENDLESS.COM. All rights reserved.
//

import Foundation

class Customer : BackendlessEntity {
    
    var ownerId : String?
    var name : String = "Default"
    var user : BackendlessUser?
    var friends : [Customer] = []
    
    // description func
    func description() -> NSString {
        return "<Customer> \(self.name) {\(self.ownerId)}"
    }
}
