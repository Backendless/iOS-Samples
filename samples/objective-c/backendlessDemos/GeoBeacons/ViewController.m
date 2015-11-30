//
//  ViewController.m
//  GeoBeacons
//
//  Created by Slava Vdovichenko on 11/4/15.
//  Copyright © 2015 BACKENDLESS.COM. All rights reserved.
//

#import "ViewController.h"
#import "Backendless.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    @try {
        
        [backendless initAppFault];
        
        [backendless.geo.presence
         startMonitoring:^(id response) {
             NSLog(@"viewDidLoad (RESPONSE) %@", response);
         }
         error:^(Fault *fault) {
             NSLog(@"viewDidLoad (ASYNC FAULT) %@", fault);
         }];
    }
    @catch (Fault *fault) {
        NSLog(@"viewDidLoad (SYNC FAULT) %@", fault);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Private Methods

@end
