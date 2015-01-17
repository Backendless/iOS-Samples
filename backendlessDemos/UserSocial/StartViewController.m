//
//  StartViewController.m
//  UserSocial
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

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    @try {
        [backendless initAppFault];
    }
    @catch (Fault *fault) {
        [self showAlert:fault.message];
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Fault:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

- (void)login:(id)sender
{
    NSLog(@"StartViewController -> login: (START)");
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if ([sender tag] == 1)
    {
        [backendless.userService
         easyLoginWithFacebookFieldsMapping:@{@"email":@"email", @"username":@"username", @"user_location":@"user_location"}
         permissions:@[@"email"]
         response:^(id response) {
             //response - NSNumber with bool Yes
             NSLog(@"StartViewController -> login: (Facebook) result = %@", response);
         } error:^(Fault *fault) {
             NSLog(@"StartViewController -> login: (FAULT) %@", fault.detail);
         }];
    }
    else
    {
        [backendless.userService
         easyLoginWithTwitterFieldsMapping:@{@"email":@"email"}
         response:^(id response) {
             NSLog(@"StartViewController -> login: (Twitter) result = %@", response);
         } error:^(Fault *fault) {
             NSLog(@"StartViewController -> login: (FAULT) %@", fault.detail);
         }];
    }
}

-(void)back:(UIStoryboardSegue *)segue
{
    NSLog(@"[BackendlessDemos.UserSosial] StartViewController -> back: (START)");
    
    [backendless.userService logout:nil];
}

-(void)showSuccessView
{
    NSLog(@"[BackendlessDemos.UserSosial] StartViewController -> showSuccessView");
    
    UIViewController *successView = [self.storyboard instantiateViewControllerWithIdentifier:@"SuccessView"];
    [self presentViewController:successView animated:YES completion:^{
    }];
}

@end
