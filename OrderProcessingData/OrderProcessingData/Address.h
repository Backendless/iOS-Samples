//
//  Address.h
//  OrderProcessingData
//
//  Created by Vyacheslav Vdovichenko on 10/23/14.
//  Copyright (c) 2014 BACKENDLESS.COM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong, readonly) NSMutableDictionary *family;
@end
