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

@interface ViewController () <IResponder>
@property (nonatomic, strong) BESubscription *subscription;
-(void)showAlert:(NSString *)message;
@end

@implementation ViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    @try {
        [backendless initAppFault];
        
        NSString *info = [backendless.messagingService registerDevice:@[MESSAGING_CHANNEL]];
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
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

-(void)showDeviceRegistration {
    DeviceRegistration *devReg = [backendless.messaging currentDevice];
    DeviceRegistration *getReg = [backendless.messaging getRegistrations:devReg.deviceId];
    NSLog(@"showDeviceRegistration: \n%@ =?\n[%@]", devReg, getReg);
}

-(void)sendMessage {
    
    PublishOptions *publishOptions = [PublishOptions new];
    DeliveryOptions *deliveryOptions = [DeliveryOptions deliveryOptionsForNotification:PUSH_NONE];
    
    [backendless.messagingService
     publish:MESSAGING_CHANNEL
     message:_textField.text
     publishOptions:publishOptions
     deliveryOptions:deliveryOptions
     response:^(MessageStatus *res) {
         NSLog(@"sendMessage: res = %@", res);
     }
     error:^(Fault *fault) {
         [self showAlert:fault.message];
         NSLog(@"sendMessage: %@", fault);
     }];
    
    self.textField.text = @"";
}

#pragma mark -
#pragma mark Public Methods

-(void)subscribe {
    
    [self showDeviceRegistration];
    
    NSLog(@">>>>>>>>>>>>>>>>> subscribe");
    
    @try {
        
        SubscriptionOptions *subscriptionOptions = [SubscriptionOptions new];
        [subscriptionOptions deliveryMethod:DELIVERY_PUSH];
        
        Responder *responder = [[Responder alloc] initWithResponder:self
                                                 selResponseHandler:@selector(responseHandler:)
                                                    selErrorHandler:@selector(errorHandler:)];
        
        self.subscription = [backendless.messagingService subscribe:MESSAGING_CHANNEL
                                              subscriptionResponder:responder
                                                subscriptionOptions:subscriptionOptions];
        
        NSLog(@"subscribe: SUBSCRIPTION: %@", _subscription);
    }
    
    @catch (Fault *fault) {
        NSLog(@"subscribe: %@", fault);
        [self showAlert:fault.message];
    }
}

-(void)unsubscribe {
    
    NSLog(@">>>>>>>>>>>>>>>>> unsubscribe");
    
    [_subscription cancel];
}

#pragma mark -
#pragma mark IResponder Methods

-(id)responseHandler:(id)response {
    
    dispatch_async( dispatch_get_main_queue(), ^{
        NSArray *messages = response;
        for (Message *message in messages) {
            _textView.text = [_textView.text stringByAppendingFormat:@"APNS: %@\n", message.data];
        }
    });
    
    return response;
}

-(void)errorHandler:(Fault *)fault {
    NSLog(@"errorHandler: %@", fault);
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    [self sendMessage];
    
    return YES;
}

@end
