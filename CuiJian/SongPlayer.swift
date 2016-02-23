//
//  SongPlayer.swift
//  CuiJian
//
//  Created by Rick on 16/2/22.
//  Copyright © 2016年 Rick. All rights reserved.
//

import UIKit
import AVFoundation

//TODO: AVAudioPlayerDelegate
class SongPlayer {
    var player: AVAudioPlayer?
    var playTriangleLayer: CALayer!
    var playerCircle: CAShapeLayer!
    
    //MARK: - player
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
    
    func stopPlayer(){
        player!.stop()
        //TODO: animation reset
    }
    
    func pausePlayer() {
        player!.stop()
        playerAnimationPause(playerCircle)
    }
    
    func resumePlayer() {
        player!.play()
        playerAnimationResume(playerCircle)
    }
    
    //MARK: - animation
    func setupBtnLayer(spView: UIView) {
        let bgLayer = CAShapeLayer()
        bgLayer.path = UIBezierPath(ovalInRect: CGRect(origin: CGPoint.zero, size: spView.bounds.size)).CGPath
        bgLayer.fillColor = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1).CGColor
        bgLayer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).CGColor
        bgLayer.shadowOffset = CGSize(width: 0, height: 9)
        
        spView.layer.addSublayer(bgLayer)
        
        playTriangleLayer = CALayer()
        playTriangleLayer.bounds.size = CGSize(width: spView.bounds.width * 0.5, height: spView.bounds.height * 0.5)
        playTriangleLayer.frame.origin = CGPoint(x: (spView.bounds.width - playTriangleLayer.bounds.width)/2, y: (spView.bounds.height - playTriangleLayer.bounds.height)/2)
        playTriangleLayer.contents = UIImage(named: "playTriangle")?.CGImage
        spView.layer.addSublayer(playTriangleLayer)
        
        setupCircleLayer(spView)
    }
    
    func setupCircleLayer(spView: UIView) {
        playerCircle = CAShapeLayer()
        let lineWidth: CGFloat = 3
        
        let arcCenter = CGPoint(x: CGRectGetMidX(spView.bounds), y: CGRectGetMidY(spView.bounds))
        let radius = fmin(CGRectGetMidX(spView.bounds), CGRectGetMidY(spView.bounds)) - lineWidth/2
        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: degreeToRadian(-90), endAngle: degreeToRadian(-90 + 180), clockwise: true)
        
        spView.layer.addSublayer(playerCircle)
        playerCircle.path = circlePath.CGPath
        playerCircle.fillColor = UIColor.clearColor().CGColor
        playerCircle.lineWidth = lineWidth
        playerCircle.strokeColor = UIColor(red: 187/255.0, green: 177/255.0, blue: 141/255.0, alpha: 1).CGColor
        
        playerCircle.strokeStart = 0.0
        playerCircle.strokeEnd = 1.0
        
        playerAnimation(playerCircle)
        playerCircle.speed = 0.0
    }
    
    func degreeToRadian(degree: CGFloat) -> CGFloat {
        return CGFloat(M_PI / 180) * degree
    }
    
    func playerAnimation(layer: CALayer) {
        let playerAnimation = CABasicAnimation(keyPath: "strokeEnd")
        playerAnimation.duration = player!.duration
        playerAnimation.fromValue = 0
        playerAnimation.toValue = 1
        playerAnimation.autoreverses = false
        playerAnimation.repeatCount = 0
        
        layer.addAnimation(playerAnimation, forKey: "playerAnimation")
    }
    
    func playerAnimationPause(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        layer.speed = 0.0;
        layer.timeOffset = pausedTime;
        playTriangleLayer.contents = UIImage(named: "playTriangle")?.CGImage
    }
    
    func playerAnimationResume(layer: CALayer) {
        let pausedTime = layer.timeOffset
        layer.speed = 1
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        layer.beginTime = timeSincePause;
        playTriangleLayer.contents = UIImage(named: "pauseBtn")?.CGImage
    }
    
}

