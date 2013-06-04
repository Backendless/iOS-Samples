//
//  ViewController.h
//  SimpleVideoService
//
//  Created by Sergey Kukurudzyak on 5/23/13.
//  Copyright (c) 2013 Sergey Kukurudzyak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *preview;
@property (strong, nonatomic) IBOutlet UIImageView *playbackView;
-(IBAction)onStopBtn:(id)sender;
-(IBAction)onPlayBtn:(id)sender;
-(IBAction)onRecordBtn:(id)sender;

@end
