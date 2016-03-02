//
//  SongPlayer.swift
//  CuiJian
//
//  Created by Rick on 16/2/22.
//  Copyright © 2016年 Rick. All rights reserved.
//

import UIKit
import AVFoundation

class SongPlayer: NSObject, AVAudioPlayerDelegate {
    var player: AVAudioPlayer?
    var playTriangleLayers: [CALayer!] = [nil,nil,nil,nil,nil,nil,nil,nil,nil]
    var playerCircles: [CAShapeLayer!] = [nil,nil,nil,nil,nil,nil,nil,nil,nil]
    
    var curIndex: Int?
    
    let songDatas:[String] = ["01guangdong.mp3","02sibuhuitou.mp3","03yuniaozhilian.mp3","04waimiandeniu.mp3","05kuguashu.mp3","06jinsezaochen.mp3","07gundongdedan.mp3","08hunshuihumanbu.mp3","09yangguangxiademeng.mp3"]
    let songDuration: [NSTimeInterval] = [NSTimeInterval(453.56),NSTimeInterval(249.213333333333),NSTimeInterval(378.96),NSTimeInterval(483.866666666667),NSTimeInterval(318.813333333333),NSTimeInterval(308.44),NSTimeInterval(446.72),NSTimeInterval(262.066666666667),NSTimeInterval(298.333333333333)]
    
    //MARK: - player
    func loadSong(index:Int) {
        if index >= songDatas.count || index < 0 {
            return
        }
        curIndex = index
        let fileFullName = songDatas[index]
        let strSplit = fileFullName.componentsSeparatedByString(".")
        let fileName = String(strSplit[0])
        let fileType = String(strSplit[1])
        
        if let songPlayer = setupAudioPlayerWithFile(fileName, type: fileType) {
            player = songPlayer
        }
    }
    
    func playNewSong(index: Int) {
        // stop old song
        stopPlayer(curIndex!)
        // load new song
        loadSong(index)
        resumePlayer(index)
        curIndex = index
    }
    
    func setupAudioPlayerWithFile(file: String, type: String) -> AVAudioPlayer? {
        let path = NSBundle.mainBundle().pathForResource(file, ofType: type)
        let url = NSURL.fileURLWithPath(path!)
        
        var audioPlayer: AVAudioPlayer?
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("wrong audio")
        }
        
        return audioPlayer
    }
    
    func stopPlayer(index: Int){
        player!.stop()
        player!.currentTime = 0
        playerAnimationReset(index)
    }
    
    func pausePlayer(index: Int) {
        player!.stop()
        playerAnimationPause(index)
    }
    
    func resumePlayer(index: Int) {
        player!.play()
        playerAnimationResume(index)
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        stopPlayer(curIndex!)
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        stopPlayer(curIndex!)
    }
    
    //MARK: - animation
    func setupPlayerBtnLayer(spView: UIView, index: Int) {
        let bgLayer = CAShapeLayer()
        bgLayer.path = UIBezierPath(ovalInRect: CGRect(origin: CGPoint.zero, size: spView.bounds.size)).CGPath
        bgLayer.fillColor = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1).CGColor
        bgLayer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).CGColor
        bgLayer.shadowOffset = CGSize(width: 0, height: 9)
        
        spView.layer.addSublayer(bgLayer)
        
        playTriangleLayers[index] = CALayer()
        playTriangleLayers[index].bounds.size = CGSize(width: spView.bounds.width * 0.5, height: spView.bounds.height * 0.5)
        playTriangleLayers[index].frame.origin = CGPoint(x: (spView.bounds.width - playTriangleLayers[index].bounds.width)/2, y: (spView.bounds.height - playTriangleLayers[index].bounds.height)/2)
        
        if index == curIndex && player!.playing {
            playTriangleLayers[index].contents = UIImage(named: "pauseBtn")?.CGImage
        } else {
            playTriangleLayers[index].contents = UIImage(named: "playTriangle")?.CGImage
        }
        
        spView.layer.addSublayer(playTriangleLayers[index])
        
        setupCircleLayer(spView, index: index)
    }
    
    func setupCircleLayer(spView: UIView, index: Int) {
        playerCircles[index] = CAShapeLayer()
        let lineWidth: CGFloat = 3
        
        let arcCenter = CGPoint(x: CGRectGetMidX(spView.bounds), y: CGRectGetMidY(spView.bounds))
        let radius = fmin(CGRectGetMidX(spView.bounds), CGRectGetMidY(spView.bounds)) - lineWidth/2
        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: degreeToRadian(-90), endAngle: degreeToRadian(-90 + 180), clockwise: true)
        
        spView.layer.addSublayer(playerCircles[index])
        playerCircles[index].path = circlePath.CGPath
        playerCircles[index].fillColor = UIColor.clearColor().CGColor
        playerCircles[index].lineWidth = lineWidth
        playerCircles[index].strokeColor = UIColor(red: 187/255.0, green: 177/255.0, blue: 141/255.0, alpha: 1).CGColor
        
        
        playerCircles[index].strokeStart = 0.0
        playerCircles[index].strokeEnd = 1.0
        
        playerAnimation(index)
        playerCircles[index].speed = 0.0
    }
    
    func degreeToRadian(degree: CGFloat) -> CGFloat {
        return CGFloat(M_PI / 180) * degree
    }
    
    func playerAnimation(index: Int) {
        let layer = playerCircles[index]
        let playerAnimation = CABasicAnimation(keyPath: "strokeEnd")
        playerAnimation.duration = songDuration[index]
        
        if curIndex == index && player!.playing {
            let stokeStart = (player?.currentTime)! / (player?.duration)!
            playerAnimation.fromValue = CGFloat(stokeStart)
        } else {
            playerAnimation.fromValue = 0
        }
        playerAnimation.toValue = 1
        playerAnimation.autoreverses = false
        playerAnimation.repeatCount = 0
        
        layer.addAnimation(playerAnimation, forKey: "playerAnimation")
    }
    
    func playerAnimationPause(index: Int) {
        let layer = playerCircles[index]
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        layer.speed = 0.0;
        layer.timeOffset = pausedTime;
        playTriangleLayers[index].contents = UIImage(named: "playTriangle")!.CGImage
    }
    
    func playerAnimationReset(index: Int) {
        let layer = playerCircles[index]
        layer.speed = 0
        layer.timeOffset = 0
        layer.beginTime = 0
        playTriangleLayers[index].contents = UIImage(named: "playTriangle")!.CGImage
    }
    
    func playerAnimationResume(index: Int) {
        let layer = playerCircles[index]
        let pausedTime = layer.timeOffset
        layer.speed = 1
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        layer.beginTime = timeSincePause;
        playTriangleLayers[index].contents = UIImage(named: "pauseBtn")!.CGImage
    }
    
}

