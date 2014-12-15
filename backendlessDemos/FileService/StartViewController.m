//
//  StartViewController.m
//  FileService
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
#import "ImagePreviewViewController.h"

@interface StartViewController ()
-(void)showAlert:(NSString *)message;
@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @try {
        [backendless initAppFault];
    }
    @catch (Fault *fault) {
        [self showAlert:fault.message];
    }
    
#if 1
    [self saveFile];
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

- (void)takePhoto:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.showsCameraControls = YES;
    }
    else
    {
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [self presentViewController:picker animated:YES completion:^{}];
}

- (void)saveFile {
    
#if 1
    NSData *bytes = [NSData dataWithBytes:"The quick brown fox jumps over the lazy dog" length:43];
    [backendless.fileService saveFile:@"txt/fox.txt" content:bytes overwriteIfExist:YES
                             response:^(BackendlessFile *uploadFile) {
                                 NSLog(@"UPLOADED %@", uploadFile);
                                 
                                 @try {
                                     [backendless.fileService.permissions denyForAllRoles:@"txt/fox.txt" operation:FILE_REMOVE];
                                 }
                                 @catch (Fault *fault) {
                                     NSLog(@"FAULT: %@", fault);
                                 }
                             }
                                error:^(Fault *fault) {
                                    NSLog(@"FAULT %@", fault);
                                }];
#endif
    
#if 0
    NSData *media = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sample" ofType:@"flv"]];
    NSLog(@">>>>>>>>> data = %@", media?@(media.length):nil);
    if (media && media.length) {
        NSString *path = [NSString stringWithFormat:@"media/%@.flv", [NSString stringWithFormat:@"sample_%@", [backendless randomString:6]]];
        BackendlessFile *uploadFile = [backendless.fileService saveFile:path content:media];
        NSLog(@">>>>>>>>> %@", uploadFile);
    }
#endif
}

- (void)saveFileWithPermission {
    
    @try {
        
        NSString *path = @"txt/fox.txt";
        NSData *bytes = [NSData dataWithBytes:"The quick brown fox jumps over the lazy dog" length:43];
        [backendless.fileService saveFile:path content:bytes overwriteIfExist:YES];
        
        [backendless.fileService.permissions denyForAllRoles:path operation:FILE_REMOVE];
        
        BackendlessUser *user = [backendless.userService login:@"bob@foo.com" password:@"bob"];
        NSString *roleName = [backendless.userService getUserRoles][0];
        [backendless.fileService.permissions grantForRole:roleName url:path operation:FILE_REMOVE];
    }
    @catch (Fault *fault) {
        NSLog(@"FAULT: %@", fault);
    }

}

#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        ImagePreviewViewController *imgPreview = [[self storyboard] instantiateViewControllerWithIdentifier:@"ImagePreviewViewController"];
        imgPreview.mainImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self.navigationController pushViewController:imgPreview animated:YES];
    }];  
}
@end
