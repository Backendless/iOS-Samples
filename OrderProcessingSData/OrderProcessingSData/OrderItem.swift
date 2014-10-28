//
//  OrderItem.swift
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

class OrderItem  : NSObject {
    
    var objectId : String?
    var ownerId : String?
    var itemName : String?
    var unitPrice : String = ""
    var quantity = 0;
    
    // description func
    func description() -> NSString {
        return "<OrderItem {\(self.objectId)}> \(self.itemName) [\(self.quantity)\(self.unitPrice)] {\(self.ownerId)} "
    }
}
