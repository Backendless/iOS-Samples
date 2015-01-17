//
//  CachingObject.m
//  backendlessDemos
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2013 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

#import "CachingObject.h"
#import "Backendless.h"
#include <stdlib.h>

@implementation CachingObject

+(CachingObject *)generateRandomObject {
    
    CachingObject *object = [CachingObject new];
    object.name = [backendless randomString:10];
    object.nickname = [backendless randomString:10];
    object.age = @(arc4random()%50);
    return object;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"Name: %@\nNickname: %@\nAge: %@", self.name, self.nickname, self.age];
}

@end
