//
//  BrowseViewController.m
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

#import "BrowseViewController.h"
#import "Backendless.h"
#import "BEFile.h"
#import "ImagePreviewViewController.h"

@interface BrowseViewController ()
-(void)showAlert:(NSString *)message;
-(void)getAllEntitysAsync;
-(void)responseHandler:(id)response;
-(void)errorHandler:(Fault *)fault;
-(void)deleteFolder:(id)response;
-(void)clearData;
@end

@implementation BrowseViewController

@synthesize mainTableView;

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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getAllEntitysAsync];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getAllEntitysAsync
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    QueryOptions *query = [QueryOptions query:40 offset:0];
    BackendlessDataQuery *dataQuery = [BackendlessDataQuery query:nil where:nil query:query];
    Responder *responder = [Responder responder:self selResponseHandler:@selector(responseHandler:) selErrorHandler:@selector(errorHandler:)];
    [backendless.persistenceService find:[BEFile class] dataQuery:dataQuery responder:responder];
}
-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

#pragma mark - Responder

- (void)responseHandler:(id)response
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    mainData = response;
    [mainTableView reloadData];
}
- (void)errorHandler:(Fault *)fault
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"%@", fault.description);
    [self showAlert:fault.message];
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu %lu %i", (unsigned long)mainData.data.count, mainData.data.count / 4, (mainData.data.count % 4) ? 1 : 0);
    return (mainData.data.count / 4) + ((mainData.data.count % 4) ? 1 : 0);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    for (int i = 1; i<=4; i++)
    {
        UIButton *button = (UIButton *)[cell viewWithTag:i];
        button.hidden = YES;
    }
    for (int i = 1; i<=4; i++)
    {
        if (indexPath.row * 4 + i > mainData.data.count)
            break;
        UIButton *button = (UIButton *)[cell viewWithTag:i];
        NSString *str = [[mainData.data objectAtIndex:indexPath.row * 4 + i - 1] path];
        NSURL *url = [NSURL URLWithString:str];
        button.hidden = NO;
        button.enabled = NO;
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            UIImage *img = [UIImage imageWithData:data];
            [button setImage:img forState:UIControlStateNormal];
            button.enabled = YES;
        }];
        
    }
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [mainTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    ImagePreviewViewController *imagePreview = (ImagePreviewViewController *)[segue destinationViewController];
    [imagePreview setMainImage:[(UIButton *)sender imageForState:UIControlStateNormal]];
    [imagePreview setIsUpload:YES];
    [imagePreview setFile:[mainData.data objectAtIndex:indexPath.row * 4 + [sender tag] - 1]];
}
-(void)removeAll:(id)sender
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    Responder *responder = [Responder responder:self selResponseHandler:@selector(deleteFolder:) selErrorHandler:@selector(errorHandler:)];
    [backendless.fileService removeDirectory:@"img" responder:responder];
}
- (void)deleteFolder:(id)response
{
    [self clearData];
}
- (void)clearData
{
    for (BEFile *file in mainData.data)
        [backendless.persistenceService remove:[BEFile class] sid:file.objectId];
    mainData = nil;
    [mainTableView reloadData];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
@end
