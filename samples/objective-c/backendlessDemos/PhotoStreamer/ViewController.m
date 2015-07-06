//
//  ViewController.m
//  PhotoStreamer
//
//  Created by Slava Vdovichenko on 7/6/15.
//  Copyright (c) 2015 BACKENDLESS.COM. All rights reserved.
//

#import "ViewController.h"
#import <mach/mach_time.h>
#import "Backendless.h"
#import "MediaService.h"

//#define VIDEO_TUBE @"videoTube"
#define VIDEO_TUBE @"Default"
#define DEFAULT_STREAM_NAME @"photo"
#define DEFAULT_FPS 10


@interface ViewController () <IMediaStreamerDelegate> {
    MediaPublisher *_publisher;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    @try {
        
        [backendless initAppFault];
    }
    @catch (Fault *fault) {
        NSLog(@"initAppFault -> %@", fault);
        [self showAlert:fault.message];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Private Methods

-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

-(int64_t)getTimestampMs {
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    return 1e-6*mach_absolute_time()*info.numer/info.denom;
}

-(void)serialImage:(UIImage *)image times:(int)times {
    
    if (!_publisher)
        return;
    
    int64_t _timestamp = [self getTimestampMs];
    
    NSLog(@"serialImage: timestamp = %lld", _timestamp);
    
    [_publisher sendImage:[image CGImage] timestamp:_timestamp];
    
    if (!times--)
        return;

    dispatch_time_t interval = dispatch_time(DISPATCH_TIME_NOW, 1ull*NSEC_PER_MSEC*1000/DEFAULT_FPS);
    dispatch_after(interval, dispatch_get_main_queue(), ^{
        [self serialImage:image times:times];
    });

}

#pragma mark -
#pragma mark IBAction

-(IBAction)publish:(id)sender {
    
    if (_publisher)
        return;
    
    MediaPublishOptions *options = [MediaPublishOptions liveStream:nil];
    options.orientation = AVCaptureVideoOrientationPortrait;
    
    [options setCustomVideo:DEFAULT_FPS width:640 height:640];
   
    _publisher =[backendless.mediaService publishStream:DEFAULT_STREAM_NAME tube:VIDEO_TUBE options:options responder:self];
    
    NSLog(@"publishControl: -> published stream: '%@/%@'", _publisher.streamPath, _publisher.streamName);
    
    self.btnPublish.hidden = YES;
    
    [self.netActivity startAnimating];
}

-(IBAction)stop:(id)sender {
    
    if (_publisher)
    {
        [_publisher disconnect];
        _publisher = nil;
        
        self.btnPublish.hidden = NO;
        self.btnStop.hidden = YES;
        self.btnTakePhoto.hidden = YES;
        self.imageView.hidden = YES;
        
        [self.netActivity stopAnimating];
    }
}

-(IBAction)takePhoto:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark -
#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO]; // MAIN THREAD
    [self serialImage:image times:10];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
#pragma mark IMediaStreamerDelegate Methods

-(void)streamStateChanged:(id)sender state:(int)state description:(NSString *)description {
    
    NSLog(@"<IMediaStreamerDelegate> streamStateChanged: %d = %@", (int)state, description);
    
    switch (state) {
            
        case CONN_DISCONNECTED: {
            
            if ([description isEqualToString:MP_STREAM_IS_BUSY]) {
                [self showAlert:[NSString stringWithString:description]];
            }
            
            [self stop:sender];
            break;
        }
            
        case CONN_CONNECTED: {
            break;
        }
            
        case STREAM_CREATED: {
            break;
        }
            
        case STREAM_PLAYING: {
            
            if (!([description isEqualToString:MP_NETSTREAM_PUBLISH_START] || [description isEqualToString:MP_RTMP_CLIENT_STREAM_IS_PLAYING])) {
                [self stop:sender];
                break;
            }
            
            self.btnStop.hidden = NO;
            self.btnTakePhoto.hidden = NO;
            self.imageView.hidden = NO;
            
            [self.netActivity stopAnimating];
           
            break;
        }
            
        case STREAM_PAUSED: {
            
            if ([description isEqualToString:MP_RTMP_CLIENT_STREAM_IS_PAUSED]) {
                break;
            }
            
            if ([description isEqualToString:MP_NETSTREAM_PLAY_STREAM_NOT_FOUND]) {
                [self showAlert:[NSString stringWithString:description]];
            }
            
            [self stop:sender];
            break;
        }
            
        default:
            break;
    }
}

-(void)streamConnectFailed:(id)sender code:(int)code description:(NSString *)description {
    
    NSLog(@"<IMediaStreamerDelegate> streamConnectFailed: %d = %@", code, description);
    
    [self stop:sender];
    
    [self showAlert:(code == -1) ?
     [NSString stringWithFormat:@"Unable to connect to the server. Make sure the hostname/IP address and port number are valid\n"] :
     [NSString stringWithFormat:@"connectFailedEvent: %@ \n", description]];
}

@end
