//
//  RegisterViewController.h
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

#import <UIKit/UIKit.h>


@class Fault;

@interface Registration : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, copy) NSString *gender;

@property (nonatomic, strong) Fault *fault;

@end


@interface RegisterViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) Registration *registration;

@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UITextField *verifyPasswordInput;
@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (weak, nonatomic) IBOutlet UITextField *birthDataInput;

@property (weak, nonatomic) IBOutlet UIButton *maleChoice;
@property (weak, nonatomic) IBOutlet UIButton *femaleChoice;

-(IBAction)chooseSex:(id)sender;

@end
