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
#pragma mark Public Methods

-(void)noArgMethod:(Fault **)fault {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"noArgMethod" args:@[] fault:fault];
}

-(void)noArgMethod:(void(^)(void))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"noArgMethodAsync" args:@[]
                             response:^(id data) { responseBlock(); } error:errorBlock];
}

// primitive args

-(BOOL)echoBoolean:(BOOL)b error:(Fault **)fault {
    return (BOOL)[(NSNumber *)[backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoBoolean" args:@[@(b)] fault:fault] boolValue];
}

-(void)echoBoolean:(BOOL)b response:(void(^)(BOOL))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoBooleanAsync" args:@[@(b)]
                             response:^(NSNumber *data) { responseBlock((BOOL)[data boolValue]); } error:errorBlock];
}

-(char)echoChar:(char)c error:(Fault **)fault {
    return (char)[(NSNumber *)[backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoChar" args:@[@(c)] fault:fault] charValue];
}

-(void)echoChar:(char)c response:(void(^)(char))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoCharAsync" args:@[@(c)]
                             response:^(NSNumber *data) { responseBlock((char)[data charValue]); } error:errorBlock];
}

-(Byte)echoByte:(Byte)d error:(Fault **)fault {
    return (Byte)[(NSNumber *)[backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoByte" args:@[@(d)] fault:fault] charValue];
}

-(void)echoByte:(Byte)d response:(void(^)(Byte))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoByteAsync" args:@[@(d)]
                             response:^(NSNumber *data) { responseBlock((Byte)[data charValue]); } error:errorBlock];
}

-(short)echoShort:(short)d error:(Fault **)fault {
    return (short)[(NSNumber *)[backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoShort" args:@[@(d)] fault:fault] shortValue];
}

-(void)echoShort:(short)d response:(void(^)(short))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoShortAsync" args:@[@(d)]
                             response:^(NSNumber *data) { responseBlock((short)[data shortValue]); } error:errorBlock];
}

-(int)echoInt:(int)d error:(Fault **)fault {
    return (int)[(NSNumber *)[backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoInt" args:@[@(d)] fault:fault] intValue];
}

-(void)echoInt:(int)d response:(void(^)(int))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoIntAsync" args:@[@(d)]
                             response:^(NSNumber *data) { responseBlock((int)[data intValue]); } error:errorBlock];
}

-(long)echoLong:(long)d error:(Fault **)fault {
    return (long)[(NSNumber *)[backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoLong" args:@[@(d)] fault:fault] longValue];
}

-(void)echoLong:(long)d response:(void(^)(long))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoLongAsync" args:@[@(d)]
                             response:^(NSNumber *data) { responseBlock((long)[data longValue]); } error:errorBlock];
}

-(float)echoFloat:(float)d error:(Fault **)fault {
    return (float)[(NSNumber *)[backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoFloat" args:@[@(d)] fault:fault] floatValue];
}

-(void)echoFloat:(float)d response:(void(^)(float))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoFloatAsync" args:@[@(d)]
                             response:^(NSNumber *data) { responseBlock((float)[data floatValue]); } error:errorBlock];
}

-(double)echoDouble:(double)d error:(Fault **)fault {
    return (double)[(NSNumber *)[backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoDouble" args:@[@(d)] fault:fault] doubleValue];
}

-(void)echoDouble:(double)d response:(void(^)(double))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoDoubleAsync" args:@[@(d)]
                             response:^(NSNumber *data) { responseBlock((double)[data doubleValue]); } error:errorBlock];
}

// wrapper args

-(NSNumber *)echoBooleanWrapper:(NSNumber *)b error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoBooleanWrapper" args:@[b] fault:fault];
}

-(void)echoBooleanWrapper:(NSNumber *)b response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoBooleanWrapperAsync" args:@[b] response:responseBlock error:errorBlock];
}

-(NSNumber *)echoCharWrapper:(NSNumber *)c error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoCharWrapper" args:@[c] fault:fault];
}

-(void)echoCharWrapper:(NSNumber *)c response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoCharWrapperAsync" args:@[c] response:responseBlock error:errorBlock];
}

-(NSNumber *)echoByteWrapper:(NSNumber *)d error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoByteWrapper" args:@[d] fault:fault];
}

-(void)echoByteWrapper:(NSNumber *)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoByteWrapperAsync" args:@[d] response:responseBlock error:errorBlock];
}

-(NSNumber *)echoShortWrapper:(NSNumber *)d error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoShortWrapper" args:@[d] fault:fault];
}

-(void)echoShortWrapper:(NSNumber *)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoShortWrapperAsync" args:@[d] response:responseBlock error:errorBlock];
}

-(NSNumber *)echoIntWrapper:(NSNumber *)d error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoIntWrapper" args:@[d] fault:fault];
}

-(void)echoIntWrapper:(NSNumber *)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoIntAsyncWrapper" args:@[d] response:responseBlock error:errorBlock];
}

-(NSNumber *)echoLongWrapper:(NSNumber *)d error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoLongWrapper" args:@[d] fault:fault];
}

-(void)echoLongWrapper:(NSNumber *)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoLongWrapperAsync" args:@[d] response:responseBlock error:errorBlock];
}

-(NSNumber *)echoFloatWrapper:(NSNumber *)d error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoFloatWrapper" args:@[d] fault:fault];
}

-(void)echoFloatWrapper:(NSNumber *)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoFloatWrapperAsync" args:@[d] response:responseBlock error:errorBlock];
}

-(NSNumber *)echoDoubleWrapper:(NSNumber *)d error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoDoubleWrapper" args:@[d] fault:fault];
}

-(void)echoDoubleWrapper:(NSNumber *)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoDoubleWrapperAsync" args:@[d] response:responseBlock error:errorBlock];
}

// strings

-(NSString *)echoString:(NSString *)s error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoString" args:@[s] fault:fault];
}

-(void)echoString:(NSString *)s response:(void(^)(NSString *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoStringAsync" args:@[s] response:responseBlock error:errorBlock];
}

-(NSMutableString *)echoStringBuffer:(NSMutableString *)s error:(Fault **)fault {
    NSString *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoStringBuffer" args:@[s] fault:fault];
    return result ? [NSMutableString stringWithString:result] : nil;
}

-(void)echoStringBuffer:(NSMutableString *)s response:(void(^)(NSMutableString *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoStringBufferAsync" args:@[s]
                             response:^(NSString *result) { responseBlock([NSMutableString stringWithString:result]); } error:errorBlock];
}

-(char*)echoCharArray:(char*)s length:(uint)length error:(Fault **)fault {
    NSData *data = [NSData dataWithBytes:s length:length*sizeof(char)];
    NSData *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoCharArray" args:@[data] fault:fault];
    return result ? (char *)result.bytes : nil;
}

-(void)echoCharArray:(char*)s length:(uint)length response:(void(^)(char*))responseBlock error:(void(^)(Fault *))errorBlock {
    NSData *data = [NSData dataWithBytes:s length:length*sizeof(char)];
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoCharArrayAsync" args:@[data]
                             response:^(NSData *data) { responseBlock((char *)data.bytes); } error:errorBlock];
}

// date

-(NSDate *)echoDate:(NSDate *)d error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoDate" args:@[d] fault:fault];
}

-(void)echoDate:(NSDate *)d response:(void(^)(NSDate *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoDateAsync" args:@[d] response:responseBlock error:errorBlock];
}

// primitive arrays

-(BOOL*)echoBooleanArray:(BOOL*)a length:(uint)length error:(Fault **)fault {
    NSData *data = [NSData dataWithBytes:a length:length*sizeof(BOOL)];
    NSData *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoBooleanArray" args:@[data] fault:fault];
    return result ? (BOOL*)result.bytes : nil;
}

-(void)echoBooleanArray:(BOOL*)a length:(uint)length response:(void(^)(BOOL*))responseBlock error:(void(^)(Fault *))errorBlock {
    NSData *data = [NSData dataWithBytes:a length:length*sizeof(BOOL)];
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoBooleanArrayAsync" args:@[data]
                             response:^(NSData *data) { responseBlock((BOOL*)data.bytes); } error:errorBlock];
}

-(Byte*)echoByteArray:(Byte*)a length:(uint)length error:(Fault **)fault {
    NSData *data = [NSData dataWithBytes:a length:length*sizeof(Byte)];
    NSData *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoByteArray" args:@[data] fault:fault];
    return result ? (Byte*)result.bytes : nil;
}

-(void)echoByteArray:(Byte*)a length:(uint)length response:(void(^)(Byte*))responseBlock error:(void(^)(Fault *))errorBlock {
    NSData *data = [NSData dataWithBytes:a length:length*sizeof(Byte)];
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoByteArrayAsync" args:@[data]
                             response:^(NSData *data) { responseBlock((Byte*)data.bytes); } error:errorBlock];
}

-(short*)echoShortArray:(short*)a length:(uint)length error:(Fault **)fault {
    NSData *data = [NSData dataWithBytes:a length:length*sizeof(short)];
    NSData *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoShortArray" args:@[data] fault:fault];
    return result ? (short*)result.bytes : nil;
}

-(void)echoShortArray:(short*)a length:(uint)length response:(void(^)(short*))responseBlock error:(void(^)(Fault *))errorBlock {
    NSData *data = [NSData dataWithBytes:a length:length*sizeof(short)];
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoShortArrayAsync" args:@[data]
                             response:^(NSData *data) { responseBlock((short*)data.bytes); } error:errorBlock];
}

-(int*)echoIntArray:(int*)a length:(uint)length error:(Fault **)fault {
    NSData *data = [NSData dataWithBytes:a length:length*sizeof(int)];
    NSData *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoIntArray" args:@[data] fault:fault];
    return result ? (int*)result.bytes : nil;
}

-(void)echoIntArray:(int*)a length:(uint)length response:(void(^)(int*))responseBlock error:(void(^)(Fault *))errorBlock {
    NSData *data = [NSData dataWithBytes:a length:length*sizeof(int)];
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoIntArrayAsync" args:@[data]
                             response:^(NSData *data) { responseBlock((int*)data.bytes); } error:errorBlock];
}

-(long*)echoLongArray:(long*)a length:(uint)length error:(Fault **)fault {
    NSData *data = [NSData dataWithBytes:a length:length*sizeof(long)];
    NSData *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoLongArray" args:@[data] fault:fault];
    return result ? (long*)result.bytes : nil;
}

-(void)echoLongArray:(long*)a length:(uint)length response:(void(^)(long*))responseBlock error:(void(^)(Fault *))errorBlock {
    NSData *data = [NSData dataWithBytes:a length:length*sizeof(long)];
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoLongArrayAsync" args:@[data]
                             response:^(NSData *data) { responseBlock((long*)data.bytes); } error:errorBlock];
}

-(float*)echoFloatArray:(float*)a length:(uint)length error:(Fault **)fault {
    NSData *data = [NSData dataWithBytes:a length:length*sizeof(float)];
    NSData *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoFloatArray" args:@[data] fault:fault];
    return result ? (float*)result.bytes : nil;
}

-(void)echoFloatArray:(float*)a length:(uint)length response:(void(^)(float*))responseBlock error:(void(^)(Fault *))errorBlock {
    NSData *data = [NSData dataWithBytes:a length:length*sizeof(float)];
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoFloatArrayAsync" args:@[data]
                             response:^(NSData *data) { responseBlock((float*)data.bytes); } error:errorBlock];
}

-(double*)echoDoubleArray:(double*)a length:(uint)length error:(Fault **)fault {
    NSData *data = [NSData dataWithBytes:a length:length*sizeof(double)];
    NSData *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoDoubleArray" args:@[data] fault:fault];
    return result ? (double*)result.bytes : nil;
}

-(void)echoDoubleArray:(double*)a length:(uint)length response:(void(^)(double*))responseBlock error:(void(^)(Fault *))errorBlock {
    NSData *data = [NSData dataWithBytes:a length:length*sizeof(double)];
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoDoubleArrayAsync" args:@[data]
                             response:^(NSData *data) { responseBlock((double*)data.bytes); } error:errorBlock];
}

-(void*)echoEmptyArray:(void*)a length:(uint)length error:(Fault **)fault {
    NSData *data = [NSData dataWithBytes:a length:length];
    NSData *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoEmptyArray" args:@[data] fault:fault];
    return result ? (void*)result.bytes : nil;
}

-(void)echoEmptyArray:(void*)a length:(uint)length response:(void(^)(void*))responseBlock error:(void(^)(Fault *))errorBlock {
    NSData *data = [NSData dataWithBytes:a length:length];
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoEmptyArrayAsync" args:@[data]
                             response:^(NSData *data) { responseBlock((void*)data.bytes); } error:errorBlock];
}

-(void*)echoNullArray:(void*)a length:(uint)length error:(Fault **)fault {
    NSData *data = [NSData dataWithBytes:a length:length];
    NSData *result = [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoNullArray" args:@[data] fault:fault];
    return result ? (void*)result.bytes : nil;
}

-(void)echoNullArray:(void*)a length:(uint)length response:(void(^)(void*))responseBlock error:(void(^)(Fault *))errorBlock {
    NSData *data = [NSData dataWithBytes:a length:length];
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoNullArrayAsync" args:@[data]
                             response:^(NSData *data) { responseBlock((void*)data.bytes); } error:errorBlock];
}

// primitive arrays wrapper

-(NSData*)echoData:(NSData*)a error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoByteArray" args:@[a] fault:fault];
}

-(void)echoData:(NSData*)a response:(void(^)(NSData*))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoByteArrayAsync" args:@[a] response:responseBlock error:errorBlock];
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

-(NSArray *)echoArrayList:(NSArray *)a error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoArrayList" args:@[a] fault:fault];
}

-(void)echoArrayList:(NSArray *)a response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoArrayListAsync" args:@[a] response:responseBlock error:errorBlock];
}

-(NSSet *)echoTreeSet:(NSSet *)a error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoTreeSet" args:@[a] fault:fault];
}

-(void)echoTreeSet:(NSSet *)a response:(void(^)(NSSet *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoTreeSetAsync" args:@[a] response:responseBlock error:errorBlock];
}

-(NSDictionary *)echoHashtable:(NSDictionary *)a error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoHashtable" args:@[a] fault:fault];
}

-(void)echoHashtable:(NSDictionary *)a response:(void(^)(NSDictionary *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoHashtableAsync" args:@[a] response:responseBlock error:errorBlock];
}

// collections interfaces

-(NSDictionary *)echoMap:(NSDictionary *)a error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoMap" args:@[a] fault:fault];
}

-(void)echoMap:(NSDictionary *)a response:(void(^)(NSDictionary *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoMapAsync" args:@[a] response:responseBlock error:errorBlock];
}

-(NSArray *)echoList:(NSArray *)a error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoList" args:@[a] fault:fault];
}

-(void)echoList:(NSArray *)a response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoListAsync" args:@[a] response:responseBlock error:errorBlock];
}

-(NSSet *)echoSet:(NSSet *)a error:(Fault **)fault {
    return [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoSet" args:@[a] fault:fault];
}

-(void)echoSet:(NSSet *)a response:(void(^)(NSSet *))responseBlock error:(void(^)(Fault *))errorBlock {
    [backendless.customService invoke:SERVICE_NAME serviceVersion:_serviceVersion method:@"echoSetAsync" args:@[a] response:responseBlock error:errorBlock];
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
