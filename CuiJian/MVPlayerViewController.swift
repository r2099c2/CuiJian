//
//  MVPlayerViewController.swift
//  CuiJian
//
//  Created by BriceZHOU on 1/28/16.
//  Copyright © 2016 Rick. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class MVPlayerViewController: AVPlayerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
        
        self.view.transform = CGAffineTransformMakeRotation(CGFloat.init(M_PI_2));
        let newFrame:CGRect = CGRect(x: 0, y: 0,width: UIScreen.mainScreen().bounds.size.height, height: UIScreen.mainScreen().bounds.size.width);
        self.view.frame = newFrame;

    }
    
    override func viewWillAppear(animated: Bool) {
        self.player?.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
