//
//  GameViewController.swift
//  CuiJian
//
//  Created by Rick on 16/1/11.
//  Copyright (c) 2016年 Rick. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import CoreMotion
import MediaPlayer

class GameViewController: UIViewController, SCNSceneRendererDelegate {

    @IBOutlet var rootView: UIView!
    @IBOutlet weak var sceneView: SCNView!
    
    var videoControlView: UIView?
    var videoView: UIView?
    var guideView: UIView?
    var icePlayer: MPMoviePlayerController?
    
    var motionManager: CMMotionManager?
    let camerasNode: SCNNode? = SCNNode()
    var cameraRollNode: SCNNode?
    var cameraPitchNode: SCNNode?
    var cameraYawNode: SCNNode?
    let groundPos :CGFloat = -20
    var ufoNode :SCNNode?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
        
        // 第一次使用应用
        let defaults = NSUserDefaults.standardUserDefaults()
        let isFirstUse = defaults.boolForKey("isFirstUse")
        if !isFirstUse {
            // video
            loadGuideView()
            loadVideo()
            addVideoControlView()
            
            defaults.setBool(true, forKey: "isFirstUse")
        }
        
        
        
        let groudPos: CGFloat = -20
        
        // MARK:- 3D Scene
        // Create Scene
=======
        self.sceneView.delegate = self
        self.loadGuideView()
        self.loadVideo()
        self.addVideoControlView()
    }
    
    func initSence(){
>>>>>>> origin/master
        let rootScene = SCNScene()
        self.sceneView!.scene = rootScene
        self.sceneView!.autoenablesDefaultLighting = true
        
        let camera = SCNCamera()
        camera.xFov = 45
        camera.yFov = 45
        camera.zFar = 2000
        
        self.camerasNode!.camera = camera
        self.camerasNode!.position = SCNVector3(0,20,0)
        self.camerasNode!.eulerAngles = SCNVector3Make(GLKMathDegreesToRadians(-90), 0, 0)
        
        let cameraRollNode = SCNNode()
        cameraRollNode.addChildNode(camerasNode!)
        let cameraPitchNode = SCNNode()
        cameraPitchNode.addChildNode(cameraRollNode)
        let cameraYawNode = SCNNode()
        cameraYawNode.addChildNode(cameraPitchNode)
        rootScene.rootNode.addChildNode(cameraYawNode)
        self.sceneView!.pointOfView = camerasNode
        self.motionManager = CMMotionManager()
        self.motionManager?.deviceMotionUpdateInterval = 1/60
        self.motionManager?.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XArbitraryZVertical, toQueue: NSOperationQueue.mainQueue(), withHandler: { (motion: CMDeviceMotion?, error: NSError?) -> Void in
            let currentAttitude = motion!.attitude
            let roll = Float(currentAttitude.roll)
            let pitch = Float(currentAttitude.pitch)
            let yaw = Float(currentAttitude.yaw)
            cameraRollNode.eulerAngles = SCNVector3Make(0, 0, -roll)
            cameraPitchNode.eulerAngles = SCNVector3Make(pitch, 0, 0)
            cameraYawNode.eulerAngles = SCNVector3Make(0, yaw, 0)
            if fabs(roll) > 3.14 / 9.0 && self.guideView != nil{
                self.removeGuide()
            }
        })
        
        rootScene.background.contents = [UIImage(named: "skybox1")!,UIImage(named: "skybox2")!,UIImage(named: "skybox3")!,UIImage(named: "skybox4")!,UIImage(named: "skybox5")!,UIImage(named: "skybox6")!] as NSArray
        
        // Floor ground
        let floor = SCNFloor()
        floor.reflectivity = 0
        floor.firstMaterial!.diffuse.contents = UIImage(named: "ground")
        let floorNode = SCNNode()
        floorNode.geometry = floor
        floorNode.position = SCNVector3(0, groundPos, 0)
        rootScene.rootNode.addChildNode(floorNode)

    }
    
    func addNode(duration:CFTimeInterval, fileName: String) -> SCNNode {
        var node = SCNNode()
        if let subScene = SCNScene(named: "art.scnassets/\(fileName)") {
            if let subNode = subScene.rootNode.childNodes.first {
                node = subNode
                if duration > 0{
                    stopAnimation(duration, node: node);
                }
            }
        }
        return node
    }
    
    func stopAnimation(duration:CFTimeInterval, node:SCNNode){
        for key in node.animationKeys{
            let animation = node.animationForKey(key)!
            animation.duration = duration
            node.removeAnimationForKey(key)
            node.addAnimation(animation, forKey: key)
        }
        for n in node.childNodes{
            self.stopAnimation(duration, node: n)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        self.navigationController?.navigationBarHidden = true
        //add observer to video player
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoEnd", name: MPMoviePlayerPlaybackDidFinishNotification, object: icePlayer)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        // remove observer
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func renderer(aRenderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval)
    {

    }
    
    // MARK: - Video
    func loadVideo() {
        let path = NSBundle.mainBundle().pathForResource("ice", ofType:"mov")
        let url = NSURL(fileURLWithPath: path!)
        if let moviePlayer = MPMoviePlayerController(contentURL: url) {
            self.icePlayer = moviePlayer
            moviePlayer.view.frame = self.view.bounds
            moviePlayer.scalingMode = .AspectFill
            moviePlayer.fullscreen = true
            moviePlayer.prepareToPlay()
            moviePlayer.controlStyle = .None
            moviePlayer.shouldAutoplay = false
            videoView = moviePlayer.view
            self.view.addSubview(videoView!)
        }
    }
    
    func addVideoControlView() {
        videoControlView = UIView.loadFromNibNamed("VideoControlView")
        videoControlView!.frame = self.view.bounds
        self.view.addSubview(videoControlView!)
        let tapGesture = UITapGestureRecognizer(target: self, action: "playIceVideo")
        videoControlView!.addGestureRecognizer(tapGesture)
    }
    
    func playIceVideo() {
        self.videoControlView!.removeFromSuperview()
        self.videoControlView = nil
        self.icePlayer?.play()
    }
    
    func videoEnd() {
        self.initSence()
        self.icePlayer = nil
        self.videoView?.removeFromSuperview()
        self.videoView = nil
    }
    
    // guide view
    func loadGuideView() {
        self.guideView = UIView.loadFromNibNamed("GuideView")
        self.guideView!.frame = self.view.bounds
        self.view.addSubview(self.guideView!)
        let tapGesture = UITapGestureRecognizer(target: self, action: "removeGuide")
        self.guideView!.addGestureRecognizer(tapGesture)
    }
    
    func removeGuide() {
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.guideView?.alpha = 0
            }) { (finished) -> Void in
                self.guideView?.removeFromSuperview()
                self.guideView = nil
        }
    }
    
}


// MARK: - ContentViewController
// description: by doing this can use navigationController
extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController!
        } else {
            return self
        }
    }
}

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}





