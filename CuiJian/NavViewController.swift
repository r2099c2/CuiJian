//
//  NavViewController.swift
//  CuiJian
//
//  Created by Rick on 16/1/13.
//  Copyright © 2016年 Rick. All rights reserved.
//

import UIKit

class NavViewController: UIViewController {
    
    
    @IBOutlet weak var bgParaImg: UIImageView!
    
    
    @IBOutlet weak var song: UIButton!
    @IBOutlet weak var timeline: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HelperFuc.bgParrallax(bgParaImg)
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.song.frame.origin.y = CGFloat(0)
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.timeline.frame.origin.y = CGFloat(100)
            }, completion: nil)
        // Do any additional setup after loading the view.
    }
        
    @IBAction func MVClicked(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "MVStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("MvController") as UIViewController
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func newsClicked(sender: AnyObject) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dismissVC(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    

}
