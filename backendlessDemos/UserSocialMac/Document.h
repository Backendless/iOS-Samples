//
//  Document.h
//  UserSocialMac
//
//  Created by Yury Yaschenko on 10/2/13.
//  Copyright (c) 2013 BACKENDLESS.COM. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument
@property (nonatomic, strong) IBOutlet NSView *signin;
@property (nonatomic, strong) IBOutlet NSView *signout;
@property (nonatomic, strong) IBOutlet NSTextField *lable;
-(IBAction)facebook:(id)sender;
-(IBAction)twitter:(id)sender;
-(IBAction)logoutSocial:(id)sender;
@end
