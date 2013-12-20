//
//  Document.h
//  PubSubChatMac
//
//  Created by Yury Yaschenko on 10/2/13.
//  Copyright (c) 2013 BACKENDLESS.COM. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument

@property (nonatomic, strong) IBOutlet NSTextField *userName;
@property (nonatomic, strong) IBOutlet NSTextView *textView;

-(IBAction)publish:(id)sender;

@end
