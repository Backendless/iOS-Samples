//
//  ViewController.h
//  Caching-damo
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

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIButton *policyButton;
@property (nonatomic, strong) IBOutlet UIView *policyView;
@property (nonatomic, strong) IBOutlet UIPickerView *policyPickerView;

-(IBAction)selectStorage:(id)sender;
-(IBAction)addNewObject:(id)sender;
-(IBAction)loadData:(id)sender;
-(IBAction)clearTableViewData:(id)sender;
-(IBAction)selectCachePolicy:(id)sender;
-(IBAction)clearCache:(id)sender;
-(IBAction)hidePolicyPicker:(id)sender;
@end
