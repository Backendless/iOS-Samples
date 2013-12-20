//
//  SettingsViewController.m
//  backendlessDemos
//
//  Created by Yury Yaschenko on 5/24/13.
//  Copyright (c) 2013 BACKENDLESS.COM. All rights reserved.
//

#import "SettingsViewController.h"
#import "Backendless.h"


@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)save:(id)sender
{
    if (_textField.text.length>0) {
        backendless.hostURL = [NSString stringWithFormat:@"http://%@", _textField.text];
        [_textField resignFirstResponder];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
