//
//  AppDelegate.m
//  FacebookLogin
//
//  Created by Slava Vdovichenko on 8/25/15.
//  Copyright (c) 2015 BACKENDLESS.COM. All rights reserved.
//

// com.themidnightcoders.FacebookLogin
// my Facebook "Back­e­n­d­l­e­s­s­U­s­e­r­L­ogin" App ID: 1077032488973601 App Secret: 864152891aa661ef1f2eb991be3fb9a8
// Anatoly's Facebook Application AppId: 276598585828317 App Secret: ddb15e46a7d5e53436617b7a866811d8


#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Backendless.h"

#define IS_SYNC_ON 0
#define IS_LOGOUT_ON 1

static NSString *APP_ID = @"7B92560B-91F0-E94D-FFEB-77451B0F9700";
static NSString *SECRET_KEY = @"B9D27BA8-3964-F3AE-FF26-E71FFF487300";
static NSString *VERSION_NUM = @"v1";


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //[DebLog setIsActive:YES];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    backendless.hostURL = @"http://api.backendless.com";
    
    
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
    if (!token) {
        NSLog(@"!!! Token = null !!!");
        return false;
    }
    
    NSLog(@"openURL: result = %@, url = %@\n userId: %@, token = %@, expirationDate = %@, permissions = %@", @(result), url, [token valueForKey:@"userID"], [token valueForKey:@"tokenString"], [token valueForKey:@"expirationDate"], [token valueForKey:@"permissions"]);
    
    NSDictionary *fieldsMapping = @{
                                    @"id" : @"facebookId",
                                    @"name" : @"name",
                                    @"first_name": @"first_name",
                                    @"last_name" : @"last_name",
                                    @"gender": @"gender",
                                    @"email": @"email"
                                    };

#if IS_SYNC_ON // SYNC
    
    @try {
        BackendlessUser *user = [backendless.userService loginWithFacebookSDK:token fieldsMapping:fieldsMapping];
        NSLog(@"USER: %@\ncurrentUser: %@", user, backendless.userService.currentUser);
#if IS_LOGOUT_ON
        [backendless.userService logout];
        NSLog(@"LOGOUT");
#endif
}
    @catch (Fault *fault) {
        NSLog(@"%@", fault);
    
    }
    
#else // ASYNC
    
    [backendless.userService
     loginWithFacebookSDK:token
     fieldsMapping:fieldsMapping
     response:^(BackendlessUser *user) {
         NSLog(@"USER: %@", user);
#if IS_LOGOUT_ON
         [backendless.userService logout:
          ^(id response) {
              NSLog(@"LOGOUT");
          }
          error:^(Fault *fault) {
              NSLog(@"%@", fault);
          }];
#endif
     }
     error:^(Fault *fault) {
         NSLog(@"%@", fault);
     }];
    
#endif
    
    return result;
}

@end
