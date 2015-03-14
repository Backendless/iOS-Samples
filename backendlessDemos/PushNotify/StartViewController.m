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

//static NSString *MESSAGING_CHANNEL = @"default";
static NSString *MESSAGING_CHANNEL = @"testing";
static NSString *PUBLISHER_ANONYMOUS = @"Anonymous";
static NSString *PUBLISHER_NAME_HEADER = @"publisher_name";

@interface StartViewController () {
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
        [self initNetActivity];
#if 1
        NSString *info = [backendless.messagingService registerDevice:@[MESSAGING_CHANNEL]];
        NSLog(@"registerDevice: %@ \n[%@]", info, [backendless.messagingService getRegistrations]);
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

-(void)showNotification:(NSString *)notification {
    _textView.hidden = NO;
    _textView.text = [_textView.text stringByAppendingFormat:@"APNS: %@\n", notification];
}

-(void)sendMessage:(id)sender {
    
    [(UILabel *)[self.view viewWithTag:100] setText:@""];
    [_netActivity startAnimating];
    
    PublishOptions *options = [PublishOptions new];
    options.headers = @{PUBLISHER_NAME_HEADER:PUBLISHER_ANONYMOUS, @"ios-badge":@"1", @"ios-sound":@"Sound12.aif"};
    //options.headers = @{PUBLISHER_NAME_HEADER:PUBLISHER_ANONYMOUS, @"ios-badge":@"1", @"ios-sound":@"Sound12.aif", @"ios-content-available":@"1"};
    DeliveryOptions *delivery = [DeliveryOptions deliveryOptionsForNotification:PUSHONLY];

#if 1 //async
    
    [backendless.messagingService
     publish:MESSAGING_CHANNEL
     message:_textField.text
     publishOptions:options
     deliveryOptions:delivery
     response:^(MessageStatus *res) {
         [_netActivity stopAnimating];
         NSLog(@"sendMessage: res = %@", res);
         [(UILabel *)[self.view viewWithTag:100] setText:[NSString stringWithFormat:@"messageId: %@\n\nstatus:%@\n\nerrorMessage:'%@'\n", res.messageId, res.status, res.errorMessage]];
         _textField.text = @"";
     }
     error:^(Fault *fault) {
         [_netActivity stopAnimating];
         [self showAlert:fault.message];
         NSLog(@"sendMessage: fault = %@", fault.detail);         
         _textField.text = @"";
     }];

#else //sync
    
    @try {
        
        MessageStatus *res = [backendless.messagingService publish:MESSAGING_CHANNEL message:_textField.text publishOptions:options deliveryOptions:delivery];
        NSLog(@"sendMessage: res = %@", res);
        [(UILabel *)[self.view viewWithTag:100] setText:[NSString stringWithFormat:@"messageId: %@\n\nstatus:%@\n\nerrorMessage:%@", res.messageId, res.status, res.errorMessage]];
    }
    
    @catch (Fault *fault) {
        [self showAlert:fault.message];
        NSLog(@"sendMessage: fault = %@", fault.detail);
    }
    
    @finally {
        [_netActivity stopAnimating];
        _textField.text = @"";
    }
#endif
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self sendMessage:nil];
    return YES;
}

@end
