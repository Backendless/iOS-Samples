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

#define _LOCALHOST_ 0
#define _PRODUCTION_ 1
#define _TEST_ 0

#if _LOCALHOST_
static NSString *HOST_URL = @"http://10.0.1.62:9000";
static NSString *APP_ID = @"9E2E39D8-0A73-D2CE-FF84-E21661EF2700";
static NSString *SECRET_KEY = @"ADE0B282-A1CF-1229-FF46-DB768BB9BE00";
#endif
#if _PRODUCTION_
static NSString *HOST_URL = @"http://api.backendless.com";
static NSString *APP_ID = @"7B92560B-91F0-E94D-FFEB-77451B0F9700";
static NSString *SECRET_KEY = @"B9D27BA8-3964-F3AE-FF26-E71FFF487300";
#endif
#if _TEST_
static NSString *HOST_URL = @"http://apitest.backendless.com";
static NSString *APP_ID = @"7B92560B-91F0-E94D-FFEB-77451B0F9700";
static NSString *SECRET_KEY = @"B9D27BA8-3964-F3AE-FF26-E71FFF487300";
#endif

static NSString *VERSION_NUM = @"v1";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //[DebLog setIsActive:YES];
    
    backendless.hostURL = HOST_URL;
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
    
    @try {
        BackendlessUser *user = [backendless.userService loginWithFacebookSDK:token fieldsMapping:nil];
        NSLog(@"USER: %@", user);
    }
    @catch (Fault *fault) {
        NSLog(@"openURL: %@", fault);
    }
    
    return result;
}

@end
