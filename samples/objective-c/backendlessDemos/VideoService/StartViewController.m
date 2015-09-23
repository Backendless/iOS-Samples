//
//  StartViewController.m
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

#import "StartViewController.h"
#import "Backendless.h"
#import "MediaService.h"

//#define VIDEO_TUBE @"videoTube"
#define VIDEO_TUBE @"Default"
#define DEFAULT_STREAM_NAME @"defaultStreamName"

@interface StartViewController () <IMediaStreamerDelegate> {
    
    MediaPublisher *_publisher;
    MediaPlayer *_player;
    
    NSString *_streamName;
    BOOL _canShow;
    
    UIActivityIndicatorView *_netActivity;
}

-(void)showAlert:(NSString *)message;
-(void)initNetActivity;
@end


@implementation StartViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    _canShow = YES;
    _textField.inputAccessoryView = _accessoryView;
    _streamName = DEFAULT_STREAM_NAME;
    
    @try {
        
        [backendless initAppFault];
        
        [self initNetActivity];
    }
    @catch (Fault *fault) {
        NSLog(@"initAppFault -> %@", fault);
        [self showAlert:fault.message];
    }
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Private Methods

-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

-(void)initNetActivity {
    
    // isPad fixes kind of device: iPad (YES) or iPhone (NO)
    BOOL isPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    
	// Create and add the activity indicator
	_netActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:isPad?UIActivityIndicatorViewStyleGray:UIActivityIndicatorViewStyleWhiteLarge];
	_netActivity.center = isPad? CGPointMake(400.0f, 480.0f) : CGPointMake(160.0f, 240.0f);
	[self.view addSubview:_netActivity];
}

#pragma mark -
#pragma mark IBAction

-(IBAction)publishControl:(id)sender {
    
    NSLog(@"publishControl: -> backendless.mediaService: %@ [%@]", backendless.mediaService, [Types classByName:@"MediaService"]);
    
#if 1 // record "from the scratch" if it is not live
    MediaPublishOptions *options = _switchView.on?[MediaPublishOptions liveStream:self.preview]:[MediaPublishOptions recordStream:self.preview];
#else // "continued" record if it is not live
    MediaPublishOptions *options = _switchView.on?[MediaPublishOptions liveStream:self.preview]:[MediaPublishOptions appendStream:self.preview];
#endif
    options.orientation = AVCaptureVideoOrientationPortrait;
    options.resolution = RESOLUTION_VGA;
    _publisher =[backendless.mediaService publishStream:_streamName tube:VIDEO_TUBE options:options responder:self];
    
    NSLog(@"publishControl: -> published stream: '%@/%@'", _publisher.streamPath, _publisher.streamName);
    
    self.btnPublish.hidden = YES;
    self.btnPlayback.hidden = YES;
    self.textField.hidden = YES;
    _switchView.hidden = YES;
    _lable.hidden = YES;
    
    [_netActivity startAnimating];
}

-(IBAction)playbackControl:(id)sender {
    
    NSLog(@"playbackControl: -> backendless.mediaService: %@", backendless.mediaService);
    
    MediaPlaybackOptions *options = _switchView.on?[MediaPlaybackOptions liveStream:self.playbackView]:[MediaPlaybackOptions recordStream:self.playbackView];
    options.orientation = UIImageOrientationUp;
    options.isRealTime = _switchView.on;
    _player = [backendless.mediaService playbackStream:_streamName tube:VIDEO_TUBE options:options responder:self];
    
    NSLog(@"playbackControl: -> playing stream: '%@/%@'", _player.streamPath, _player.streamName);
    
    self.btnPublish.hidden = YES;
    self.btnPlayback.hidden = YES;
    self.textField.hidden = YES;
    _switchView.hidden = YES;
    _lable.hidden = YES;
    
    [_netActivity startAnimating];
}

-(IBAction)pauseControl:(id)sender {
    
    if (_publisher)
    {
        [_publisher pause];
        
        self.preview.hidden = YES;
        self.btnPauseMedia.hidden = YES;
        self.btnResumeMedia.hidden = NO;
    }
    
    if (_player)
    {
        [_player pause];
        
        self.playbackView.hidden = YES;
        self.btnPauseMedia.hidden = YES;
        self.btnResumeMedia.hidden = NO;
    }
}

-(IBAction)resumeControl:(id)sender {
    
    if (_publisher)
    {
        [_publisher resume];
        
        self.preview.hidden = NO;
        self.btnPauseMedia.hidden = NO;
        self.btnResumeMedia.hidden = YES;
    }
    
    if (_player)
    {
        [_player resume];
        
        self.playbackView.hidden = NO;
        self.btnPauseMedia.hidden = NO;
        self.btnResumeMedia.hidden = YES;
    }
}

-(IBAction)stopMediaControl:(id)sender {
    
    if (_publisher)
    {
        [_publisher disconnect];
        _publisher = nil;
        
        self.preview.hidden = YES;
    }
    
    if (_player)
    {
        [_player disconnect];
        _player = nil;
        self.playbackView.hidden = YES;
    }
    
    self.btnStopMedia.hidden = YES;
    self.btnPauseMedia.hidden = YES;
    self.btnResumeMedia.hidden = YES;
    self.btnSwapCamera.hidden = YES;
    
    self.btnPublish.hidden = NO;
    self.btnPlayback.hidden = NO;
    self.textField.hidden = NO;
    _switchView.hidden = NO;
    _lable.hidden = NO;
    
    [_netActivity stopAnimating];
}

-(IBAction)switchCamerasControl:(id)sender {
    
    if (_publisher)
        [_publisher switchCameras];
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
            
            [self stopMediaControl:sender];
            break;
        }
            
        case CONN_CONNECTED: {
            break;
        }
            
        case STREAM_CREATED: {
            break;
        }
            
        case STREAM_PLAYING: {
            
            // PUBLISHER
            if (_publisher) {
                
                if (!([description isEqualToString:MP_NETSTREAM_PUBLISH_START] || [description isEqualToString:MP_RTMP_CLIENT_STREAM_IS_PLAYING])) {
                    [self stopMediaControl:sender];
                    break;
                }
               
                self.preview.hidden = NO;
                self.btnStopMedia.hidden = NO;
                self.btnSwapCamera.hidden = NO;
                self.btnPauseMedia.hidden = NO;
                
                [_netActivity stopAnimating];
            }
           
            // PLAYER
            if (_player) {
                
                if ([description isEqualToString:MP_NETSTREAM_PLAY_STREAM_NOT_FOUND]) {
                    [self showAlert:[NSString stringWithString:description]];
                    [self stopMediaControl:sender];
                    break;
                }
            
                if (!([description isEqualToString:MP_NETSTREAM_PLAY_START] || [description isEqualToString:MP_RTMP_CLIENT_STREAM_IS_PLAYING])) {
                    [self showAlert:[NSString stringWithString:description]];
                    break;
                }
                
                [MPMediaData routeAudioToSpeaker];
                
                self.playbackView.hidden = NO;
                self.btnStopMedia.hidden = NO;
                self.btnPauseMedia.hidden = NO;
                
                [_netActivity stopAnimating];
            }
            break;
        }
            
        case STREAM_PAUSED: {
            
            if ([description isEqualToString:MP_RTMP_CLIENT_STREAM_IS_PAUSED]) {
                break;
            }
           
            if ([description isEqualToString:MP_NETSTREAM_PLAY_STREAM_NOT_FOUND]) {
                [self showAlert:[NSString stringWithString:description]];
            }
            
            [self stopMediaControl:sender];
            break;
        }
            
        default:
            break;
    }
}

-(void)streamConnectFailed:(id)sender code:(int)code description:(NSString *)description {
    
    NSLog(@"<IMediaStreamerDelegate> streamConnectFailed: %d = %@", code, description);
    
    [self stopMediaControl:sender];
    
    [self showAlert:(code == -1) ?
     [NSString stringWithFormat:@"Unable to connect to the server. Make sure the hostname/IP address and port number are valid\n"] :
     [NSString stringWithFormat:@"connectFailedEvent: %@ \n", description]];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(!_canShow)
    {
        _canShow = YES;
        return;
    }
    if (textField == _textField) {
        [[_accessoryView viewWithTag:1] performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.3];
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _textField.text = textField.text;
    _canShow = NO;
    [textField resignFirstResponder];
    [_textField resignFirstResponder];
    
    _streamName = (textField.text.length == 0)?DEFAULT_STREAM_NAME:textField.text;
    return YES;
}

@end
