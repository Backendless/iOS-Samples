//
//  ViewController.swift
//  VideoService
/*
* *********************************************************************************************************************
*
*  BACKENDLESS.COM CONFIDENTIAL
*
*  ********************************************************************************************************************
*
*  Copyright 2014 BACKENDLESS.COM. All Rights Reserved.
*
*  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
*  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
*  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
*  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
*  unless prior written permission is obtained from Backendless.com.
*
*  ********************************************************************************************************************
*/

import UIKit

class ViewController: UIViewController, IMediaStreamerDelegate {

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
    
    var backendless = Backendless.sharedInstance()
    
    var _publisher: MediaPublisher?
    var _player: MediaPlayer?
    
    let VIDEO_TUBE = "Default"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //registerUser()
        //userLogin()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func registerUser() {
        
        Types.tryblock({ () -> Void in
            
            let user = BackendlessUser()
            user.email = "bob@foo.com"
            user.password = "bob"
            
            let registeredUser = self.backendless.userService.registering(user)
            print("User has been registered (SYNC): \(registeredUser)")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            }
        )
    }

    func userLogin() {
        
        // - sync methods with fault as exception (full "try/catch/finally" version)
        Types.tryblock({ () -> Void in
            
            // - user login
            let user = self.backendless.userService.login("bob@foo.com", password:"bob")
            print("LOGINED USER: \(user)")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            }
        )
    }

    
    // IBActions
    
    @IBAction func switchCamerasControl(sender: AnyObject) {
        
        print("----------------------- switchCamerasControl ------------------------------------------------------")
        
        _publisher?.switchCameras()
    }
    
    @IBAction func stopMediaControl(sender: AnyObject) {
        
        print("----------------------- stopMediaControl ------------------------------------------------------")
        
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
        self.textField.enabled = true
        self.switchView.enabled = true
        
        self.netActivity.stopAnimating()
    }
    
    @IBAction func playbackControl(sender: AnyObject) {
        
        print("----------------------- playbackControl ------------------------------------------------------")
        
        var options: MediaPlaybackOptions
        if (switchView.on) {
            options = MediaPlaybackOptions.liveStream(self.playbackView) as! MediaPlaybackOptions
        }
        else {
            options = MediaPlaybackOptions.recordStream(self.playbackView) as! MediaPlaybackOptions
        }
        
        options.orientation = .Up
        options.isRealTime = switchView.on
        
        _player = backendless.mediaService.playbackStream(textField.text, tube:VIDEO_TUBE, options:options, responder:self)
        
        self.btnPublish.hidden = true
        self.btnPlayback.hidden = true
        self.textField.enabled = false
        self.switchView.enabled = false
        
        self.netActivity.startAnimating()
    }
    
    @IBAction func publishControl(sender: AnyObject) {
        
        print("----------------------- publishControl ------------------------------------------------------")
        
        var options: MediaPublishOptions
        if (switchView.on) {
            options = MediaPublishOptions.liveStream(self.preView) as! MediaPublishOptions
        }
        else {
            options = MediaPublishOptions.recordStream(self.preView) as! MediaPublishOptions
        }
        
        let mode = 0 // 0 - VIDEO & AUDIO, 1 - ONLY AUDIO, 2 - ONLY VIDEO
        
        switch mode {
            
        case 0: //VIDEO & AUDIO
            options.orientation = .Portrait
            options.resolution = RESOLUTION_CIF
            
        case 1: //ONLY AUDIO
            options.content = ONLY_AUDIO
            
        case 2: //ONLY VIDEO
            options.orientation = .Portrait
            options.resolution = RESOLUTION_CIF
            options.content = ONLY_VIDEO
        
        default:
            return
        }
        
        _publisher = backendless.mediaService.publishStream(textField.text, tube:VIDEO_TUBE, options:options, responder:self)
        
        self.btnPublish.hidden = true
        self.btnPlayback.hidden = true
        self.textField.enabled = false
        self.switchView.enabled = false
        
        self.netActivity.startAnimating()
    }
    
    @IBAction func viewTapped(sender: AnyObject) {
        textField.resignFirstResponder()
    }

    // UITextFieldDelegate protocol methods
    
    func textFieldShouldReturn(_textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    // MediaStreamerDelegate protocol methods
    
    func streamStateChanged(sender: AnyObject!, state: Int32, description: String!) {
        
        print("<IMediaStreamerDelegate> streamStateChanged: \(state) = \(description)");
        
        switch state {
        
        case 0: //CONN_DISCONNECTED
            
            stopMediaControl(sender)
            return
        
        case 1: //CONN_CONNECTED
            return
        
        case 2: //STREAM_CREATED

            self.btnStopMedia.hidden = false
            return
        
        case 3: //STREAM_PLAYING
            
            // PUBLISHER
            if (_publisher != nil) {
                
                if (description != "NetStream.Publish.Start") {
                    stopMediaControl(sender)
                    return
                }
                
                self.preView.hidden = false
                self.btnSwapCamera.hidden = false
                
                netActivity.stopAnimating()
            }
            
            // PLAYER
            if (_player != nil) {
                
                if (description == "NetStream.Play.StreamNotFound") {
                    stopMediaControl(sender)
                    return
                }
                
                if (description != "NetStream.Play.Start") {
                    return
                }
                
                MPMediaData.routeAudioToSpeaker()
               
                self.playbackView.hidden = false
                
                netActivity.stopAnimating()
            }
            
            return
        
        case 4: //STREAM_PAUSED
            
            if (description == "NetStream.Play.StreamNotFound") {
            }
            
            stopMediaControl(sender)
            return
        
        default:
            return
        }
    }
    
    func streamConnectFailed(sender: AnyObject!, code: Int32, description: String!) {
        
        print("<IMediaStreamerDelegate> streamConnectFailed: \(code) = \(description)");
        
        stopMediaControl(sender)
    }

}

