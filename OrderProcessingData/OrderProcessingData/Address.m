//
//  Address.m
//  OrderProcessingData
//
//  Created by Vyacheslav Vdovichenko on 10/23/14.
//  Copyright (c) 2014 BACKENDLESS.COM. All rights reserved.
//

#import "Address.h"
#import "Customer.h"

@implementation Address

-(id)init {
    
    if( (self=[super init] )) {
        _family = [NSMutableDictionary new];
        self.family[@"___class"] = @"FamilyMember";
    }
    
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"<Address {%@}> '%@':%@", self.objectId, self.text, self.family];
}

@end
