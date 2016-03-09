//
//  aboutViewController.swift
//  CuiJian
//
//  Created by Rick on 16/2/6.
//  Copyright © 2016年 Rick. All rights reserved.
//

import UIKit

class aboutViewController: UIViewController {

    @IBOutlet weak var aboutBg: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBAction func dismiss(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let uiScreenWidth: CGFloat = UIScreen.mainScreen().bounds.width
        
        let rect = textView.attributedText?.boundingRectWithSize(CGSizeMake(uiScreenWidth - 40, 5000),
            options: .UsesLineFragmentOrigin, context: nil)
        textViewHeight.constant = rect!.height + 60
        contentViewHeight.constant = contentView.bounds.height + (rect!.height - textView.bounds.height + 60)
        print("\(uiScreenWidth - 40)");
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        HelperFuc.bgParrallax(aboutBg)
        print("\(textView.bounds.width)")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    
    
    @IBAction func share(sender: UIButton) {
        //TODO: Change URL
        let url = NSURL(string: "https://itunes.apple.com/app/63-bits/id1016437119")
        
        let controller:UIActivityViewController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
}
