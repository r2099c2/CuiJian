//
//  AppDelegate.swift
//  CuiJian
//
//  Created by Rick on 16/1/11.
//  Copyright © 2016年 Rick. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {

    var window: UIWindow?
    var songPlayer = SongPlayer()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        songPlayer.loadSong()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let lastupdateTime = defaults.stringForKey("lastupdateTime")
        var today:NSString = "\(NSDate())"
        today = today.substringToIndex(10)
        if lastupdateTime == nil || lastupdateTime != today{
            HelperFuc.refreshData()
            defaults.setObject(today, forKey: "lastupdateTime")
        }
        WXApi.registerApp("wxca0cdbe9306c44da", withDescription: "崔健")
        
        TCPlayerView.setPlayerBottomViewClass(TCPlayerBottomView)
        TCPlayerView.setPlayerCtrlViewClass(TCCloudPlayerControlView)
        
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return WXApi.handleOpenURL(url, delegate: self)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return WXApi.handleOpenURL(url, delegate: self)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        
        NSNotificationCenter.defaultCenter().postNotificationName("applicationDidEnterBackground", object: nil)

    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        UIScreen.mainScreen().brightness = 1.0;
        NSNotificationCenter.defaultCenter().postNotificationName("applicationWillEnterForeground", object: nil)

        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        //UIApplication.sharedApplication().endReceivingRemoteControlEvents()
        self.resignFirstResponder()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        if event!.type == UIEventType.RemoteControl {
            if event!.subtype == UIEventSubtype.RemoteControlNextTrack {
                // 下一曲
                if songPlayer.curIndex == (songPlayer.songDatas.count - 1) {
                    songPlayer.curIndex = 0
                } else {
                    songPlayer.curIndex = songPlayer.curIndex + 1
                }
                songPlayer.playNewSong(songPlayer.curIndex)
            } else if event!.subtype == UIEventSubtype.RemoteControlPreviousTrack {
                // 上一曲
                if songPlayer.curIndex == 0 {
                    songPlayer.curIndex = (songPlayer.songDatas.count - 1)
                } else {
                    songPlayer.curIndex = songPlayer.curIndex - 1
                }
                songPlayer.playNewSong(songPlayer.curIndex)
            } else if event!.subtype == UIEventSubtype.RemoteControlPause{
                // 暂停按钮
                songPlayer.pausePlayer()
            } else if event!.subtype == UIEventSubtype.RemoteControlPlay{
                // 播放按钮
                songPlayer.resumePlayer()
            }
        }
    }


}

