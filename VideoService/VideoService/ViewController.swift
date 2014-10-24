//
//  ViewController.swift
//  VideoService
//
//  Created by Vyacheslav Vdovichenko on 10/24/14.
//  Copyright (c) 2014 BACKENDLESS.COM. All rights reserved.
//

import UIKit
//import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate/*, IMediaStreamerDelegate*/ {

    @IBOutlet var btnPublish : UIButton!
    @IBOutlet var btnPlayback : UIButton!
    @IBOutlet var btnStopMedia : UIButton!
    @IBOutlet var btnSwapCamera : UIButton!
    @IBOutlet var preView : UIView!
    @IBOutlet var playbackView : UIImageView!
    @IBOutlet var textField : UITextField!
    @IBOutlet var lblLive : UILabel!
    @IBOutlet var switchView : UISwitch!
    @IBOutlet var netActivity : UIActivityIndicatorView!
    
    let VIDEO_TUBE = "videoTube"
    
    var backendless = Backendless.sharedInstance()
    
    var _publisher: MediaPublisher?
    var _player: MediaPlayer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchCamerasControl(sender: AnyObject) {
        
        println("----------------------- pswitchCamerasControl ------------------------------------------------------")
        
        _publisher?.switchCameras()
    }
    
    @IBAction func stopMediaControl(sender: AnyObject) {
        
        println("----------------------- stopMediaControl ------------------------------------------------------")
        
        if (_publisher != nil) {
            
            _publisher?.disconnect()
            _publisher = nil;
            
            self.preView.hidden = true
            self.btnStopMedia.hidden = true
            self.btnSwapCamera.hidden = true
        }
        
        if (_player != nil)
        {
            _player?.disconnect()
            _player = nil;
            self.playbackView.hidden = true
            self.btnStopMedia.hidden = true
        }
        
        self.btnPublish.hidden = false
        self.btnPlayback.hidden = false
        self.textField.hidden = false
        self.switchView.hidden = false
        self.lblLive.hidden = false
        
        self.netActivity.stopAnimating()
    }
    
    @IBAction func playbackControl(sender: AnyObject) {
        
        println("----------------------- playbackControl ------------------------------------------------------")
        
        var options: MediaPlaybackOptions
        if (switchView.on) {
            options = MediaPlaybackOptions.liveStream(self.playbackView) as MediaPlaybackOptions
        }
        else {
            options = MediaPlaybackOptions.recordStream(self.playbackView) as MediaPlaybackOptions
        }
        
        options.orientation = UIImageOrientation(rawValue: 0)! //UIImageOrientationUp
        options.isRealTime = switchView.on
        
        _player = backendless.mediaService.playbackStream(textField.text, tube:VIDEO_TUBE, options:options, responder:nil)
        
        self.btnPublish.hidden = true
        self.btnPlayback.hidden = true
        self.textField.hidden = true
        self.switchView.hidden = true
        self.lblLive.hidden = true
        
        //netActivity.startAnimating()
        
        // -- TEMPOPARY !!!
        self.playbackView.hidden = false
        self.btnStopMedia.hidden = false
        //
    
    }
    
    @IBAction func publishControl(sender: AnyObject) {
        
        println("----------------------- publishControl ------------------------------------------------------")
        
        var options: MediaPublishOptions
        if (switchView.on) {
            options = MediaPublishOptions.liveStream(self.preView) as MediaPublishOptions
        }
        else {
            options = MediaPublishOptions.recordStream(self.preView) as MediaPublishOptions
        }
        
        options.orientation = AVCaptureVideoOrientation(rawValue: 1)! //AVCaptureVideoOrientationPortrait
        options.resolution = RESOLUTION_CIF
        
        _publisher = backendless.mediaService.publishStream(textField.text, tube:VIDEO_TUBE, options:options, responder:nil)
        
        self.btnPublish.hidden = true
        self.btnPlayback.hidden = true
        self.textField.hidden = true
        self.switchView.hidden = true
        self.lblLive.hidden = true
        
        //netActivity.startAnimating()
        
        // -- TEMPOPARY !!!
        self.preView.hidden = false
        self.btnStopMedia.hidden = false
        self.btnSwapCamera.hidden = false
        //

    }
    
    @IBAction func viewTapped(sender: AnyObject) {
        textField.resignFirstResponder()
    }

    // UITextFieldDelegate protocol methods
    
    func textFieldShouldReturn(_textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    // MediaStreamerDelegate  protocol methods
    
    func streamStateChanged(sender: AnyObject, state: MPMediaStreamState, description: NSString) {
    }
    
    func streamConnectFailed(sender: AnyObject, code: Int, description: NSString) {
    }
}

