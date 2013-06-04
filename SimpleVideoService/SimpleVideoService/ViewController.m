//
//  ViewController.m
//  SimpleVideoService
//
//  Created by Sergey Kukurudzyak on 5/23/13.
//  Copyright (c) 2013 Sergey Kukurudzyak. All rights reserved.
//

#import "ViewController.h"
#import "Backendless.h"

#define VIDEO_TUBE @"videoTube"
#define STREAM_NAME @"defaultStreamName"

@interface ViewController () <IMediaStreamerDelegate>
{
    MediaPublisher *_publisher;
    MediaPlayer *_player;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onPlayBtn:(id)sender
{
    MediaPlaybackOptions *options = [MediaPlaybackOptions recordStream:self.playbackView];
    _player = [backendless.mediaService playbackStream:STREAM_NAME tube:VIDEO_TUBE options:options responder:self];
}

- (void)onRecordBtn:(id)sender
{
    MediaPublishOptions *options = [MediaPublishOptions recordStream:self.preview];
    _publisher =[backendless.mediaService publishStream: STREAM_NAME tube:VIDEO_TUBE options:options responder:self];
}

-(void)onStopBtn:(id)sender
{
    if (_publisher)
    {
        [_publisher disconnect];
        _publisher = nil;
    }
    
    if (_player)
    {
        [_player disconnect];
        _player = nil;
    }
}

-(void) streamConnectFailed:(id)sender code:(int)code description:(NSString *)description
{
    NSLog(@"<IMediaStreamerDelegate> streamConnectFailed: %d = %@", (int)code, description);
    [self onStopBtn:sender];
    
    NSString *message = (code == -1) ?
    @"Unable to connect to the server. Make sure the hostname/IP address and port number are valid\n" :
    [NSString stringWithFormat:@"connectFailedEvent: %@ \n", description];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

-(void) streamStateChanged:(id)sender state:(StateMediaStream)state description:(NSString *)description
{
    switch (state) {
            
        case MEDIASTREAM_DISCONNECTED: {
            
            [self onStopBtn:sender];
            break;
        }
            
        case MEDIASTREAM_PAUSED: {
            
            [self onStopBtn:sender];
            break;
        }
            
        case MEDIASTREAM_PLAYING: {
            
            // PUBLISHER
            if (_publisher) {
                
                if (![description isEqualToString:@"NetStream.Publish.Start"]) {
                    [self onStopBtn:sender];
                    break;
                }
            }
            
            // PLAYER
            if (_player) {
                
                if (![description isEqualToString:@"NetStream.Play.Start"]) {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error:" message:[NSString stringWithString:description] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [av show];
                    break;
                }
                
                self.playbackView.hidden = NO;
            }
            break;
        }
            
        default:
            break;
    }
}

@end
