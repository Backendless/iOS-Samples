//
//  PersistentObject.swift
//  PersistenceService
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

struct Persist {

}

class Weather : BackendlessEntity {
    
    var temperature = 24.7
    var condition = "Very Nice"
    
    // description func
    func description() -> NSString {
        return "<Weather> \(condition):\(temperature)"
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


