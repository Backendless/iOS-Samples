//
//  Order.h
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

#import <Foundation/Foundation.h>

@class Customer, OrderItem;

@interface Order :  NSObject
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSMutableArray *orderItems;
@property (nonatomic, strong) Customer *customer;

-(void)addOrderItem:(OrderItem *)item;
-(void)removeOrderItem:(OrderItem *)item;
-(NSMutableArray *)loadOrderItems;
-(void)freeOrderItems;
@end