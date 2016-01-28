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

class MVViewController: UIViewController {

    @IBOutlet weak var mv2play: UIButton!
    @IBOutlet weak var mv1play: UIButton!
    @IBOutlet weak var mv2: UIImageView!
    @IBOutlet weak var mv1: UIImageView!
    @IBOutlet weak var forzenLight: UIImageView!
    @IBOutlet weak var mv2Constraints: NSLayoutConstraint!
    @IBOutlet weak var mv1Constraints: NSLayoutConstraint!
    @IBOutlet weak var frozenLightConstraints: NSLayoutConstraint!
    @IBOutlet weak var navItem: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.forzenLight.alpha = 0
        self.mv1.alpha = 0
        self.mv2.alpha = 0
        self.mv1play.alpha = 0
        self.mv2play.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            self.frozenLightConstraints.constant = 0
            self.forzenLight.alpha = 1
            self.view.layoutIfNeeded()
            }) { (finished) -> Void in
                UIView.animateWithDuration(0.8, delay: 0.3, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                        self.mv1Constraints.constant = 0
                        self.mv2Constraints.constant = 0
                        self.mv1.alpha = 1
                        self.mv2.alpha = 1
                        self.view.layoutIfNeeded()
                    }) {(finished) -> Void in
                        UIView.animateWithDuration(0.4, animations: { () -> Void in
                            self.mv1play.alpha = 1
                            self.view.layoutIfNeeded()
                        })
                        UIView.animateWithDuration(0.4, delay: 0.3, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                                self.mv2play.alpha = 1
                                self.view.layoutIfNeeded()
                            }, completion: nil)
                }

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playmv1(sender: AnyObject) {
        let path = NSBundle.mainBundle().pathForResource("sample_iPod", ofType:"m4v")
        
        let player = AVPlayer(URL: NSURL(fileURLWithPath: path!))
        let playerController = MVPlayerViewController()
        playerController.player = player
        playerController.modalPresentationStyle = UIModalPresentationStyle.Custom
        self.presentViewController(playerController, animated: true, completion: nil)
    }
        
    @IBAction func backBt(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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
