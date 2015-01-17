//
//  Document.m
//  PubSubChatMac
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

#import "Document.h"
#import "Backendless.h"

// *** YOU SHOULD SET THE FOLLOWING VALUES FROM YOUR BACKENDLESS APPLICATION ***
// *** COPY/PASTE APP ID and SECRET KET FROM BACKENDLESS CONSOLE (use the Manage > App Settings screen) ***

static NSString *APP_ID = @"";
static NSString *SECRET_KEY = @"";
static NSString *VERSION_NUM = @"v1";

static NSString *MESSAGING_CHANNEL = @"default";
static NSString *PUBLISHER_ANONYMOUS = @"Anonymous";
static NSString *PUBLISHER_NAME_HEADER = @"publisher_name";


@interface Document () <IResponder> {
    
    PublishOptions *publishOptions;
    SubscriptionOptions *subscriptionOptions;
    BESubscription *subscription;
    Responder *responder;
}

-(void)subscribe;
-(void)unsubscribe;
@end

@implementation Document

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
    publishOptions = [PublishOptions new];
    subscriptionOptions = [SubscriptionOptions new];

    [self subscribe];
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

#pragma mark - private methods
-(void)publish:(NSTextField *)textField {
    
    NSString *message = textField.stringValue;
    if (!message || !message.length)
        return;
    publishOptions.publisherId = _userName.stringValue;
    [backendless.messagingService publish:MESSAGING_CHANNEL message:message publishOptions:publishOptions response:^(MessageStatus *status) {
        textField.stringValue = @""; 
    } error:^(Fault *error) {
        NSLog(@"%@", error.detail);
    }];
}

-(void)subscribe {
    @try{
    responder = [[Responder alloc] initWithResponder:self
                                  selResponseHandler:@selector(responseHandler:) selErrorHandler:@selector(errorHandler:)];
        subscription = [backendless.messagingService
                    subscribe:MESSAGING_CHANNEL subscriptionResponder:responder subscriptionOptions:subscriptionOptions];
    }
    @catch (Fault *error) {
        NSLog(@"%@", error.detail);
    }
    NSLog(@"ChatViewController -> subscribe: SUBSCRIPTION: %@", subscription);
}

-(void)unsubscribe {
    [subscription cancel];
}
-(id)responseHandler:(id)response {
    
    NSLog(@"ChatViewController -> responseHandler: RESPONSE = %@ <%@>", response, response?[response class]:@"NULL");
    
    NSArray *messages = response;
    for (id obj in messages) {
        if ([obj isKindOfClass:[Message class]]) {
            Message *message = (Message *)obj;
            NSString *publisher = message.publisherId;
            self.textView.string = [self.textView.string stringByAppendingFormat:@"%@ : '%@'\n", publisher ? publisher : PUBLISHER_ANONYMOUS, message.data];
        }
    }
    return response;
}

-(void)errorHandler:(Fault *)fault {
    
    NSLog(@"ChatViewController -> errorHandler: FAULT = %@ <%@>", fault.message, fault.detail);
}
@end
