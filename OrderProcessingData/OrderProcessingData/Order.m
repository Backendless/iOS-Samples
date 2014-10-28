//
//  Order.m
//  OrderProcessingData
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

#import "Order.h"
#import "OrderItem.h"
#import "Backendless.h"

@implementation Order

-(void)addOrderItem:(OrderItem *)item {
    
    if (!self.orderItems)
        self.orderItems = [NSMutableArray array];
    
    [self.orderItems addObject:item];
}

-(void)removeOrderItem:(OrderItem *)item {
    
    [self.orderItems removeObject:item];
    
    if (!self.orderItems.count) {
        self.orderItems = nil;
    }
}

-(NSMutableArray *)loadOrderItems {
    
    if (!self.orderItems)
        [backendless.persistenceService load:self relations:@[@"orderItems"]];
    
    return self.orderItems;
}

-(void)freeOrderItems {
    
    if (!self.orderItems)
        return;
    
    [self.orderItems removeAllObjects];
    self.orderItems = nil;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"<Order {%@}> '%@':'%@' -> %@ [%@]", self.objectId, self.name, self.className, self.customer, self.orderItems];
}

@end