//
//  AppDelegate.m
//  FacebookLogin
//
//  Created by Slava Vdovichenko on 8/25/15.
//  Copyright (c) 2015 BACKENDLESS.COM. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Backendless.h"

static NSString *APP_ID = @"";
static NSString *SECRET_KEY = @"";
static NSString *VERSION_NUM = @"v1";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //[DebLog setIsActive:YES];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL result = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                 openURL:url
                                                       sourceApplication:sourceApplication
                                                              annotation:annotation];
    
    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
    
    NSLog(@"openURL: result = %@, url = %@\n userId: %@, token = %@, expirationDate = %@, permissions = %@", @(result), url, [token valueForKey:@"userID"], [token valueForKey:@"tokenString"], [token valueForKey:@"expirationDate"], [token valueForKey:@"permissions"]);
   
    NSDictionary *fieldsMapping =
#if 0
    nil;
#else
  @{
                                    @"id" : @"facebookId",
                                    @"name" : @"name",
                                    @"birthday": @"birthday",
                                    @"first_name": @"first_name",
                                    @"last_name" : @"last_name",
                                    @"gender": @"gender",
                                    @"email": @"email"};
#endif

#if 0 // sync
    
    @try {
        BackendlessUser *user = [backendless.userService
                                 loginWithFacebookSDK:token
                                 fieldsMapping:fieldsMapping
                                 ];
        NSLog(@"USER: %@", user);

        [backendless.userService logout];
        NSLog(@"LOGOUT");
}
    @catch (Fault *fault) {
        NSLog(@"openURL: %@", fault);
    
    }
    
#else // async
    
    [backendless.userService
     loginWithFacebookSDK:token
     fieldsMapping:fieldsMapping
     response:^(BackendlessUser *user) {
         NSLog(@"USER (0): %@", user);
         @try {
#if 1
             user.name = @"Slava";
             user = [backendless.userService update:user];
             NSLog(@"USER (1): %@", user);
#endif
             [backendless.userService logout];
             NSLog(@"LOGOUT");
         }
         @catch (Fault *fault) {
             NSLog(@"%@", fault);
         }
     }
     error:^(Fault *fault) {
         NSLog(@"openURL: %@", fault);
     }];
    
#endif
    
    return result;
}

@end
