//
//  SettingsViewController.h
//  backendlessDemos
//
//  Created by Yury Yaschenko on 5/24/13.
//  Copyright (c) 2013 BACKENDLESS.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (nonatomic, weak) IBOutlet UITextField *textField;
-(IBAction)save:(id)sender;
@end
