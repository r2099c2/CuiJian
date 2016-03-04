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
    
    @IBAction func dismiss(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HelperFuc.bgParrallax(aboutBg)
    }
    
    @IBAction func share(sender: UIButton) {
        //TODO: Change URL
        let url = NSURL(string: "https://itunes.apple.com/app/63-bits/id1016437119")
        
        let controller:UIActivityViewController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
}
