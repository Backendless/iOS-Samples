//
//  Document.h
//  UserServiceMac
//
//  Created by Yury Yaschenko on 10/2/13.
//  Copyright (c) 2013 BACKENDLESS.COM. All rights reserved.
//

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
