//
//  StartViewController.m
//  UserService
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
#import "RegisterViewController.h"
#import "Backendless.h"

#define _ASYNC_REQUEST 1
#define _STAY_LOGGED_IN 1

@interface StartViewController ()
-(void)showAlert:(NSString *)message;
-(void)switchToLogout;
-(void)userLogin;
-(void)userLogout;
@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @try {
        
        [backendless initAppFault];

#if _STAY_LOGGED_IN
        
        [self stayLoggedIn ];
        
        id user = backendless.userService.currentUser;
        NSLog(@"viewDidLoad -> currentUser: %@", user);
        
        if (user) {
#if 1
            [user setProperty:@"second" object:@"5"];
            NSLog(@"viewDidLoad -> currentUser (UPDATED): %@", backendless.userService.currentUser);
#endif
#if 1
            user = [backendless.data findByClassId:BackendlessUser.class sid:backendless.userService.currentUser.objectId];
            NSLog(@"viewDidLoad -> findByClassId: %@", user);
#endif
        }
    
#endif
    }
    @catch (Fault *fault) {
        [self showAlert:fault.message];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#if 0
-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#endif
#pragma mark -
#pragma mark Test Methods

-(void)stayLoggedIn {
    
    if (backendless.userService.isStayLoggedIn) {
        
        NSNumber *result = [backendless.userService isValidUserToken];
        NSLog(@"viewDidLoad -> isValidUserToken: %@", [result boolValue]?@"YES":@"NO");
        [result boolValue] ? [self switchToLogout] : [backendless.userService setStayLoggedIn:NO];
    }
    else {
        [backendless.userService setStayLoggedIn:YES];
    }
}

#pragma mark -
#pragma mark Private Methods

-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Fault:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

-(void)switchToLogout {
    
    self.headerLabel.hidden = YES;
    self.loginLabel.hidden = YES;
    self.passwordLabel.hidden = YES;
    self.loginInput.hidden = YES;
    self.passwordInput.hidden = YES;
    self.btnLogin.hidden = YES;
    self.btnRegister.hidden = YES;
    [[self.view viewWithTag:1] setHidden:YES];
    
    self.messageLabel.hidden = NO;
    self.btnLogout.hidden = NO;
}

-(void)userLogin {
    
    NSLog(@"login ---------------------");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
#if _ASYNC_REQUEST
    
    [backendless.userService login:self.loginInput.text password:self.passwordInput.text
     response:^(BackendlessUser *user) {
         
         NSLog(@"StartViewController -> userLogin: (ASYNC LOGIN) user -> %@\n currentUser -> %@", user, backendless.userService.currentUser);
 
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         [self switchToLogout];
     }
     error:^(Fault *fault) {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         NSLog(@"StartViewController -> userLogin: <ASYNC FAULT> %@", fault);
         [self showAlert:fault.detail];
     }];
    
#else // sync request
    
    @try {
        
        BackendlessUser *user = [backendless.userService login:self.loginInput.text password:self.passwordInput.text];
        
        NSLog(@"StartViewController -> userLogin: (SYNC LOGIN) user -> %@\n currentUser -> %@", user, backendless.userService.currentUser);
        
        [self switchToLogout];
    }
    
    @catch (Fault *fault) {
        NSLog(@"StartViewController -> userLogin: <SYNC FAULT> %@", fault);
        [self showAlert:fault.detail];
    }
    
    @finally {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
#endif
}

-(void)userLogout {
    
    NSLog(@"logout ---------------------");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

#if _ASYNC_REQUEST // async
    
    [backendless.userService logout:
        ^(BackendlessUser *user) {
            NSLog(@"StartViewController -> userLogout: (ASYNC LOGOUT) %@ ", user);
        }
        error:^(Fault *fault) {
            NSLog(@"StartViewController -> userLogout: <ASYNC FAULT> %@, currentUser = %@", fault, backendless.userService.currentUser);
            [self showAlert:fault.detail];
        }];
    
#else // sync
    
    @try {
        [backendless.userService logout];
        NSLog(@"StartViewController -> userLogout: (SYNC LOGOUT) currentUser = %@", backendless.userService.currentUser);
    }
    
    @catch (Fault *fault) {
        NSLog(@"StartViewController -> userLogout: <SYNC FAULT> %@, currentUser = %@", fault, backendless.userService.currentUser);
        [self showAlert:fault.message];
    }
    
#endif
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.headerLabel.hidden = NO;
    self.loginLabel.hidden = NO;
    self.passwordLabel.hidden = NO;
    self.loginInput.hidden = NO;
    self.passwordInput.hidden = NO;
    self.btnLogin.hidden = NO;
    self.btnRegister.hidden = NO;
    [[self.view viewWithTag:1] setHidden:NO];
    
    self.messageLabel.hidden = YES;
    self.btnLogout.hidden = YES;
}

#pragma mark -
#pragma mark IBAction

-(IBAction)login:(id)sender {
    [self userLogin];
}

-(IBAction)logout:(id)sender {
    [self userLogout];
}

#pragma mark -
#pragma mark - IBAction for Unwind Seque

-(IBAction)registration:(UIStoryboardSegue *)segue {
    
    NSLog(@"StartViewController -> registration: seque = %@", [segue identifier]);
    
    if ([[segue identifier] isEqualToString:@"Registration.Done"]) {
        
        RegisterViewController *controller = [[(UINavigationController *)[[segue sourceViewController] presentingViewController] viewControllers] objectAtIndex:0];
        
        if (controller.registration) {
            
            Fault *fault = controller.registration.fault;
            if (fault) {
                NSLog(@"StartViewController -> registration: %@", fault);
                [self showAlert:fault.message];
            }
            else {
                NSLog(@"StartViewController -> registration: %@", controller.registration);
                self.loginInput.text = controller.registration.email;
                self.passwordInput.text = controller.registration.password;
            }
            
        }
        
        return;
    }
}

-(IBAction)cancel:(UIStoryboardSegue *)segue {
    
    NSLog(@"StartViewController -> cancel: seque = %@", [segue identifier]);
    
    if ([[segue identifier] isEqualToString:@"Cancel.RegisterViewController"]) {
        return;
    }
}

#pragma mark -
#pragma mark Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"StartViewController -> prepareForSegue: %@", [segue identifier]);
    
    if ([[segue identifier] isEqualToString:@"RegisterViewController"]) {
        return;
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

@end
