//
//  Document.m
//  ToDoDataMac
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

#import "Document.h"
#import "Backendless.h"
#import "Task.h"

// *** YOU SHOULD SET THE FOLLOWING VALUES FROM YOUR BACKENDLESS APPLICATION ***
// *** COPY/PASTE APP ID and SECRET KET FROM BACKENDLESS CONSOLE (use the Manage > App Settings screen) ***

static NSString *APP_ID = @"";
static NSString *SECRET_KEY = @"";
static NSString *VERSION_NUM = @"v1";

@interface Document ()
{
    NSMutableArray *_data;
}
@end

@implementation Document

- (id)init
{
    self = [super init];
    if (self) {
        _data = [NSMutableArray array];
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
	[super windowControllerDidLoadNib:aController];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    
    @try {
        [backendless initAppFault];
    }
    @catch (Fault *fault) {
        [[NSAlert alertWithMessageText:fault.message defaultButton:@"Done" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", fault.detail] runModal];
    }

    [backendless.persistenceService
     find:[Task class]
     dataQuery:[BackendlessDataQuery query]
     response:^(BackendlessCollection *collection) {
        _data = [NSMutableArray arrayWithArray:collection.data];
        [_tableView reloadData];
         NSLog(@"windowControllerDidLoadNib: (RESPONSE) %@", _data);
     }
     error:^(Fault *error) {
        NSLog(@"windowControllerDidLoadNib: (FAULT) %@", error.detail);
    }];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}

#pragma mark - Actions

-(void)removeTask:(NSTableView *)sender
{
    NSInteger row = [sender clickedRow];
    
    Task *task = [_data objectAtIndex:row];

    [backendless.persistenceService
     remove:[Task class]
     sid:task.objectId
     response:^(id res) {
        NSInteger index = [_data indexOfObject:task];
        [_tableView beginUpdates];
        [_tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationEffectFade];
        [_tableView endUpdates];
        [_data removeObject:task];
     }
     error:^(Fault *error) {
        NSLog(@"removeTask: (FAULT) %@", error.detail);
    }];
}

-(void)checkStatus:(NSTableView *)sender
{
    NSInteger row = [sender clickedRow];
    
    Task *task = [_data objectAtIndex:row];
    task.status = [NSNumber numberWithBool:!task.status.boolValue];
    
    [backendless.persistenceService
     save:task
     response:^(id res) {
     }
     error:^(Fault *error) {
        NSLog(@"checkStatus: (FAULT) %@", error.detail);
        task.status = [NSNumber numberWithBool:!task.status.boolValue];
        [_tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row] columnIndexes:[NSIndexSet indexSetWithIndex:[sender clickedColumn]]];
    }];
}

-(void)addNewTask:(NSTextField *)sender
{
    Task *task = [Task new];
    [sender setEnabled:NO];
    task.title = sender.stringValue;
    task.status = @NO;
    
    [backendless.persistenceService
     save:task
     response:^(id res) {
        [sender setEnabled:YES];
        [_data insertObject:res atIndex:0];
        [sender setStringValue:@""];
        [_tableView beginUpdates];
        [_tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withAnimation:NSTableViewAnimationEffectGap];
        [_tableView endUpdates];
     }
     error:^(Fault *error) {
        NSLog(@"addNewTask: (FAULT) %@", error.detail);
        [sender setEnabled:YES];
    }];
}

#pragma mark - Table View

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    Task *task = [_data objectAtIndex:rowIndex];
    if ([aTableColumn.identifier isEqualToString:@"Title"]) {
        return task.title;
    }
    else
    {
        return task.status;
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return _data.count;
}

- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    return YES;
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    if ([aTableColumn.identifier isEqualToString:@"Title"]) {
        Task *task = [_data objectAtIndex:rowIndex];
        NSString *title = task.title;
        task.title = anObject;
        
        [backendless.persistenceService
         save:task
         response:^(id res) {
         }
         error:^(Fault *error) {
            NSLog(@"setObjectValue: (FAULT) %@", error.detail);
            task.title = title;
            [_tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:rowIndex] columnIndexes:[NSIndexSet indexSetWithIndex:[aTableView selectedColumn]]];
        }];
    }
}

@end
