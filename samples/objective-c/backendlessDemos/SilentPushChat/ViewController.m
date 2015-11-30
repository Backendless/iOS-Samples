//
//  ViewController.m
//  SilentPushChat
//
//  Created by Slava Vdovichenko on 8/4/15.
//  Copyright (c) 2015 BACKENDLESS.COM. All rights reserved.
//

#import "ViewController.h"
#import "Backendless.h"

static NSString *MESSAGING_CHANNEL = @"silentpush";

@interface ViewController () <IBEPushReceiver>
@property (nonatomic, strong) BESubscription *subscription;
-(void)showAlert:(NSString *)message;
@end

@implementation ViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    @try {
        [backendless initAppFault];
        
        backendless.messaging.pushReceiver = self;
        
        NSString *info = [backendless.messaging registerDevice:@[MESSAGING_CHANNEL]];
        NSLog(@"viewDidLoad -> registerDevice: %@", info);
        
        
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
    NSLog(@"didReceiveMemoryWarning");
}


#pragma mark -
#pragma mark Private Methods

-(void)showAlert:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:@"Error:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

-(void)publish {
    
    [backendless.messaging
     publish:MESSAGING_CHANNEL
     message:_textField.text
     deliveryOptions:[DeliveryOptions deliveryOptionsForNotification:PUSH_PUBSUB]
     response:^(MessageStatus *res) {
         NSLog(@"sendMessage: res = %@", res);
     }
     error:^(Fault *fault) {
         NSLog(@"sendMessage: %@", fault);
         [self showAlert:fault.message];
     }];
    
    self.textField.text = @"";
}

-(void)subscribe {
    
    NSLog(@">>>>>>>>>>>>>>>>> subscribe");
    
    [backendless.messaging
     subscribe:MESSAGING_CHANNEL
     subscriptionResponse:^(NSArray *messages) {
         for (Message *message in messages) {
             _textView.text = [_textView.text stringByAppendingFormat:@"APNS: %@\n", message.data];
         }
     }
     subscriptionError:^(Fault *fault) {
         NSLog(@"subscriptionError: %@", fault);
     }
     subscriptionOptions:[SubscriptionOptions subscriptionOptionsWithDeliveryMethod:DELIVERY_PUSH]
     response:^(BESubscription *subscription) {
         self.subscription = subscription;
         NSLog(@"subscribe: SUBSCRIPTION: %@", _subscription);
     }
     error:^(Fault *fault) {
         NSLog(@"subscribe: %@", fault);
         [self showAlert:fault.message];
     }];
}

-(void)unsubscribe {
    
    NSLog(@">>>>>>>>>>>>>>>>> unsubscribe");
    
    [_subscription cancel];
}

#pragma mark -
#pragma mark IBEPushReceiver Methods

-(void)didRegisterForRemoteNotificationsWithDeviceId:(NSString *)deviceId fault:(Fault *)fault {
    
    if (fault) {
        NSLog(@"didRegisterForRemoteNotificationsWithDeviceId: (FAULT) %@", fault);
        return;
    }
    
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceId: %@", deviceId);
    [self subscribe];
}

-(void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", err);
}

-(void)applicationWillTerminate {
    NSLog(@"applicationWillTerminate");
    [self unsubscribe];
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    [self publish];
    
    return YES;
}

@end
