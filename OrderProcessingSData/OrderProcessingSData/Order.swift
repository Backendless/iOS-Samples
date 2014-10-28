//
//  Order.swift
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

class Order  : NSObject {
    
    var objectId : String?
    var name : String?
    var className : String?
    var ownerId : String?
    var customer : Customer?
    var orderItems = [OrderItem]()
    
    // description func
    func description() -> NSString {
        return "<Order {\(self.objectId)}> \(self.name) <\(self.className)> {\(self.ownerId)} -> \(self.customer) [\(self.orderItems)]"
    }
}
