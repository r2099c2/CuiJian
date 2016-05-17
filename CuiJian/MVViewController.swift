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
    
    var videoViewController:TCPlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.masksToBounds = true
        self.collectionView.registerClass(MVCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView.allowsMultipleSelection = false
        
        // Do any additional setup after loading the view.
        self.forzenLight.alpha = 0
        self.collectionView.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.35, animations: { () -> Void in
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
        if(self.videoViewController == nil){
            self.videoViewController = TCPlayerViewController()
        }

    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func BtnClick(sender: UITapGestureRecognizer) {
        self.videoViewController.play(self.data[sender.view!.tag].video1, video2: self.data[sender.view!.tag].video2)
        let player = (UIApplication.sharedApplication().delegate as! AppDelegate).songPlayer
        player.stopPlayer()
    }
    
    @IBAction func backBt(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    var data = [MVData(imageName: "mv1", video1: "http://200015869.vod.myqcloud.com/200015869_3d1c2dca18ef11e6b5044318f5e8dafb.f20.mp4", video2: "http://200015869.vod.myqcloud.com/200015869_3d1c2dca18ef11e6b5044318f5e8dafb.f30.mp4"), MVData(imageName: "mv2", video1: "http://200015869.vod.myqcloud.com/200015869_2ff5e6f81b2a11e6b1b1e3da568f98d7.f20.mp4", video2: "http://200015869.vod.myqcloud.com/200015869_2ff5e6f81b2a11e6b1b1e3da568f98d7.f30.mp4")]
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! MVCell
        cell.setData(self.data[indexPath.item])
        cell.tag = indexPath.item
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MVViewController.BtnClick(_:))))
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
