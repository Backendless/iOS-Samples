//
//  StartViewController.m
//  ToDoData
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

#import "StartViewController.h"
#import "Backendless.h"
#import "Task.h"


@interface StartViewController ()
{
    NSMutableArray *_data;
}
- (void)addNewEntityWithName:(NSString *)name;
- (void)showAlert:(NSString *)message;
- (void)removeObjectWithIndex:(NSIndexPath *)index;
- (void)saveEntityWithIndex:(NSIndexPath *)index name:(NSString *)name;
- (void)responseHandler:(id)response;
- (void)errorHandler:(Fault *)fault;
- (void)getAllEntitysAsync;

@end

@implementation StartViewController

@synthesize mainTableView, countLable;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _data = [NSMutableArray array];
    @try {
        [backendless initAppFault];
    }
    @catch (Fault *fault) {
        [self showAlert:fault.message];
    }

    [self getAllEntitysAsync];

    editedIndexPath = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Private Methods

- (void)addNewEntityWithName:(NSString *)name
{
    Task *task = [Task new];
    [task setTitle:name];
    [task setStatus:[NSNumber numberWithBool:NO]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [backendless.persistenceService save:task response:^(id response) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [_data insertObject:response atIndex:0];
        NSLog(@"%@", [response valueForKey:@"objectId"]);
        [mainTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        countLable.text = [NSString stringWithFormat:@"%lu items left", (unsigned long)_data.count];
    } error:^(Fault *fault) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"StartViewController -> removeObjectWithIndex: FAULT = %@ <%@>", fault.message, fault.detail);
        [self showAlert:fault.message];
    }];
}

- (void)getAllEntitysAsync
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    QueryOptions *query = [QueryOptions query];
    BackendlessDataQuery *dataQuery = [BackendlessDataQuery query:nil where:nil query:query];
    Responder *responder = [Responder responder:self selResponseHandler:@selector(responseHandler:) selErrorHandler:@selector(errorHandler:)];
    [backendless.persistenceService find:[Task class] dataQuery:dataQuery responder:responder];
}


-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

- (void)removeObjectWithIndex:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [backendless.persistenceService remove:[Task class] sid:[(Task *)[_data objectAtIndex:indexPath.row] valueForKey:@"objectId"] response:^(NSNumber *response) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [_data removeObjectAtIndex:indexPath.row];
        [mainTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        countLable.text = [NSString stringWithFormat:@"%lu items left", (unsigned long)_data.count];
    } error:^(Fault *fault) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"StartViewController -> removeObjectWithIndex: FAULT = %@ <%@>", fault.message, fault.detail);
        [self showAlert:fault.message];
    }];
}
- (void)saveEntityWithIndex:(NSIndexPath *)indexPath name:(NSString *)name
{
    Task *entity = [_data objectAtIndex:indexPath.row];
    if (![name isEqualToString:entity.title])
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSString *title = entity.title;
        entity.title = name;
        [mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [backendless.persistenceService save:entity response:^(id response) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } error:^(Fault *fault) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            NSLog(@"StartViewController -> saveEntityWithIndex: FAULT = %@ <%@>", fault.message, fault.detail);
            [self showAlert:fault.message];
            entity.title = title;
            [mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }
}

- (void)selectEntity:(UIButton *)sender
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    sender.selected = !sender.selected;
    NSIndexPath *indexPath;
    if ([[[sender superview] superview] isKindOfClass:[UITableViewCell class]]) {
        indexPath = [mainTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    }
    else
    {
            indexPath = [mainTableView indexPathForCell:(UITableViewCell *)[[[sender superview] superview] superview]];
    }

    Task *task = [_data objectAtIndex:indexPath.row];

    //NSLog(@"%@", [[task valueForKey:@"___class"] class]);
    NSNumber *status = [NSNumber numberWithBool:[task.status boolValue]];
    [task setStatus:[NSNumber numberWithBool:sender.selected]];
    [mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [backendless.persistenceService save:task response:^(id response) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } error:^(Fault *fault) {
        NSLog(@"%@", fault.detail);
        [self showAlert:fault.message];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        task.status = status;
        [mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}
- (void)editEntity:(UITapGestureRecognizer *)tap
{
    editedIndexPath = [mainTableView indexPathForCell:(UITableViewCell *)tap.view];
    [mainTableView reloadRowsAtIndexPaths:@[editedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Responder

- (void)responseHandler:(id)response
{
    NSLog(@"responseHandler: class = %@", [response class]);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_data addObjectsFromArray:[(BackendlessCollection *)response data]];
    
    [mainTableView reloadData];
    countLable.text = [NSString stringWithFormat:@"%lu items left", (unsigned long)_data.count];
}

- (void)errorHandler:(Fault *)fault
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"%@", fault.faultCode);
    if ([fault.faultCode integerValue] != 1009) {
        [self showAlert:fault.message];
    }
    
}
#pragma mark - UITableViewDelegate/dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    static NSString *editCellIdentifier = @"editCellIdentifier";
    UITableViewCell *cell;
    Task *task = [_data objectAtIndex:indexPath.row];
    if (editedIndexPath && (indexPath.row == editedIndexPath.row))
    {
        cell = [tableView dequeueReusableCellWithIdentifier:editCellIdentifier forIndexPath:indexPath];
        UITextField *textField = (UITextField *)[cell viewWithTag:2];
        textField.text = [task title];
        [textField becomeFirstResponder];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        [(UILabel *)[cell viewWithTag:1] setText:[task title]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editEntity:)];
        [tap setNumberOfTapsRequired:2];
        [cell addGestureRecognizer:tap];
        [(UIButton *)[cell viewWithTag:2] setSelected:[[task status] boolValue]];
    }
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
            [self removeObjectWithIndex:indexPath];
            break;
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 2)
    {
        NSIndexPath *indexPath;
        if ([[[textField superview] superview] isKindOfClass:[UITableViewCell class]]) {
            indexPath = [mainTableView indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
        }
        else
        {
            indexPath = [mainTableView indexPathForCell:(UITableViewCell *)[[[textField superview] superview] superview]];
        }
        editedIndexPath = nil;
        [mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self saveEntityWithIndex:indexPath name:textField.text];
        return;
    }
    [self addNewEntityWithName:textField.text];
    textField.text = @"";
}

@end
