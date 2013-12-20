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

- (void)login:(id)sender
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if ([sender tag] == 1)
    {
        
        [backendless.userService easyLoginWithFacebookFieldsMapping:@{@"email":@"email", @"username":@"username", @"user_location":@"user_location"} permissions:@[@"email"] response:^(id response) {
            //response - NSNumber with bool Yes
            NSLog(@"%@", response);
        } error:^(Fault *fault) {
            NSLog(@"%@", fault.detail);
        }];
    }
    else
    {
        [backendless.userService easyLoginWithTwitterFieldsMapping:@{@"email":@"email"} response:^(id response) {
            NSLog(@"%@", response);
        } error:^(Fault *fault) {
            NSLog(@"%@", fault.detail);
        }];
    }
}
-(void)back:(UIStoryboardSegue *)segue
{
    [backendless.userService logout:nil];
}
-(void)showSuccessView
{
    UIViewController *successView = [self.storyboard instantiateViewControllerWithIdentifier:@"SuccessView"];
    [self presentViewController:successView animated:YES completion:^{
    }];
}
@end
