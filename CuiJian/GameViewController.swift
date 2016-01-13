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

class GameViewController: UIViewController {

    @IBOutlet var rootView: UIView!
    
    @IBOutlet weak var sceneView: SCNView!
    
    var motionManager: CMMotionManager?
    let camerasNode: SCNNode? = SCNNode()
    var cameraRollNode: SCNNode?
    var cameraPitchNode: SCNNode?
    var cameraYawNode: SCNNode?
    
    // new master test from rick
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create Scene
        let scene = SCNScene()
        
        sceneView!.scene = scene
        sceneView!.autoenablesDefaultLighting = true
        
        // Add camera to scene.
        let camara = SCNCamera()
        camara.xFov = 55
        camara.yFov = 45
        
        self.camerasNode!.camera = camara
        self.camerasNode!.position = SCNVector3(0, 0, 0)
        
        // 用户使用时手机是垂直的，所以需要相机旋转-90度
        self.camerasNode!.eulerAngles = SCNVector3Make(degreesToRadians(-90), 0, 0)
        
        let cameraRollNode = SCNNode()
        cameraRollNode.addChildNode(camerasNode!)
        
        let cameraPitchNode = SCNNode()
        cameraPitchNode.addChildNode(cameraRollNode)
        
        let cameraYawNode = SCNNode()
        cameraYawNode.addChildNode(cameraPitchNode)
        
        scene.rootNode.addChildNode(cameraYawNode)
        
        self.sceneView!.pointOfView = camerasNode
        
        // Motion; 
        // Respond to user head movement
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
        })
        
        
        
        // Sky box
        scene.background.contents = UIImage(named: "skybox")
        
        // Floor ground
        let floor = SCNFloor()
        floor.reflectivity = 0
        floor.firstMaterial!.diffuse.contents = UIImage(named: "ground")
        let floorNode = SCNNode()
        floorNode.geometry = floor
        floorNode.position = SCNVector3(0, -20, 0)
        scene.rootNode.addChildNode(floorNode)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBarHidden = true
    }
    
    // 角度转弧度
    func degreesToRadians(degrees: Float) -> Float {
        return (degrees * Float(M_PI)) / 180.0
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

}

// brice test master
