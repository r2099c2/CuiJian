//
//  aboutViewController.swift
//  CuiJian
//
//  Created by Rick on 16/2/6.
//  Copyright © 2016年 Rick. All rights reserved.
//

import UIKit

class aboutViewController: UIViewController, UIActionSheetDelegate {

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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        HelperFuc.bgParrallax(aboutBg)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    
    
    @IBAction func share(sender: UIButton) {
        
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "分享到微信朋友圈", "分享给微信好友", "更多选项")
        
        actionSheet.showInView(self.view)
        
        /*
        //TODO: Change URL
        
        */
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        let message = WXMediaMessage()
        message.title = "分享崔健"
        message.description = "分享崔健描述"
        message.setThumbImage(UIImage(named: "AppIcon"))
        let url = WXWebpageObject()
        url.webpageUrl = "https://itunes.apple.com/app/cui-jianapp/id1091981718"
        message.mediaObject = url
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        
        switch buttonIndex{
        case 1:
            req.scene = Int32(WXSceneTimeline.rawValue)
            WXApi.sendReq(req)
            break
        case 2:
            req.scene = Int32(WXSceneSession.rawValue)
            WXApi.sendReq(req)
            break
        case 3:
            let url = NSURL(string: "https://itunes.apple.com/app/cui-jianapp/id1091981718")
            let controller:UIActivityViewController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
            self.presentViewController(controller, animated: true, completion: nil)
            break
        default:
            break
        }
    }
}
