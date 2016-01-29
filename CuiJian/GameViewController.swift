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

class GameViewController: UIViewController, SCNSceneRendererDelegate {

    @IBOutlet var rootView: UIView!
    
    @IBOutlet weak var sceneView: SCNView!
    
    var motionManager: CMMotionManager?
    let camerasNode: SCNNode? = SCNNode()
    var cameraRollNode: SCNNode?
    var cameraPitchNode: SCNNode?
    var cameraYawNode: SCNNode?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let groudPos: CGFloat = -20
        
        // MARK: - 3D Scene
        // Create Scene
        let rootScene = SCNScene()
        
        sceneView!.scene = rootScene
        sceneView!.autoenablesDefaultLighting = true
        
        // Add camera to scene.
        let camara = SCNCamera()
        camara.xFov = 45
        camara.yFov = 45
        
        self.camerasNode!.camera = camara
        self.camerasNode!.position = SCNVector3(0, 0, 0)
        
        // 用户使用时手机是垂直的，所以需要相机旋转-90度
        self.camerasNode!.eulerAngles = SCNVector3Make(GLKMathDegreesToRadians(-90), 0, 0)
        
        let cameraRollNode = SCNNode()
        cameraRollNode.addChildNode(camerasNode!)
        
        let cameraPitchNode = SCNNode()
        cameraPitchNode.addChildNode(cameraRollNode)
        
        let cameraYawNode = SCNNode()
        cameraYawNode.addChildNode(cameraPitchNode)
        
        rootScene.rootNode.addChildNode(cameraYawNode)
        
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
        rootScene.background.contents = [UIImage(named: "skybox1")!,UIImage(named: "skybox2")!,UIImage(named: "skybox3")!,UIImage(named: "skybox4")!,UIImage(named: "skybox5")!,UIImage(named: "skybox6")!] as NSArray
        
        // Floor ground
        let floor = SCNFloor()
        floor.reflectivity = 0
        floor.firstMaterial!.diffuse.contents = UIImage(named: "ground")
        let floorNode = SCNNode()
        floorNode.geometry = floor
        floorNode.position = SCNVector3(0, groudPos, 0)
        rootScene.rootNode.addChildNode(floorNode)
        
        
        // add node
        let iceTree = addNode("iceTree/ice_tree.dae")
        iceTree.position = SCNVector3(0, groudPos, -100)
        rootScene.rootNode.addChildNode(iceTree)
        
        let dollBoy = addNode("dolls/MudDoll_boy.dae")
        dollBoy.position = SCNVector3(-40, groudPos, -40)
        rootScene.rootNode.addChildNode(dollBoy)
        
        let aboutCuijian = addNode("aboutCuijian/LavaBall.dae")
        aboutCuijian.position = SCNVector3(-60, groudPos, 0)
        rootScene.rootNode.addChildNode(aboutCuijian)
        
        let teamCuijian = addNode("cuijianTeam/cuijian_logo.dae")
        teamCuijian.position = SCNVector3(0, groudPos, 60)
        rootScene.rootNode.addChildNode(teamCuijian)
        
        let teamBass = addNode("cuijianTeam/bass.dae")
        teamBass.position = SCNVector3(-5, groudPos, 70)
        rootScene.rootNode.addChildNode(teamBass)
        
        let teamDrums = addNode("cuijianTeam/Drums.dae")
        teamDrums.position = SCNVector3(-20, groudPos, 90)
        rootScene.rootNode.addChildNode(teamDrums)
        
        let teamGuitar = addNode("cuijianTeam/guitar.dae")
        teamGuitar.position = SCNVector3(-20, groudPos, 70)
        rootScene.rootNode.addChildNode(teamGuitar)
        
        let teamKeyboard = addNode("cuijianTeam/Keyboard.dae")
        teamKeyboard.position = SCNVector3(15, groudPos, 80)
        rootScene.rootNode.addChildNode(teamKeyboard)
        
        let teamSuona_xiao = addNode("cuijianTeam/suona_xiao.dae")
        teamSuona_xiao.position = SCNVector3(10, groudPos, 70)
        rootScene.rootNode.addChildNode(teamSuona_xiao)
        
        let dollGirl = addNode("dolls/MudDoll_girl.dae")
        dollGirl.position = SCNVector3(5, 0, 5)
        dollGirl.eulerAngles = SCNVector3(0, GLKMathDegreesToRadians(0), 0)
        rootScene.rootNode.addChildNode(dollGirl)
        
        let ufo = addNode("UFO/UFO.dae")
        ufo.position = SCNVector3(80, groudPos, 0)
        rootScene.rootNode.addChildNode(ufo)
    }
    
    func addNode(fileName: String) -> SCNNode {
        var node = SCNNode()
        if let subScene = SCNScene(named: "art.scnassets/\(fileName)") {
            if let subNode = subScene.rootNode.childNodes.first {
                node = subNode
            }
        }
        return node
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBarHidden = true
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
        if let mm = motionManager, let motion = mm.deviceMotion {
            let currentAttitude = motion.attitude
            
            cameraRollNode!.eulerAngles.x = Float(currentAttitude.roll)
            cameraPitchNode!.eulerAngles.z = Float(currentAttitude.pitch)
            cameraYawNode!.eulerAngles.y = Float(currentAttitude.yaw)
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







