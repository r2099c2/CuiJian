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

class GameViewController: UIViewController, SCNSceneRendererDelegate, UIGestureRecognizerDelegate {

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
    var player:AVAudioPlayer?
    var clickPlayer:AVAudioPlayer?
    var hints:[SCNNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.alpha = 0
        do {
            try self.player = AVAudioPlayer(contentsOfURL: NSURL(string: NSBundle.mainBundle().pathForResource("bg", ofType: "mp3")!)!)
            self.player?.numberOfLoops = Int.max
            
            try self.clickPlayer = AVAudioPlayer(contentsOfURL: NSURL(string: NSBundle.mainBundle().pathForResource("click", ofType: "mp3")!)!)
            self.clickPlayer?.numberOfLoops = 0
        } catch {
            print("wrong audio")
        }
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)

        self.navigationController!.interactivePopGestureRecognizer!.delegate = self

        self.view.backgroundColor = UIColor.blackColor()
        self.sceneView!.backgroundColor = UIColor.blackColor()
        self.sceneView.delegate = self

        // 第一次使用应用
        let defaults = NSUserDefaults.standardUserDefaults()
        let isFirstUse = defaults.boolForKey("isFirstUse")
        if !isFirstUse {
            // video
            self.loadGuideView()
            self.loadVideo()
            self.addVideoControlView()
            defaults.setBool(true, forKey: "isFirstUse")
        }
        self.initSence()
    }
    
    func ApplicationDidEnterBackground(){
        self.player?.stop()
    }
    func ApplicationWillEnterForeground(){
        if (UIApplication.sharedApplication().delegate as! AppDelegate).songPlayer.player?.playing != true{
            self.player?.play()
        }
    }
    
    func tapHandle(recognizer: UITapGestureRecognizer) {
        let location = recognizer.locationInView(self.sceneView)
        let hitResults = self.sceneView!.hitTest(location, options: nil)
        if hitResults.count > 0 {
        let hitedNode =  hitResults[0].node
            if hitedNode.name?.hasPrefix("icetree_") == true{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewControllerWithIdentifier("songViewController") as UIViewController
                self.navigationController!.pushViewController(controller, animated: true)
                self.clickPlayer?.play()
            }
            else if hitedNode.name?.hasPrefix("ufo_") == true{
                let newsController:NewsViewController = NewsViewController();
                self.navigationController!.pushViewController(newsController, animated: true)
                self.clickPlayer?.play()
            }
            else if hitedNode.name?.hasPrefix("team_") == true{
                let storyboard = UIStoryboard(name: "MVStoryboard", bundle: nil)
                let controller = storyboard.instantiateViewControllerWithIdentifier("aboutController") as UIViewController
                self.navigationController!.pushViewController(controller, animated: true)
                self.clickPlayer?.play()
            }
            else if hitedNode.name?.hasPrefix("mvs_") == true{
                let storyboard = UIStoryboard(name: "MVStoryboard", bundle: nil)
                let controller = storyboard.instantiateViewControllerWithIdentifier("MvController") as UIViewController
                self.navigationController!.pushViewController(controller, animated: true)
                self.clickPlayer?.play()
            }
        }
    }
    
    func initSence(){
        let rootScene = SCNScene()
        self.sceneView!.scene = rootScene
        self.sceneView!.autoenablesDefaultLighting = true
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tapHandle:"))
        self.sceneView!.addGestureRecognizer(tapGesture)
        
        let camera = SCNCamera()
        camera.xFov = 45
        camera.yFov = 45
        camera.zFar = 700
        
        self.camerasNode!.camera = camera
        self.camerasNode!.position = SCNVector3(0,20,0)
        self.camerasNode!.eulerAngles = SCNVector3Make(GLKMathDegreesToRadians(-90), 0, 0)
        
        self.cameraRollNode = SCNNode()
        self.cameraRollNode!.addChildNode(self.camerasNode!)
        self.cameraPitchNode = SCNNode()
        self.cameraPitchNode!.addChildNode(self.cameraRollNode!)
        self.cameraYawNode = SCNNode()
        self.cameraYawNode!.addChildNode(self.cameraPitchNode!)
        rootScene.rootNode.addChildNode(self.cameraYawNode!)
        self.sceneView!.pointOfView = camerasNode
        self.motionManager = CMMotionManager()
        self.motionManager?.deviceMotionUpdateInterval = 1/60
        self.motionManager?.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XArbitraryCorrectedZVertical)
        
        rootScene.background.contents = [UIImage(named: "skybox1")!,UIImage(named: "skybox2")!,UIImage(named: "skybox3")!,UIImage(named: "skybox4")!,UIImage(named: "skybox5")!,UIImage(named: "skybox6")!] as NSArray
        
        // Floor ground
        let floor = SCNFloor()
        floor.reflectivity = 0
        floor.firstMaterial!.diffuse.contents = UIImage(named: "ground")
        let floorNode = SCNNode()
        floorNode.geometry = floor
        floorNode.position = SCNVector3(0, groundPos, 0)
        rootScene.rootNode.addChildNode(floorNode)
        
        let iceTree = addNode(6, fileName: "iceTree/ice_tree.dae", namePre: "icetree_")
        iceTree.position = SCNVector3(0, self.groundPos, -50)
        iceTree.scale = SCNVector3(10,10,10)
        rootScene.rootNode.addChildNode(iceTree)
        
        let iceText = SCNNode()
        iceText.name = "icetree_Text"
        iceText.geometry = SCNPlane(width: 25, height: 20)
        iceText.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/iceTree/05.png")
        iceText.position = SCNVector3(0, 20, -50)
        rootScene.rootNode.addChildNode(iceText)
        
        let hintGeometry = SCNPlane(width: 3, height: 3)
        hintGeometry.firstMaterial?.diffuse.contents = UIImage(named: "clickHint")
        
        let iceHint = SCNNode(geometry: hintGeometry)
        iceHint.name = "icetree_Hint"
        iceHint.position = SCNVector3(0, 0, -20)
        rootScene.rootNode.addChildNode(iceHint)
        self.hints.append(iceHint)

        
        let light = SCNLight()
        light.type = SCNLightTypeOmni
        light.color = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        let lightNode = SCNNode()
        lightNode.position = SCNVector3(0, 0, 0)
        lightNode.light = light
        rootScene.rootNode.addChildNode(lightNode)
        
        let light2 = SCNLight()
        light2.type = SCNLightTypeSpot
        light2.color = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        let lightNode2 = SCNNode()
        lightNode2.rotation = SCNVector4Make(1, 0, 0, Float(-M_PI / 2))
        lightNode2.light = light2
        lightNode2.position = SCNVector3(0, 900, 0)
        rootScene.rootNode.addChildNode(lightNode2)
        
        let m1 = addNode("mountain/mountain_A.dae")
        m1.position = SCNVector3(500, self.groundPos - 3, -350)
        m1.scale = SCNVector3(20,20,20)
        rootScene.rootNode.addChildNode(m1)
        
        let m11 = m1.clone()
        m11.position = SCNVector3(400, self.groundPos - 3, 500)
        m11.rotation.y = 90
        rootScene.rootNode.addChildNode(m11)
        
        let m2 = addNode("mountain/mountain_B.dae")
        m2.position = SCNVector3(-500, self.groundPos - 3, 350)
        m2.scale = SCNVector3(10,10,10)
        rootScene.rootNode.addChildNode(m2)

        let star5 = addNode("star/Star_5.dae")
        star5.position = SCNVector3(200, 100, -200)
        star5.scale = SCNVector3(20,20,20)
        rootScene.rootNode.addChildNode(star5)
        
        let redStar = addNode("star/Star_4.dae")
        redStar.position = SCNVector3(0, 0, 400)
        redStar.scale = SCNVector3(50,50,50)
        rootScene.rootNode.addChildNode(redStar)
        
        let moon = addNode("star/Star_3.dae")
        moon.position = SCNVector3(400, 400, 400)
        moon.scale = SCNVector3(80,80,80)
        rootScene.rootNode.addChildNode(moon)
        
        let shadow = addNode("shadow/shadow.dae")
        
        
        let guitar = addNode("guitar/guitar.dae")
        guitar.scale = SCNVector3(15,15,15)
        guitar.position = SCNVector3(120, self.groundPos - 1, -90)
        rootScene.rootNode.addChildNode(guitar)
        let shadowguitar = shadow.clone()
        shadowguitar.scale = SCNVector3(48, 20, 24)
        shadowguitar.position = SCNVector3(120, self.groundPos + 0.1, -90)
        rootScene.rootNode.addChildNode(shadowguitar)

        
        let boy = addNode("dolls/MudDoll_boy.dae")
        boy.position = SCNVector3(50, self.groundPos + 1, 40)
        boy.rotation = SCNVector4Make(0, 1, 0, Float(-M_PI / 4.0))
        rootScene.rootNode.addChildNode(boy)
        let shadowboy = shadow.clone()
        shadowboy.position = SCNVector3(50, self.groundPos + 1, 40)
        rootScene.rootNode.addChildNode(shadowboy)
        
        let boy1 = boy.clone()
        boy1.position = SCNVector3(80, self.groundPos + 1, 40)
        boy.rotation = SCNVector4Make(0, 1, 0, Float(-M_PI / 2.0))
        rootScene.rootNode.addChildNode(boy1)
        let shadowboy1 = shadow.clone()
        shadowboy1.position = SCNVector3(80, self.groundPos + 1, 40)
        rootScene.rootNode.addChildNode(shadowboy1)

        let boy3 = boy.clone()
        boy3.scale = SCNVector3(700,700,700)
        boy3.rotation = SCNVector4Make(1, 0, 0, Float(M_PI/12))
        boy3.position = SCNVector3(50, -10, 0)
        rootScene.rootNode.addChildNode(boy3)
        
        let girl = addNode("dolls/MudDoll_girl.dae")
        girl.rotation = SCNVector4Make(0, 1, 0, Float(-M_PI))
        girl.position = SCNVector3(35, self.groundPos + 1, -15)
        rootScene.rootNode.addChildNode(girl)
        shadow.scale = SCNVector3(24, 20, 12)
        shadow.position = SCNVector3(38, self.groundPos + 1, -17)
        rootScene.rootNode.addChildNode(shadow)
        
        let girl1 = girl.clone()
        girl1.rotation = SCNVector4Make(0, 1, 0, Float(M_PI / 2))
        girl1.position = SCNVector3(40, self.groundPos + 1, -20)
        rootScene.rootNode.addChildNode(girl1)
        
        self.ufoNode = addNode(0, fileName: "UFO/UFO.dae", namePre: "ufo_")
        self.ufoNode!.position = SCNVector3(50, self.groundPos, 0)
        self.ufoNode!.scale = SCNVector3(8,8,8)
        let spin = CABasicAnimation(keyPath: "rotation")
        spin.fromValue = NSValue(SCNVector4: SCNVector4(x: 0, y: 1, z: 0, w: 0))
        spin.toValue = NSValue(SCNVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float(2 * M_PI)))
        spin.duration = 3
        spin.repeatCount = .infinity
        self.ufoNode!.addAnimation(spin, forKey: "ufoAni")
        rootScene.rootNode.addChildNode(self.ufoNode!)
        let spin2 = CABasicAnimation(keyPath: "transform.translation.y")
        spin2.fromValue = NSNumber(float: Float(self.groundPos))
        spin2.toValue = NSNumber(float: Float(self.groundPos + 20.0))
        spin2.duration = 6
        spin2.autoreverses = true
        spin2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        spin2.repeatCount = .infinity
        self.ufoNode!.addAnimation(spin2, forKey: "mvsAni")

        
        let ufoText = SCNNode()
        ufoText.name = "ufo_Text"
        ufoText.geometry = SCNPlane(width: 25, height: 20)
        ufoText.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/UFO/01.png")
        ufoText.position = SCNVector3(50, 35, 0)
        ufoText.rotation = SCNVector4Make(0, 1, 0, Float(-M_PI/2))
        rootScene.rootNode.addChildNode(ufoText)
        let ufoHint = SCNNode(geometry: hintGeometry)
        ufoHint.name = "ufo_Text"
        ufoHint.rotation = SCNVector4Make(0, 1, 0, Float(-M_PI/2))
        ufoHint.position = SCNVector3(20, 0, 0)
        rootScene.rootNode.addChildNode(ufoHint)
        self.hints.append(ufoHint)


        
        let teamCuijian = addNode(0, fileName: "cuijianTeam/cuijian_team.dae", namePre: "team_")
        teamCuijian.position = SCNVector3(0, self.groundPos + 2, -30)
        teamCuijian.scale = SCNVector3(12,12,12)
        rootScene.rootNode.addChildNode(teamCuijian)
        
        let teamCuijianText = SCNNode()
        teamCuijianText.name = "team_Text"
        teamCuijianText.scale = SCNVector3Make(5, 5, 5)
        teamCuijianText.geometry = SCNPlane(width: 25, height: 20)
        teamCuijianText.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/cuijianTeam/02.png")
        teamCuijianText.position = SCNVector3(0, 280, 400)
        teamCuijianText.rotation = SCNVector4Make(0, 1, 0, Float(M_PI))
        rootScene.rootNode.addChildNode(teamCuijianText)
        let teamHint = SCNNode(geometry: hintGeometry)
        teamHint.name = "team_Text"
        teamHint.position = SCNVector3(0, 15, 20)
        teamHint.rotation = SCNVector4Make(0, 1, 0, Float(M_PI))
        rootScene.rootNode.addChildNode(teamHint)
        self.hints.append(teamHint)
    
        let lavaBall = addNode(0, fileName: "aboutCuijian/LavaBall.dae", namePre: "mvs_")
        lavaBall.position = SCNVector3(-50, -20, 0)
        lavaBall.scale = SCNVector3(1500,1500,1500)
        rootScene.rootNode.addChildNode(lavaBall)
        
        let lavaBallText = SCNNode()
        lavaBallText.name = "mvs_Text"
        lavaBallText.geometry = SCNPlane(width: 25, height: 20)
        lavaBallText.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/aboutCuijian/03.png")
        lavaBallText.position = SCNVector3(-50, 40, 0)
        lavaBallText.rotation = SCNVector4Make(0, 1, 0, Float(M_PI/2))
        rootScene.rootNode.addChildNode(lavaBallText)
        let spin1 = CABasicAnimation(keyPath: "transform.translation.y")
        spin1.fromValue = NSNumber(double: -20.0)
        spin1.toValue = NSNumber(double: -10.0)
        spin1.duration = 3
        spin1.autoreverses = true
        spin1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        spin1.repeatCount = .infinity
        lavaBall.addAnimation(spin1, forKey: "mvsAni")
        let lavaBallHint = SCNNode(geometry: hintGeometry)
        lavaBallHint.name = "mvs_Text"
        lavaBallHint.rotation = SCNVector4Make(0, 1, 0, Float(M_PI/2))
        lavaBallHint.position = SCNVector3(-20, 0, 0)
        rootScene.rootNode.addChildNode(lavaBallHint)
        self.hints.append(lavaBallHint)


        
        let stone = addNode("star/Star_2.dae");
        stone.scale = SCNVector3(12, 12, 12)
        stone.position = SCNVector3(-50, 0, 50)
        rootScene.rootNode.addChildNode(stone)
        
        let stone2 = stone.clone()
        stone2.position = SCNVector3(-60, 10, -60)
        rootScene.rootNode.addChildNode(stone2)
        
        let stone3 = stone.clone()
        stone3.position = SCNVector3(50, 15, 50)
        rootScene.rootNode.addChildNode(stone3)
        
        let starStone = addNode("star/Star.dae");
        starStone.scale = SCNVector3(4, 4, 4)
        starStone.position = SCNVector3(-55, 5, 40)
        rootScene.rootNode.addChildNode(starStone)
        
        let starStone2 = starStone.clone()
        starStone2.position = SCNVector3(50, 15, 70)
        rootScene.rootNode.addChildNode(starStone2)
        
        
        UIView.animateWithDuration(1) { () -> Void in
            self.sceneView.alpha = 1
        }
    }
    
    func addNode(fileName: String) -> SCNNode{
        var node = SCNNode()
        if let subScene = SCNScene(named: "art.scnassets/\(fileName)") {
            if let subNode = subScene.rootNode.childNodes.first {
                node = subNode
            }
        }
        return node

    }
    
    func addNode(duration:CFTimeInterval, fileName: String, namePre: String) -> SCNNode {
        let node = self.addNode(fileName)
        stopAnimation(duration, node: node, namePre: namePre);
        return node
    }
    
    func stopAnimation(duration:CFTimeInterval, node:SCNNode, namePre: String){
        node.name = namePre + node.name!
        if duration > 0{
            if #available(iOS 9.0, *) {
            }
            else{
                if node.geometry != nil && node.geometry!.firstMaterial != nil{
                    node.geometry!.firstMaterial!.doubleSided = true
                }
            }
            for key in node.animationKeys{
                let animation = node.animationForKey(key)!
                animation.duration = duration
                node.removeAnimationForKey(key)
                node.addAnimation(animation, forKey: key)
            }
        }
        for n in node.childNodes{
            self.stopAnimation(duration, node: n, namePre: namePre)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(animated: Bool) {
        if (UIApplication.sharedApplication().delegate as! AppDelegate).songPlayer.player?.playing != true{
            self.player?.play()
        }
        super.viewWillAppear(true)
        self.sceneView!.scene?.paused = false
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        //add observer to video player
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoEnd", name: MPMoviePlayerPlaybackDidFinishNotification, object: icePlayer)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("ApplicationDidEnterBackground"), name: "applicationDidEnterBackground", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("ApplicationWillEnterForeground"), name: "applicationWillEnterForeground", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.player?.pause()
        super.viewWillDisappear(true)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.sceneView!.scene?.paused = true
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
    
    var alp:Float = 0.0
    var times = 0
    func renderer(renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: NSTimeInterval) {
        if self.cameraRollNode != nil && self.cameraPitchNode != nil && self.cameraYawNode != nil && self.motionManager!.deviceMotion != nil{
            self.cameraRollNode!.eulerAngles.z = -Float(self.motionManager!.deviceMotion!.attitude.roll)
            self.cameraPitchNode!.eulerAngles.x = Float(self.motionManager!.deviceMotion!.attitude.pitch)
            self.cameraYawNode!.eulerAngles.y = Float(self.motionManager!.deviceMotion!.attitude.yaw + M_PI)
        }
        self.alp = self.alp + 0.03
        let opacity = fmin(fmax(0.0, CGFloat(1.0) - CGFloat(self.alp)), 0.8)
        let scale = SCNVector3Make(1.0 + self.alp, 1.0 + self.alp, 1.0 + self.alp)
        for node:SCNNode in self.hints{
            node.scale = scale
            node.opacity = opacity
        }
        if (self.times < 2 && self.alp >= 1) || self.alp > 5{
            self.alp = 0
            self.times = self.times + 1
        }
        if self.times > 2{
            self.times = 0
        }
    }
    
    // MARK: - Video
    func loadVideo() {
        let path = NSBundle.mainBundle().pathForResource("ice", ofType:"mp4")
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
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.videoView?.alpha = 0
            }) { (finished) -> Void in
                self.videoView?.removeFromSuperview()
                self.videoView = nil
                self.icePlayer = nil
        }
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





