//
//  StartViewController.h
//  VideoService
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

#import <UIKit/UIKit.h>

@interface StartViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnPublish;
@property (strong, nonatomic) IBOutlet UIButton *btnPlayback;
@property (strong, nonatomic) IBOutlet UIButton *btnPauseMedia;
@property (strong, nonatomic) IBOutlet UIButton *btnResumeMedia;
@property (strong, nonatomic) IBOutlet UIButton *btnStopMedia;
@property (strong, nonatomic) IBOutlet UIButton *btnSwapCamera;
@property (strong, nonatomic) IBOutlet UIView *preview;
@property (strong, nonatomic) IBOutlet UIImageView *playbackView;
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet UIView *accessoryView;
@property (nonatomic, strong) IBOutlet UISwitch *switchView;
@property (nonatomic, strong) IBOutlet UILabel *lable;
-(IBAction)switchCamerasControl:(id)sender;
-(IBAction)stopMediaControl:(id)sender;
-(IBAction)playbackControl:(id)sender;
-(IBAction)publishControl:(id)sender;
-(IBAction)pauseControl:(id)sender;
-(IBAction)resumeControl:(id)sender;
@end
