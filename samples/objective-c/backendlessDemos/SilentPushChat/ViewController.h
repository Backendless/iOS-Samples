//
//  ViewController.h
//  SilentPushChat
//
//  Created by Slava Vdovichenko on 8/4/15.
//  Copyright (c) 2015 BACKENDLESS.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UITextField *textField;
-(void)subscribe;
-(void)unsubscribe;
@end

