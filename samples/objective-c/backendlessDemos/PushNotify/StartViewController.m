//
//  StartViewController.m
//  PushNotify
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

#import "StartViewController.h"
#import "Backendless.h"

static NSString *MESSAGING_CHANNEL = @"default";
static NSString *PUBLISHER_ANONYMOUS = @"Anonymous";
static NSString *PUBLISHER_NAME_HEADER = @"publisher_name";

@interface StartViewController () <IBEPushReceiver> {
    UIActivityIndicatorView *_netActivity;
}
-(void)showAlert:(NSString *)message;
-(void)initNetActivity;
@end

@implementation StartViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    @try {
        [backendless initAppFault];
#if __OLD__
        NSString *info = [backendless.messagingService registerDevice:@[MESSAGING_CHANNEL]];
        NSLog(@"viewDidLoad -> registerDevice: %@", info);
#else
        backendless.messaging.notificationTypes = UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        [backendless.messaging startupRegisterDeviceWithChannels:@[MESSAGING_CHANNEL]];
#endif
        backendless.messagingService.pushReceiver = self;

        [self initNetActivity];

#if 0 // try to publish text with lenght more then max = 2K
        self.textField.text = [backendless randomString:3000];
        NSLog(@"viewDidLoad -> registerDevice (TEXT): [%lu]", (unsigned long)self.textField.text.length);
#endif
    }
    
    @catch (Fault *fault) {
        [self showAlert:fault.message];
    }
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Private Methods

-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

-(void)initNetActivity {
    // Create and add the activity indicator
    _netActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _netActivity.center = CGPointMake(160.0f, 400.0f);
    [self.view addSubview:_netActivity];
}

-(void)startNetIndicator {
    self.textField.hidden = YES;
    [_netActivity startAnimating];
}

-(void)stopNetIndicator {
    self.textField.hidden = NO;
    [_netActivity stopAnimating];
}

#if 1
-(void)publish {
    
    [(UILabel *)[self.view viewWithTag:100] setText:@""];
    [self startNetIndicator];
    
    PublishOptions *options = [PublishOptions new];
    [options assignHeaders:@{PUBLISHER_NAME_HEADER:PUBLISHER_ANONYMOUS, @"ios-badge":@"1", @"ios-sound":@"Sound12.aif", @"ios-content-available":@"1"}];
    
    DeliveryOptions *delivery = [DeliveryOptions new];
    [delivery pushPolicy:PUSH_ONLY];
    [delivery pushBroadcast:FOR_ANDROID|FOR_IOS];
    
    [backendless.messagingService
     publish:MESSAGING_CHANNEL
     message:_textField.text
     publishOptions:options
     deliveryOptions:delivery
     response:^(MessageStatus *res) {
         NSLog(@"showMessageStatus: %@", res);
         [self stopNetIndicator];
         self.textField.text = @"";
         [(UILabel *)[self.view viewWithTag:100] setText:[NSString stringWithFormat:@"messageId: %@\n\nstatus:%@\n\nerrorMessage:'%@'", res.messageId, res.status, res.errorMessage]];
     }
     error:^(Fault *fault) {
         [self stopNetIndicator];
         self.textField.text = @"";
         [self showAlert:fault.message];
         NSLog(@"sendMessage: fault = %@", fault);
     }];
}
#else

-(void)publish {
    
    [(UILabel *)[self.view viewWithTag:100] setText:@""];
    [self startNetIndicator];
    
    DeliveryOptions *delivery = [DeliveryOptions new];
    [delivery pushPolicy:PUSH_ALSO];
    
    PublishOptions *options = [PublishOptions new];
    [options addHeader:PUBLISHER_NAME_HEADER value:PUBLISHER_ANONYMOUS];
    [options addHeader:@"ios-sound" value:@"mySound.aif"];
    
    [backendless.messagingService
     publish:MESSAGING_CHANNEL
     message:_textField.text
     publishOptions:options
     deliveryOptions:delivery
     response:^(MessageStatus *res) {
         NSLog(@"showMessageStatus: %@", res);
         [self stopNetIndicator];
         self.textField.text = @"";
         [(UILabel *)[self.view viewWithTag:100] setText:[NSString stringWithFormat:@"messageId: %@\n\nstatus:%@\n\nerrorMessage:'%@'", res.messageId, res.status, res.errorMessage]];
     }
     error:^(Fault *fault) {
         [self stopNetIndicator];
         self.textField.text = @"";
         [self showAlert:fault.message];
         NSLog(@"sendMessage: fault = %@", fault);
     }];
}
#endif

#pragma mark -
#pragma mark IBEPushReceiver Methods

-(void)didReceiveRemoteNotification:(NSString *)notification headers:(NSDictionary *)headers {
    _textView.hidden = NO;
    _textView.text = [_textView.text stringByAppendingFormat:@"%@: %@\n", headers[PUBLISHER_NAME_HEADER], notification];
}

-(void)didRegisterForRemoteNotificationsWithDeviceId:(NSString *)deviceId fault:(Fault *)fault {
    
    if (fault) {
        NSLog(@"didRegisterForRemoteNotificationsWithDeviceId: (FAULT) %@", fault);
        return;
    }
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceId: %@", deviceId);
}

-(void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", err);
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self publish];
    return YES;
}

@end
