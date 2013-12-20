//
//  Document.h
//  ToDoDataMac
//
//  Created by Yury Yaschenko on 10/1/13.
//  Copyright (c) 2013 BACKENDLESS.COM. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument<NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate>
@property (nonatomic, strong) IBOutlet NSTableView *tableView;
-(IBAction)checkStatus:(id)sender;
-(IBAction)addNewTask:(id)sender;
-(IBAction)removeTask:(id)sender;
@end
