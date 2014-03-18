//
//  CachingObject.m
//  backendlessDemos
//
//  Created by Yury Yaschenko on 8/21/13.
//  Copyright (c) 2013 BACKENDLESS.COM. All rights reserved.
//

#import "CachingObject.h"
#include <stdlib.h>
@interface CachingObject()
-(NSString *)genRandStringLength:(int)len;
@end
@implementation CachingObject


-(NSString *)genRandStringLength: (int) len
{
    NSString *lowLetters = @"abcdefghijklmnopqrstuvwxyz";
    NSString *highLetters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    [randomString appendFormat: @"%C", [highLetters characterAtIndex: arc4random() % [highLetters length]]];
    for (int i=1; i<len; i++) {
        [randomString appendFormat: @"%C", [lowLetters characterAtIndex: arc4random() % [lowLetters length]]];
    }
    return randomString;
}

+(CachingObject *)generateRandomObject
{
    CachingObject *object = [CachingObject new];
    object.name = [object genRandStringLength:10];
    object.nickname = [object genRandStringLength:10];
    int age = arc4random()%50;
    object.age = [NSNumber numberWithInt:age];
    return object;
}
-(NSString *)description
{
    return [NSString stringWithFormat:
            @"Name: %@ \nNickname: %@ \nAge: %@", self.name, self.nickname, self.age ];
}
@end
