//
//  Document.m
//  UserSocialMac
//
//  Created by Yury Yaschenko on 10/2/13.
//  Copyright (c) 2013 BACKENDLESS.COM. All rights reserved.
//

#import "Document.h"
#import "Backendless.h"

// *** YOU SHOULD SET THE FOLLOWING VALUES FROM YOUR BACKENDLESS APPLICATION ***
// *** COPY/PASTE APP ID and SECRET KET FROM BACKENDLESS CONSOLE (use the Manage > App Settings screen) ***

static NSString *APP_ID = @"";
static NSString *SECRET_KEY = @"";
static NSString *VERSION_NUM = @"v1";

@implementation Document
- (void)handleURLEvent:(NSAppleEventDescriptor*)event withReplyEvent:(NSAppleEventDescriptor*)replyEvent
{
    NSString* url = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    NSLog(@"%@", url);
    BackendlessUser *user = [backendless.userService handleOpenURL:[NSURL URLWithString:url]];
    NSLog(@"%@", user);
    [_lable setStringValue:@"You are now successfully login."];
    [_signin setHidden:YES];
    [_signout setHidden:NO];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    @try {
        [backendless initAppFault];
    }
    @catch (Fault *fault) {
        [[NSAlert alertWithMessageText:fault.message defaultButton:@"Done" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", fault.detail] runModal];
    }
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(handleURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}

#pragma mark - Actions
-(void)facebook:(id)sender
{
    [backendless.userService easyLoginWithFacebookFieldsMapping:@{@"email":@"email"} permissions:@[@"email"]];
}
-(void)twitter:(id)sender
{
    [backendless.userService easyLoginWithTwitterFieldsMapping:@{@"email":@"email"}];
}
-(void)logoutSocial:(id)sender
{
    [backendless.userService logout:^(id res) {
    } error:^(Fault *error) {
        NSLog(@"%@", error.detail);
    }];
    [_signin setHidden:NO];
    [_signout setHidden:YES];
}
@end
