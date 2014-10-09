//
//  SampleService.h
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
#import "Backendless.h"
#import "Person.h"

@interface SampleService : NSObject

@property (nonatomic, retain) NSString *serviceVersion;

-(void)noArgMethod:(Fault **)fault;
-(void)noArgMethod:(void(^)(void))responseBlock error:(void(^)(Fault *))errorBlock;

// primitive args
-(BOOL)echoBoolean:(BOOL)b error:(Fault **)fault;
-(void)echoBoolean:(BOOL)b response:(void(^)(BOOL))responseBlock error:(void(^)(Fault *))errorBlock;
-(char)echoChar:(char)c error:(Fault **)fault;
-(void)echoChar:(char)c response:(void(^)(char))responseBlock error:(void(^)(Fault *))errorBlock;
-(Byte)echoByte:(Byte)d error:(Fault **)fault;
-(void)echoByte:(Byte)d response:(void(^)(Byte))responseBlock error:(void(^)(Fault *))errorBlock;
-(short)echoShort:(short)d error:(Fault **)fault;
-(void)echoShort:(short)d response:(void(^)(short))responseBlock error:(void(^)(Fault *))errorBlock;
-(int)echoInt:(int)d error:(Fault **)fault;
-(void)echoInt:(int)d response:(void(^)(int))responseBlock error:(void(^)(Fault *))errorBlock;
-(long)echoLong:(long)d error:(Fault **)fault;
-(void)echoLong:(long)d response:(void(^)(long))responseBlock error:(void(^)(Fault *))errorBlock;
-(float)echoFloat:(float)d error:(Fault **)fault;
-(void)echoFloat:(float)d response:(void(^)(float))responseBlock error:(void(^)(Fault *))errorBlock;
-(double)echoDouble:(double)d error:(Fault **)fault;
-(void)echoDouble:(double)d response:(void(^)(double))responseBlock error:(void(^)(Fault *))errorBlock;

// wrapper args
-(NSNumber *)echoBooleanWrapper:(NSNumber *)b error:(Fault **)fault;
-(void)echoBooleanWrapper:(NSNumber *)b response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSNumber *)echoCharWrapper:(NSNumber *)c error:(Fault **)fault;
-(void)echoCharWrapper:(NSNumber *)c response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSNumber *)echoByteWrapper:(NSNumber *)d error:(Fault **)fault;
-(void)echoByteWrapper:(NSNumber *)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSNumber *)echoShortWrapper:(NSNumber *)d error:(Fault **)fault;
-(void)echoShortWrapper:(NSNumber *)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSNumber *)echoIntWrapper:(NSNumber *)d error:(Fault **)fault;
-(void)echoIntWrapper:(NSNumber *)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSNumber *)echoLongWrapper:(NSNumber *)d error:(Fault **)fault;
-(void)echoLongWrapper:(NSNumber *)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSNumber *)echoFloatWrapper:(NSNumber *)d error:(Fault **)fault;
-(void)echoFloatWrapper:(NSNumber *)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSNumber *)echoDoubleWrapper:(NSNumber *)d error:(Fault **)fault;
-(void)echoDoubleWrapper:(NSNumber *)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;

// strings
-(NSString *)echoString:(NSString *)s error:(Fault **)fault;
-(void)echoString:(NSString *)s response:(void(^)(NSString *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSMutableString *)echoStringBuffer:(NSMutableString *)s error:(Fault **)fault;
-(void)echoStringBuffer:(NSMutableString *)s response:(void(^)(NSMutableString *))responseBlock error:(void(^)(Fault *))errorBlock;
-(char*)echoCharArray:(char*)s length:(uint)length error:(Fault **)fault;
-(void)echoCharArray:(char*)s length:(uint)length response:(void(^)(char*))responseBlock error:(void(^)(Fault *))errorBlock;

// date
-(NSDate *)echoDate:(NSDate *)d error:(Fault **)fault;
-(void)echoDate:(NSDate *)d response:(void(^)(NSDate *))responseBlock error:(void(^)(Fault *))errorBlock;

// primitive arrays
-(BOOL*)echoBooleanArray:(BOOL*)a length:(uint)length error:(Fault **)fault;
-(void)echoBooleanArray:(BOOL*)a length:(uint)length response:(void(^)(BOOL*))responseBlock error:(void(^)(Fault *))errorBlock;
-(Byte*)echoByteArray:(Byte*)a length:(uint)length error:(Fault **)fault;
-(void)echoByteArray:(Byte*)a length:(uint)length response:(void(^)(Byte*))responseBlock error:(void(^)(Fault *))errorBlock;
-(short*)echoShortArray:(short*)a length:(uint)length error:(Fault **)fault;
-(void)echoShortArray:(short*)a length:(uint)length response:(void(^)(short*))responseBlock error:(void(^)(Fault *))errorBlock;
-(int*)echoIntArray:(int*)a length:(uint)length error:(Fault **)fault;
-(void)echoIntArray:(int*)a length:(uint)length response:(void(^)(int*))responseBlock error:(void(^)(Fault *))errorBlock;
-(long*)echoLongArray:(long*)a length:(uint)length error:(Fault **)fault;
-(void)echoLongArray:(long*)a length:(uint)length response:(void(^)(long*))responseBlock error:(void(^)(Fault *))errorBlock;
-(float*)echoFloatArray:(float*)a length:(uint)length error:(Fault **)fault;
-(void)echoFloatArray:(float*)a length:(uint)length response:(void(^)(float*))responseBlock error:(void(^)(Fault *))errorBlock;
-(double*)echoDoubleArray:(double*)a length:(uint)length error:(Fault **)fault;
-(void)echoDoubleArray:(double*)a length:(uint)length response:(void(^)(double*))responseBlock error:(void(^)(Fault *))errorBlock;
-(void*)echoEmptyArray:(void*)a length:(uint)length error:(Fault **)fault;
-(void)echoEmptyArray:(void*)a length:(uint)length response:(void(^)(void*))responseBlock error:(void(^)(Fault *))errorBlock;
-(void*)echoNullArray:(void*)a length:(uint)length error:(Fault **)fault;
-(void)echoNullArray:(void*)a length:(uint)length response:(void(^)(void*))responseBlock error:(void(^)(Fault *))errorBlock;

// primitive arrays wrapper
-(NSData*)echoData:(NSData*)a error:(Fault **)fault;
-(void)echoData:(NSData*)a response:(void(^)(NSData*))responseBlock error:(void(^)(Fault *))errorBlock;

// strings array
-(NSArray *)echoStringArray:(NSArray *)a error:(Fault **)fault;
-(void)echoStringArray:(NSArray *)a response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSArray *)echoNullStringArray:(NSArray *)a error:(Fault **)fault;
-(void)echoNullStringArray:(NSArray *)a response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSArray *)echoEmptyStringArray:(NSArray *)a error:(Fault **)fault;
-(void)echoEmptyStringArray:(NSArray *)a response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock;

// collections
-(NSArray *)echoArrayList:(NSArray *)a error:(Fault **)fault;
-(void)echoArrayList:(NSArray *)a response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSSet *)echoTreeSet:(NSSet *)a error:(Fault **)fault;
-(void)echoTreeSet:(NSSet *)a response:(void(^)(NSSet *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSDictionary *)echoHashtable:(NSDictionary *)a error:(Fault **)fault;
-(void)echoHashtable:(NSDictionary *)a response:(void(^)(NSDictionary *))responseBlock error:(void(^)(Fault *))errorBlock;

// collections interfaces
-(NSDictionary *)echoMap:(NSDictionary *)a error:(Fault **)fault;
-(void)echoMap:(NSDictionary *)a response:(void(^)(NSDictionary *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSArray *)echoList:(NSArray *)a error:(Fault **)fault;
-(void)echoList:(NSArray *)a response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSSet *)echoSet:(NSSet *)a error:(Fault **)fault;
-(void)echoSet:(NSSet *)a response:(void(^)(NSSet *))responseBlock error:(void(^)(Fault *))errorBlock;

// complex type
-(Person *)echoPerson:(Person *)p error:(Fault **)fault;
-(void)echoPerson:(Person *)p response:(void(^)(Person *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSArray *)echoPersonArray:(NSArray *)a error:(Fault **)fault;
-(void)echoPersonArray:(NSArray *)a response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock;

@end
