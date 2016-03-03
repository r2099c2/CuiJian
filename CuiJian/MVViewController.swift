//
//  MVViewController.swift
//  CuiJian
//
//  Created by BriceZHOU on 1/27/16.
//  Copyright © 2016 Rick. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MVViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var frozenLightConstraints: NSLayoutConstraint!
    @IBOutlet weak var forzenLight: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bgView: UIImageView!
    
    @IBOutlet weak var collectionViewConstraint: NSLayoutConstraint!
    var collectionViewLayout: VVSpringCollectionViewFlowLayout!
    
    var videoController:KRVideoPlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.registerClass(MVCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView.allowsMultipleSelection = false
        
        self.navigationController!.interactivePopGestureRecognizer!.delegate = self.navigationController!.viewControllers[0] as! NavViewController
        // Do any additional setup after loading the view.
        self.forzenLight.alpha = 0
        self.collectionView.alpha = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animateWithDuration(0.35, delay: 0.3, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.frozenLightConstraints.constant = 0
            self.forzenLight.alpha = 1
            self.view.layoutIfNeeded()
            }) { (finished) -> Void in
                UIView.animateWithDuration(0.35, animations: { () -> Void in
                    self.collectionViewConstraint.constant = 0
                    self.collectionView.alpha = 1
                    self.view.layoutIfNeeded()
                    }){(finished) -> Void in
                        HelperFuc.bgParrallax(self.bgView)
                        HelperFuc.bgParrallax(self.forzenLight, maximumRelativeValue: 30)
                }
        }
        if(self.videoController == nil){
            self.videoController = KRVideoPlayerController(frame: self.view.frame)
        }

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func BtnClick(sender: AnyObject) {
        let path = NSBundle.mainBundle().pathForResource(self.data[(sender as! UIButton).tag].videoName, ofType:"mp4")
        let url = NSURL(fileURLWithPath: path!)
        self.videoController.contentURL = url
        self.videoController.showInWindow()

        let player = (UIApplication.sharedApplication().delegate as! AppDelegate).songPlayer
        player.stopPlayer()
    }
    
    @IBAction func backBt(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    var data = [MVData(imageName: "mv1", videoName: "mv1"), MVData(imageName: "mv2", videoName: "mv2")]
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! MVCell
        cell.setData(self.data[indexPath.item])
        cell.playBt.tag = indexPath.item
        cell.playBt.addTarget(self, action: Selector("BtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: floor(self.collectionView.frame.width), height: floor(self.collectionView.frame.width/395*236))

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.view.frame.height * 0.38)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 20)
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
