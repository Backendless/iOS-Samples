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
    
#if 0
    NSLog(@"%@: Is UserToken Valid? %@", [NSDate date], [backendless.userService isValidUserToken].boolValue?@"YES":@"NO");
#else
    [backendless.userService isValidUserToken:
     ^(NSNumber *result) {
         NSLog(@"%@: Is UserToken Valid? %@", [NSDate date], result.boolValue?@"YES":@"NO");
     }
     error:^(Fault *fault) {
        NSLog(@"%@", fault);
     }];
#endif
    
    dispatch_time_t interval = dispatch_time(DISPATCH_TIME_NOW, 1ull*NSEC_PER_SEC*60);
    dispatch_after(interval, dispatch_get_main_queue(), ^{
        [self checkValidUserToken];
    });

}
                   
#if 0

[backendless.userService isValidUserToken:
 ^(NSNumber *result) {
     NSLog(@"%@: Is UserToken Valid? %@", [NSDate date], result.boolValue?@"YES":@"NO");
     
     dispatch_async( dispatch_get_main_queue(), ^{
         // some UI code
     });
     
 }
 error:^(Fault *fault) {
    NSLog(@"%@", fault);
}];

#endif

@end
