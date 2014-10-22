//
//  PersistentObject.swift
//  PersistenceService
//
//  Created by Vyacheslav Vdovichenko on 8/7/14.
//  Copyright (c) 2014 backendless.com. All rights reserved.
//

import Foundation

struct Persist {

}

class Weather : BackendlessEntity {
    
    var temperature = 24.7
    var condition = "Very Nice"
    
    // description func
    func description() -> NSString {
        return "<Weather> " + condition + ":" + temperature.description
    }
    
}

class PersistentObjectQB : NSObject {
    
    var title = "PersistentObjectQB"
    var nik = "la-la-la-la"
    var count = 70
    var part = 17.7
    var today : NSDate = NSDate()
    
    // one-to-one relationship
    var weather : Weather = Weather()
    // one-to-many relationship
    var companies = [Weather(), Weather(), Weather()]
    
    // description func
    func description() -> NSString {
        return  "<PersistentObjectQB> \(title)/\(nik) count = \(count) part = \(part) date = \(today)"
    }
}


class OrderItem : BackendlessEntity {
    
    var ownerId : String?
    var itemName : String?
    var unitPrice : String?
    var quantity = 0;
}


class Customer : BackendlessEntity {
    
    var ownerId : String?
    var name : String?
    var user : BackendlessUser?
    var friends : [Customer]?
}


class Order : BackendlessEntity {
    
    var name : String?
    var className : String?
    var ownerId : String?
    var customer : Customer?
}


