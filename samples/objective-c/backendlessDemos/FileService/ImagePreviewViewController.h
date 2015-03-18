//
//  ImagePreviewViewController.h
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

#import <UIKit/UIKit.h>
#import "BEFile.h"

@interface ImagePreviewViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) BEFile *file;
@property (nonatomic, strong) IBOutlet UIImageView *mainImageView;
@property (nonatomic, strong) IBOutlet UIButton *uploadBtn;
@property (nonatomic, strong) IBOutlet UILabel *urlLable;
@property (nonatomic, strong) UIImage *mainImage;
@property (nonatomic) BOOL isUpload;
@property (nonatomic, strong) IBOutlet UITextField *pathField;
- (IBAction)upload:(id)sender;
@end
