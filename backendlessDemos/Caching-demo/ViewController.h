//
//  ViewController.h
//  Caching-damo
//
//  Created by Yury Yaschenko on 8/21/13.
//  Copyright (c) 2013 BACKENDLESS.COM. All rights reserved.
//

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
