//
//  SlideMaskView.swift
//  CuiJian
//
//  Created by Rick on 16/1/25.
//  Copyright © 2016年 Rick. All rights reserved.
//

import UIKit

class SlideMaskView: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let gradient = CGGradientCreateWithColors(
            CGColorSpaceCreateDeviceRGB(),
            [UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).CGColor,
                UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1).CGColor,
                UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).CGColor],
            [0,0.5,1])
        
        CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), gradient, CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: 0), CGGradientDrawingOptions.DrawsBeforeStartLocation)
    }
    
    

}
