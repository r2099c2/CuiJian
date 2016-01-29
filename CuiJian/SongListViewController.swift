//
//  SongListViewController.swift
//  CuiJian
//
//  Created by Rick on 16/1/29.
//  Copyright © 2016年 Rick. All rights reserved.
//

import UIKit

class SongListViewController: UIViewController {
    
    
    @IBAction func dismiss(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
    }
   
}
