//
//  TimelineItem.swift
//  CuiJian
//
//  Created by Rick on 16/1/18.
//  Copyright © 2016年 Rick. All rights reserved.
//

import UIKit

class TimelineItem: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var content: UITextView!
    
}
