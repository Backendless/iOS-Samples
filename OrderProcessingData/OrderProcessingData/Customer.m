//
//  Customer.m
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

#import "Customer.h"
                    
@implementation Customer                    

-(void)addFriend:(Customer *)user {
    
    if (!self.friends)
        self.friends = [NSMutableArray new];
    
    [self.friends addObject:user];
}

-(void)deleteFriend:(Customer *)user {
    
    [self.friends removeObject:user];
    
    if (!self.friends.count) {
        self.friends = nil;
    }
}

-(NSString *)description {
    return [NSString stringWithFormat:@"<Customer {%@}> '%@':{%@} -> %@ [%@]", self.objectId, self.name, self.ownerId, self.user, self.friends];
}

@end