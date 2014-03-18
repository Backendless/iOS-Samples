//
//  CachingObject.h
//  backendlessDemos
//
//  Created by Yury Yaschenko on 8/21/13.
//  Copyright (c) 2013 BACKENDLESS.COM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CachingObject : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSNumber *age;
+(CachingObject *)generateRandomObject;
@end
