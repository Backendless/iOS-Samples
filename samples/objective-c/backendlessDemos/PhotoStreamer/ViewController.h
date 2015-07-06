//
//  ViewController.h
//  PhotoStreamer
//
//  Created by Slava Vdovichenko on 7/6/15.
//  Copyright (c) 2015 BACKENDLESS.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *btnPublish;
@property (strong, nonatomic) IBOutlet UIButton *btnStop;
@property (strong, nonatomic) IBOutlet UIButton *btnTakePhoto;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *netActivity;
-(IBAction)publish:(id)sender;
-(IBAction)stop:(id)sender;
-(IBAction)takePhoto:(id)sender;
@end

