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

@interface SampleService : NSObject

@property (nonatomic, retain) NSString *serviceVersion;

-(void)noArgMethod:(Fault **)fault;
-(void)noArgMethod:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
// primitive args
-(BOOL)echoBoolean:(BOOL)b error:(Fault **)fault;
-(void)echoBoolean:(BOOL)b response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
-(char)echoChar:(char)c error:(Fault **)fault;
-(void)echoChar:(char)c response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
-(int8_t)echoByte:(int8_t)d error:(Fault **)fault;
-(void)echoByte:(int8_t)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
-(short)echoShort:(short)d error:(Fault **)fault;
-(void)echoShort:(short)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
-(int)echoInt:(int)d error:(Fault **)fault;
-(void)echoInt:(int)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
-(long)echoLong:(long)d error:(Fault **)fault;
-(void)echoLong:(long)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
-(float)echoFloat:(float)d error:(Fault **)fault;
-(void)echoFloat:(float)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
-(double)echoDouble:(double)d error:(Fault **)fault;
-(void)echoDouble:(double)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
// numbers
-(NSNumber *)echoNumber:(NSNumber *)d error:(Fault **)fault;
-(void)echoNumber:(NSNumber *)d response:(void(^)(NSNumber *))responseBlock error:(void(^)(Fault *))errorBlock;
// strings
-(NSString *)echoString:(NSString *)s error:(Fault **)fault;
-(void)echoString:(NSString *)s response:(void(^)(NSString *))responseBlock error:(void(^)(Fault *))errorBlock;
-(char *)echoCharArray:(char *)s length:(uint)length error:(Fault **)fault;
-(void)echoCharArray:(char *)s length:(uint)length response:(void(^)(NSData *))responseBlock error:(void(^)(Fault *))errorBlock;
// date
-(NSDate *)echoDate:(NSDate *)d error:(Fault **)fault;
-(void)echoDate:(NSDate *)d response:(void(^)(NSDate *))responseBlock error:(void(^)(Fault *))errorBlock;
// primitive arrays
-(NSArray *)echoBooleanArray:(BOOL[])a length:(uint)length error:(Fault **)fault;
-(void)echoBooleanArray:(BOOL[])a length:(uint)length response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSArray *)echoByteArray:(int8_t[])a length:(uint)length error:(Fault **)fault;
-(void)echoByteArray:(int8_t[])a length:(uint)length response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSArray *)echoShortArray:(short[])a length:(uint)length error:(Fault **)fault;
-(void)echoShortArray:(short[])a length:(uint)length response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSArray *)echoIntArray:(int[])a length:(uint)length error:(Fault **)fault;
-(void)echoIntArray:(int[])a length:(uint)length response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSArray *)echoLongArray:(long[])a length:(uint)length error:(Fault **)fault;
-(void)echoLongArray:(long[])a length:(uint)length response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSArray *)echoFloatArray:(float[])a length:(uint)length error:(Fault **)fault;
-(void)echoFloatArray:(float[])a length:(uint)length response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSArray *)echoDoubleArray:(double[])a length:(uint)length error:(Fault **)fault;
-(void)echoDoubleArray:(double[])a length:(uint)length response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSArray *)echoEmptyArray:(int[])a length:(uint)length error:(Fault **)fault;
-(void)echoEmptyArray:(int[])a length:(uint)length response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock;
-(NSArray *)echoNullArray:(int[])a length:(uint)length error:(Fault **)fault;
-(void)echoNullArray:(int[])a length:(uint)length response:(void(^)(NSArray *))responseBlock error:(void(^)(Fault *))errorBlock;

@end
