//
//  Address.swift
//  OrderProcessingSData
//
//  Created by Vyacheslav Vdovichenko on 10/23/14.
//  Copyright (c) 2014 BACKENDLESS.COM. All rights reserved.
//

import Foundation

class Address : NSObject {
    
    var objectId : String?
    var text : String = "Globe"
    var family = [String: AnyObject]()
    
    override init() {
        super.init()
        self.family["___class"] = "FamilyMember"
    }
    
    // description func
    func description() -> NSString {
        return "<Address {\(self.objectId)}> '\(self.text)' {\(self.family)}"
    }
}
