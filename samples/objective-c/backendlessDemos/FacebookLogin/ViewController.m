//
//  ViewController.m
//  FacebookLogin
//
//  Created by Slava Vdovichenko on 8/25/15.
//  Copyright (c) 2015 BACKENDLESS.COM. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Backendless.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    @try {
        [backendless initAppFault];
    }
    @catch (Fault *fault) {
        [self showAlert:fault.message];
    }
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    
    [self checkValidUserToken];
}

-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

-(void)checkValidUserToken {
    
    NSLog(@"%@: Is UserToken Valid? %@", [NSDate date], [backendless.userService isValidUserToken].boolValue?@"YES":@"NO");
    
    dispatch_time_t interval = dispatch_time(DISPATCH_TIME_NOW, 1ull*NSEC_PER_SEC*60);
    dispatch_after(interval, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self checkValidUserToken];
    });
}

@end
