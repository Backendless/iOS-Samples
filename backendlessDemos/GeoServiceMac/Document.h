//
//  Document.h
//  GeoServiceMac
//
//  Created by Yury Yaschenko on 10/3/13.
//  Copyright (c) 2013 BACKENDLESS.COM. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument<NSTableViewDataSource, NSTableViewDelegate>
@property (nonatomic, strong) IBOutlet NSTableView *tableView;
- (IBAction)changeRadius:(id)sender;
@end
