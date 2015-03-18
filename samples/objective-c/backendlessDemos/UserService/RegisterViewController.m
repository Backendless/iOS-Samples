//
//  RegisterViewController.m
//  backendlessDemos
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

#import "RegisterViewController.h"
#import "Backendless.h"

static NSString *LOGIN_PROFILE_KEY = @"login";
static NSString *BIRTHDATE_PROFILE_KEY = @"birthdate";
static NSString *GENDER_PROFILE_KEY = @"gender";

static NSString *MALE_GENDER_VAL = @"male";
static NSString *FEMALE_GENDER_VAL = @"female";


@implementation Registration

-(NSString *)description {
    return [NSString stringWithFormat:@"<Registration>: name = %@, password = %@, email = %@, birthday = %@, gender = %@", _name, _password, _email, _birthday, _gender];
}

@end


@interface RegisterViewController ()
-(BOOL)userRegister:(BackendlessUser *)user;
@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.maleChoice setBackgroundImage:[UIImage imageNamed:@"radio_checked.png"] forState:UIControlStateSelected];
    [self.femaleChoice setBackgroundImage:[UIImage imageNamed:@"radio_checked.png"] forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark -
#pragma mark Private Methods

-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Fault:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

-(BOOL)userRegister:(BackendlessUser *)user {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    BOOL result = NO;
    
    @try {
        user = [backendless.userService registering:user];
        result = YES;
        
        id birthdate = [user getProperty:BIRTHDATE_PROFILE_KEY];
        NSLog(@"RegisterViewController -> userRegister: registered birthdate = %@ <%@>", birthdate, [birthdate class]);
        
    }
    
    @catch (Fault *fault) {
        self.registration.fault = fault;
        NSLog(@"RegisterViewController -> userRegister: %@", fault);
        [self showAlert:fault.detail];
    }
    
    @finally {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    return result;
}


#pragma mark -
#pragma mark Segue Methods

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Register.RegisterViewController"]) {
        
        self.registration = nil;
        
        NSLog(@"SEND ------> registering: name = %@, password = %@, verify = %@", self.nameInput.text, self.passwordInput.text, self.verifyPasswordInput.text);
        
        if ([self.nameInput.text length] && [self.passwordInput.text length] && [self.passwordInput.text isEqualToString:self.verifyPasswordInput.text])
        {
            self.registration = [Registration new];
            self.registration.name = self.nameInput.text;
            self.registration.password = self.passwordInput.text;
            self.registration.email = self.emailInput.text;
            self.registration.birthday = [NSDate date];
            self.registration.gender = self.maleChoice.selected ? MALE_GENDER_VAL : FEMALE_GENDER_VAL;
            
            // server invoke
            
            BackendlessUser *user = [BackendlessUser new];
            user.email = self.registration.email;
            user.password = self.registration.password;
            user.name = self.registration.name;
//            [user setProperty:LOGIN_PROFILE_KEY object:user.email];
//            [user setProperty:BIRTHDATE_PROFILE_KEY object:self.registration.birthday];
            [user setProperty:GENDER_PROFILE_KEY object:self.registration.gender];
            
            // test "\n"
            //[user setProperty:@"music" object:@"TEST\nline1\nline2\n"];
            
            NSLog(@"SEND ------> registering: user = %@", user);
            
            if ([self userRegister:user]) {
                return YES;
            }
        }
        
        return NO;
    }
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"RegisterViewController -> prepareForSegue: %@", [segue identifier]);
}

#pragma mark -
#pragma mark IBAction

-(IBAction)chooseSex:(id)sender {
    
    NSLog(@"->>>>>>>>>>>>> chooseSex: %@", (sender == self.maleChoice)?MALE_GENDER_VAL:FEMALE_GENDER_VAL);
    
    self.maleChoice.selected = (sender == self.maleChoice);
    self.femaleChoice.selected = (sender == self.femaleChoice);
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

@end
