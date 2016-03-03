//
//  NavViewController.swift
//  CuiJian
//
//  Created by Rick on 16/1/13.
//  Copyright © 2016年 Rick. All rights reserved.
//

import UIKit

class NavViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var zhuanjiView: UIImageView!
    @IBOutlet weak var mvView: UIImageView!
    @IBOutlet weak var aboutCuijianView: UIImageView!
    @IBOutlet weak var newsView: UIImageView!
    @IBOutlet weak var aboutAppView: UIImageView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var bt1: UIButton!
    @IBOutlet weak var bt1cons: NSLayoutConstraint!
    @IBOutlet weak var bt2: UIButton!
    @IBOutlet weak var bt2cons: NSLayoutConstraint!
    @IBOutlet weak var bt3: UIButton!
    @IBOutlet weak var bt3cons: NSLayoutConstraint!
    @IBOutlet weak var bt4: UIButton!
    @IBOutlet weak var bt4cons: NSLayoutConstraint!
    @IBOutlet weak var bt5: UIButton!
    @IBOutlet weak var bt5cons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollview.alwaysBounceVertical = true
        HelperFuc.bgParrallax(zhuanjiView)
        HelperFuc.bgParrallax(mvView)
        HelperFuc.bgParrallax(aboutCuijianView)
        HelperFuc.bgParrallax(newsView)
        HelperFuc.bgParrallax(aboutAppView)
        
        self.navigationController!.interactivePopGestureRecognizer!.delegate = self
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)

        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.bt1cons.constant = 0
            self.bt1.alpha = 1
            self.view.layoutIfNeeded()
            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.bt2cons.constant = 0
            self.bt2.alpha = 1
            self.view.layoutIfNeeded()
            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.bt3cons.constant = 0
            self.bt3.alpha = 1
            self.view.layoutIfNeeded()
            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.bt4cons.constant = 0
            self.bt4.alpha = 1
            self.view.layoutIfNeeded()
            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0.4, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.bt5cons.constant = 0
            self.bt5.alpha = 1
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }

    
    @IBAction func MVClicked(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "MVStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("MvController") as UIViewController
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func AboutClicked(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "MVStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("aboutController") as UIViewController
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func newsClicked(sender: AnyObject) {
        let newsController:NewsViewController = NewsViewController();
        self.navigationController!.pushViewController(newsController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func dismissVC(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    

}
