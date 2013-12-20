//
//  Document.h
//  FileServiceMac
//
//  Created by Yury Yaschenko on 10/3/13.
//  Copyright (c) 2013 BACKENDLESS.COM. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument
@property (nonatomic, strong) IBOutlet NSTableView *tableView;

-(IBAction)deleteFile:(id)sender;
-(IBAction)uploadFile:(id)sender;
-(IBAction)downloadFile:(id)sender;
@end
