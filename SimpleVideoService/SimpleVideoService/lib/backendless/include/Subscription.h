//
//  Subscription.h
//  backendlessAPI
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2012 BACKENDLESS.COM. All Rights Reserved.
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

@protocol IResponder;

@interface Subscription : NSObject

@property (strong, nonatomic) NSString *subscriptionId;
@property (strong, nonatomic) NSString *channelName;
@property (nonatomic, assign) id <IResponder> responder;

-(id)initWithChannelName:(NSString *)channelName responder:(id <IResponder>)subscriptionResponder;
+(id)subscription:(NSString *)channelName responder:(id <IResponder>)subscriptionResponder;

-(void)cancel;
@end
