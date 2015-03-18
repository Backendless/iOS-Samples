//
//  Document.h
//  UserServiceMac
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

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument
@property (nonatomic, strong) IBOutlet NSTextField *emailLogin;
@property (nonatomic, strong) IBOutlet NSTextField *passLogin;
@property (nonatomic, strong) IBOutlet NSTextField *emailReg;
@property (nonatomic, strong) IBOutlet NSTextField *passReg;
@property (nonatomic, strong) IBOutlet NSTextField *loginReg;
@property (nonatomic, strong) IBOutlet NSView *loginView;
@property (nonatomic, strong) IBOutlet NSView *logoutView;
-(IBAction)login:(id)sender;
-(IBAction)registrate:(id)sender;
-(IBAction)logout:(id)sender;
-(IBAction)sendLogin:(id)sender;
-(IBAction)sendReg:(id)sender;
@end
