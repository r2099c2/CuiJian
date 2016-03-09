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
    @IBOutlet weak var contentViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBAction func dismiss(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HelperFuc.bgParrallax(aboutBg)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let uiScreenWidth: CGFloat = UIScreen.mainScreen().bounds.width - 40
        contentViewWidth.constant = uiScreenWidth
        
        let rect = textView.attributedText?.boundingRectWithSize(CGSizeMake(uiScreenWidth, 5000),
            options: .UsesLineFragmentOrigin, context: nil)
        textViewHeight.constant = rect!.height
        contentViewHeight.constant = shareBtn.frame.origin.y + shareBtn.bounds.height
        
        
        self.view.layoutIfNeeded()
        contentViewHeight.constant = shareBtn.frame.origin.y + shareBtn.bounds.height
        self.view.layoutIfNeeded()
        
    }
    
    
    
    @IBAction func share(sender: UIButton) {
        //TODO: Change URL
        let url = NSURL(string: "https://itunes.apple.com/app/63-bits/id1016437119")
        
        let controller:UIActivityViewController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
}
