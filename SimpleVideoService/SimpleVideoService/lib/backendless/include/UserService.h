//
//  UserService.h
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

@class BackendlessUser;
@protocol IResponder;

@interface UserService : NSObject

@property (strong, nonatomic, readonly) BackendlessUser *currentUser;

// sync methods
-(BackendlessUser *)registering:(BackendlessUser *)user;
-(BackendlessUser *)update:(BackendlessUser *)user;
-(BackendlessUser *)login:(NSString *)login password:(NSString *)password;
-(id)logout;
-(id)restorePassword:(NSString *)login;
-(NSArray *)describeUserClass;
-(id)user:(NSString *)user assignRole:(NSString *)role;
-(id)user:(NSString *)user unassignRole:(NSString *)role;

// async methods
-(void)registering:(BackendlessUser *)user responder:(id <IResponder>)responder;
-(void)update:(BackendlessUser *)user responder:(id <IResponder>)responder;
-(void)login:(NSString *)login password:(NSString *)password responder:(id <IResponder>)responder;
-(void)logout:(id <IResponder>)responder;
-(void)restorePassword:(NSString *)login responder:(id <IResponder>)responder;
-(void)describeUserClass:(id <IResponder>)responder;

-(void)user:(NSString *)user assignRole:(NSString *)role responder:(id <IResponder>)responder;
-(void)user:(NSString *)user unassignRole:(NSString *)role responder:(id <IResponder>)responder;

@end
