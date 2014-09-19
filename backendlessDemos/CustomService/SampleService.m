//
//  SampleService.m
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

#import "SampleService.h"

static NSString *SERVICE_NAME = @"SampleService";

@implementation SampleService

#pragma mark -
#pragma mark Private Methods

-(NSString *)wrapperMethod:(NSNumber *)number {
    
    switch ([number objCType][0]) {
        case 'c':
        return @"echoBoolWrapper";
        case 's':
        return @"echoByteWrapper";
        case 'f':
        return @"echoFloatWrapper";
        case 'd':
        return @"echoDoubleWrapper";
        default:
        return @"echoIntWrapper";
    }
}

#pragma mark -
#pragma mark Public Methods

-(void)noArgMethod:(Fault **)fault {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"noArgMethod" args:@[] fault:fault];
}

-(void)noArgMethod:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"noArgMethodAsync" args:@[] response:responseBlock error:errorBlock];
}

// primitive args

-(BOOL)echoBoolean:(BOOL)b error:(Fault **)fault {
    NSNumber *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoBoolean" args:@[@(b)] fault:fault];
    return result ? [result boolValue] : NO;
}

-(void)echoBoolean:(BOOL)b response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoBooleanAsync" args:@[@(b)] response:responseBlock error:errorBlock];
}

-(char)echoChar:(char)c error:(Fault **)fault {
    NSNumber *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoChar" args:@[@(c)] fault:fault];
    return result ? [result charValue] : 0;
}

-(void)echoChar:(char)c response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoCharAsync" args:@[@(c)] response:responseBlock error:errorBlock];
}

-(int8_t)echoByte:(int8_t)d error:(Fault **)fault {
    NSNumber *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoByte" args:@[@(d)] fault:fault];
    return result ? (int8_t)[result charValue] : 0;
}

-(void)echoByte:(int8_t)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoByteAsync" args:@[@(d)] response:responseBlock error:errorBlock];
}

-(short)echoShort:(short)d error:(Fault **)fault {
    NSNumber *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoShort" args:@[@(d)] fault:fault];
    return result ? [result shortValue] : 0;
}

-(void)echoShort:(short)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoShortAsync" args:@[@(d)] response:responseBlock error:errorBlock];
}

-(int)echoInt:(int)d error:(Fault **)fault {
    NSNumber *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoInt" args:@[@(d)] fault:fault];
    return result ? [result intValue] : 0;
}

-(void)echoInt:(int)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoIntAsync" args:@[@(d)] response:responseBlock error:errorBlock];
}

-(long)echoLong:(long)d error:(Fault **)fault {
    NSNumber *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoLong" args:@[@(d)] fault:fault];
    return result ? [result longValue] : 0;
}

-(void)echoLong:(long)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoLongAsync" args:@[@(d)] response:responseBlock error:errorBlock];
}

-(float)echoFloat:(float)d error:(Fault **)fault {
    NSNumber *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoFloat" args:@[@(d)] fault:fault];
    return result ? [result floatValue] : 0;
}

-(void)echoFloat:(float)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoFloatAsync" args:@[@(d)] response:responseBlock error:errorBlock];
}

-(double)echoDouble:(double)d error:(Fault **)fault {
    NSNumber *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoDouble" args:@[@(d)] fault:fault];
    return result ? [result doubleValue] : 0;
}

-(void)echoDouble:(double)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoDoubleAsync" args:@[@(d)] response:responseBlock error:errorBlock];
}

// numbers

-(NSNumber *)echoNumber:(NSNumber *)d error:(Fault **)fault {
    NSString *method = [self wrapperMethod:d];
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:method args:@[d] fault:fault];
}

-(void)echoNumber:(NSNumber *)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    NSString *method = [[self wrapperMethod:d] stringByAppendingString:@"Async"];
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:method args:@[d] response:responseBlock error:errorBlock];
}

// strings

-(NSString *)echoString:(NSString *)s error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoString" args:@[s] fault:fault];
}

-(void)echoString:(NSString *)s response:(void(^)(NSString *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoStringAsync" args:@[s] response:responseBlock error:errorBlock];
}

-(char *)echoCharArray:(char *)s length:(uint)length error:(Fault **)fault {
    NSData *data = [NSData dataWithBytes:s length:length];
    NSData *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoCharArray" args:@[data] fault:fault];
    return result ? (char *)result.bytes : 0;
}

-(void)echoCharArray:(char *)s length:(uint)length response:(void(^)(NSData *))responseBlock error:(void(^)(Fault *))errorBlock {
    NSData *data = [NSData dataWithBytes:s length:length];
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoCharArrayAsync" args:@[data] response:responseBlock error:errorBlock];
}

// date

-(NSDate *)echoDate:(NSDate *)d error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoDate" args:@[d] fault:fault];
}

-(void)echoDate:(NSDate *)d response:(void(^)(NSDate *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoDateAsync" args:@[d] response:responseBlock error:errorBlock];
}

// primitive arrays

-(NSArray *)echoBooleanArray:(BOOL[])a length:(uint)length error:(Fault **)fault {
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        data[i] = @(a[i]);
    }
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoBooleanArray" args:@[data] fault:fault];
}

-(void)echoBooleanArray:(BOOL[])a length:(uint)length response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock {
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        data[i] = @(a[i]);
    }
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoBooleanArrayAsync" args:@[data] response:responseBlock error:errorBlock];
}

-(NSArray *)echoByteArray:(int8_t[])a length:(uint)length error:(Fault **)fault {
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        data[i] = @(a[i]);
    }
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoByteArray" args:@[data] fault:fault];
}

-(void)echoByteArray:(int8_t[])a length:(uint)length response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock {
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        data[i] = @(a[i]);
    }
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoByteArrayAsync" args:@[data] response:responseBlock error:errorBlock];
}

-(NSArray *)echoShortArray:(short[])a length:(uint)length error:(Fault **)fault {
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        data[i] = @(a[i]);
    }
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoShortArray" args:@[data] fault:fault];
}

-(void)echoShortArray:(short[])a length:(uint)length response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock {
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        data[i] = @(a[i]);
    }
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoShortArrayAsync" args:@[data] response:responseBlock error:errorBlock];
}

-(NSArray *)echoIntArray:(int[])a length:(uint)length error:(Fault **)fault {
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        data[i] = @(a[i]);
    }
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoIntArray" args:@[data] fault:fault];
}

-(void)echoIntArray:(int[])a length:(uint)length response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock {
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        data[i] = @(a[i]);
    }
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoIntArrayAsync" args:@[data] response:responseBlock error:errorBlock];
}

-(NSArray *)echoLongArray:(long[])a length:(uint)length error:(Fault **)fault {
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        data[i] = @(a[i]);
    }
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoLongArray" args:@[data] fault:fault];
}

-(void)echoLongArray:(long[])a length:(uint)length response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock {
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        data[i] = @(a[i]);
    }
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoLongArrayAsync" args:@[data] response:responseBlock error:errorBlock];
}

-(NSArray *)echoFloatArray:(float[])a length:(uint)length error:(Fault **)fault {
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        data[i] = @(a[i]);
    }
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoFloatArray" args:@[data] fault:fault];
}

-(void)echoFloatArray:(float[])a length:(uint)length response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock {
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        data[i] = @(a[i]);
    }
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoFloatArrayAsync" args:@[data] response:responseBlock error:errorBlock];
}

-(NSArray *)echoDoubleArray:(double[])a length:(uint)length error:(Fault **)fault {
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        data[i] = @(a[i]);
    }
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoDoubleArray" args:@[data] fault:fault];
}

-(void)echoDoubleArray:(double[])a length:(uint)length response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock {
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        data[i] = @(a[i]);
    }
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoDoubleArrayAsync" args:@[data] response:responseBlock error:errorBlock];
}

-(NSArray *)echoEmptyArray:(int[])a length:(uint)length error:(Fault **)fault {
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        data[i] = @(a[i]);
    }
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoEmptyArray" args:@[data] fault:fault];
}

-(void)echoEmptyArray:(int[])a length:(uint)length response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock {
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        data[i] = @(a[i]);
    }
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoEmptyArrayAsync" args:@[data] response:responseBlock error:errorBlock];
}

-(NSArray *)echoNullArray:(int[])a length:(uint)length error:(Fault **)fault {
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        data[i] = @(a[i]);
    }
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoNullArray" args:@[data] fault:fault];
}

-(void)echoNullArray:(int[])a length:(uint)length response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock {
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        data[i] = @(a[i]);
    }
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoNullArrayAsync" args:@[data] response:responseBlock error:errorBlock];
}

// strings array

-(NSArray *)echoStringArray:(NSArray *)a error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoStringArray" args:@[a] fault:fault];
}

-(void)echoStringArray:(NSArray *)a response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoStringArrayAsync" args:@[a] response:responseBlock error:errorBlock];
}

-(NSArray *)echoNullStringArray:(NSArray *)a error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoNullStringArray" args:@[a] fault:fault];
}

-(void)echoNullStringArray:(NSArray *)a response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoNullStringArrayAsync" args:@[a] response:responseBlock error:errorBlock];
}

-(NSArray *)echoEmptyStringArray:(NSArray *)a error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoEmptyStringArray" args:@[a] fault:fault];
}

-(void)echoEmptyStringArray:(NSArray *)a response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoEmptyStringArrayAsync" args:@[a] response:responseBlock error:errorBlock];
}

// collections

-(NSArray *)echoSortedList:(NSArray *)a error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoSortedList" args:@[a] fault:fault];
}

-(void)echoSortedList:(NSArray *)a response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoSortedListAsync" args:@[a] response:responseBlock error:errorBlock];
}

-(NSSet *)echoArrayList:(NSSet *)a error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoArrayList" args:@[a] fault:fault];
}

-(void)echoArrayList:(NSSet *)a response:(void(^)(NSSet *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoArrayListAsync" args:@[a] response:responseBlock error:errorBlock];
}

-(NSDictionary *)echoHashtable:(NSDictionary *)a error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoHashtable" args:@[a] fault:fault];
}

-(void)echoHashtable:(NSDictionary *)a response:(void(^)(NSDictionary *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoHashtableAsync" args:@[a] response:responseBlock error:errorBlock];
}

// complex type

-(Person *)echoPerson:(Person *)p error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoPerson" args:@[p] fault:fault];
    
}

-(void)echoPerson:(Person *)p response:(void(^)(Person *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoPersonAsync" args:@[p] response:responseBlock error:errorBlock];
}

-(NSArray *)echoPersonArray:(NSArray *)a error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoPersonArray" args:@[a] fault:fault];
}

-(void)echoPersonArray:(NSArray *)a response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoPersonArrayAsync" args:@[a] response:responseBlock error:errorBlock];
}

@end
