//
//  ViewController.m
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

#import "ViewController.h"
#import "CachingObject.h"
#import "Backendless.h"

@interface ViewController ()
{
    BackendlessCachePolicy *_policy;
    NSMutableArray *_data;
    NSArray *_policyData;
}
-(void)showPickerView:(UIView *)view;
-(void)hidePickerView:(UIView *)view;
-(NSString *)cachePolicyName:(BackendlessCachePolicy *)policy;
-(void)showAlert:(NSString *)message;
@end

@implementation ViewController

-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

-(void)viewDidLoad {
    
    [super viewDidLoad];

    @try {
        [backendless initAppFault];
    }
    @catch (Fault *fault) {
        [self showAlert:fault.message];
    }
    _policyData = @[@"Ignore Cache",
                    @"Cache Only",
                    @"Remote Data Only",
                    @"From Cache Or Remote",
                    @"From Remote Or Cache",
                    @"From Cache And Remote"];
    
    _data = [NSMutableArray array];
    _policy = [BackendlessCachePolicy new];
    [_policyButton setTitle:[self cachePolicyName:_policy] forState:UIControlStateNormal];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

-(void)showPickerView:(UIView *)view {
    
    view.hidden = NO;
    CGRect frame = view.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        view.frame = frame;
    } completion:^(BOOL finished) {
    }];
}

-(void)hidePickerView:(UIView *)view {
    
    CGRect frame = view.frame;
    frame.origin.y = self.view.frame.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        view.frame = frame;
    } completion:^(BOOL finished) {
        view.hidden = YES;
    }];
}

-(NSString *)cachePolicyName:(BackendlessCachePolicy *)policy {
    
    switch (policy.valCachePolicy) {
        case BackendlessCachePolicyCacheOnly:
            return [_policyData objectAtIndex:BackendlessCachePolicyCacheOnly];
        case BackendlessCachePolicyFromCacheAndRemote:
            return [_policyData objectAtIndex:BackendlessCachePolicyFromCacheAndRemote];
        case BackendlessCachePolicyFromRemoteOrCache:
            return [_policyData objectAtIndex:BackendlessCachePolicyFromRemoteOrCache];
        case BackendlessCachePolicyIgnoreCache:
            return [_policyData objectAtIndex:BackendlessCachePolicyIgnoreCache];
        case BackendlessCachePolicyRemoteDataOnly:
            return [_policyData objectAtIndex:BackendlessCachePolicyRemoteDataOnly];
        case BackendlessCachePolicyFromCacheOrRemote:
            return [_policyData objectAtIndex:BackendlessCachePolicyFromCacheOrRemote];
        default:
            return [_policyData objectAtIndex:BackendlessCachePolicyIgnoreCache];
    }
}

#pragma mark - IBAction

-(void)clearCache:(id)sender {
    [backendless clearAllCache];
}

-(void)addNewObject:(id)sender {
    
    [backendless.persistenceService
     save:[CachingObject generateRandomObject]
     response:^(id response) {
         [[[UIAlertView alloc] initWithTitle:@"Add New Object:" message:[(CachingObject *)response description] delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil] show];
         [_data insertObject:response atIndex:0];
         [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
     }
     error:^(Fault *fault) {
         [[[UIAlertView alloc] initWithTitle:@"Error" message:[fault detail] delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil] show];
     }];
}

-(void)clearTableViewData:(id)sender {
    [_data removeAllObjects];
    [_tableView reloadData];
}

-(void)loadData:(id)sender {
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.cachePolicy = _policy;
    
    [backendless.persistenceService
     find:[CachingObject class]
     dataQuery:query
     response:^(BackendlessCollection *collection) {
         _data = [NSMutableArray arrayWithArray:collection.data];
         [_tableView reloadData];
     }
     error:^(Fault *fault) {
         [[[UIAlertView alloc] initWithTitle:@"Error" message:[fault detail] delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil] show];
     }];
}

-(void)selectCachePolicy:(id)sender {
    [self showPickerView:_policyView];
}

-(void)selectStorage:(UISwitch *)sender {
    [backendless setCacheStoredType:sender.on?BackendlessCacheStoredDisc:BackendlessCacheStoredMemory];
}

-(void)hidePolicyPicker:(id)sender {
    [self hidePickerView:_policyView];
}

#pragma mark - PickerViewDelegate/DataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _policyData.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_policyData objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [_policy cachePolicy:(BackendlessCachePolicyEnum)row];
    [_policyButton setTitle:[self cachePolicyName:_policy] forState:UIControlStateNormal];
}

#pragma mark - TableViewDelegate/DatasSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cachingDataCell" forIndexPath:indexPath];
    UILabel *lable = (UILabel *)[cell viewWithTag:1];
    CachingObject *object = [_data objectAtIndex:indexPath.row];
    lable.text = [NSString stringWithFormat:@"%@ (%@) %@", object.name, object.nickname, object.age];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end
