//
//  ViewController.m
//  UIElementsSample
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2013 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

#import "ViewController.h"
#import "Backendless.h"
#import "BETableView.h"

@interface TestData:NSObject
@end
@implementation TestData
@end


@interface ViewController ()
-(void)showAlert:(NSString *)message;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @try {
        [backendless initAppFault];
    }
    @catch (Fault *fault) {
        [self showAlert:fault.message];
    }
    
    [_tableview find:NSClassFromString(@"TestData") dataQuery:[BackendlessDataQuery query] response:^(BackendlessCollection *collection) {
        NSLog(@"done");
    } error:^(Fault *fault) {
        NSLog(@"fault %@", fault.detail);
    }];
    
    [_collectionView find:NSClassFromString(@"TestData") dataQuery:[BackendlessDataQuery query] response:^(BackendlessCollection *collection) {
        NSLog(@"done");
    } error:^(Fault *fault) {
        NSLog(@"fault %@", fault.detail);
    }];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionViewCell *)collectionView:(BECollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TestData *data = [collectionView getDataForIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Test" forIndexPath:indexPath];
    UILabel *lable = (UILabel *)[cell viewWithTag:1];
    lable.text = [data valueForKey:@"objectId"];
    return cell;
}
-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}
@end
