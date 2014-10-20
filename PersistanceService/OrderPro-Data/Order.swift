//
//  Order.swift
//  PersistanceService
//
//  Created by Vyacheslav Vdovichenko on 10/17/14.
//  Copyright (c) 2014 BACKENDLESS.COM. All rights reserved.
//

import Foundation

class Order : BackendlessEntity {
    
    var name : String?
    var className : String?
    var ownerId : String?
    var customer : Customer?
}
