//
//  Person.h
//  CustomService
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

@interface Address : NSObject
@property (strong, nonatomic) NSString *streetAddress;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *zipCode;
@end

@interface Job : NSObject
@property (strong, nonatomic) NSString *title;
@property int salary;
@end

@interface Person : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *borned;
@property (strong, nonatomic) Address *address;
@property (strong, nonatomic) Person *parent;
@property (strong, nonatomic) NSArray *jobs;
@property int ade;
@end
