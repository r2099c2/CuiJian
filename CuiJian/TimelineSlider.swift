//
//  TimelineSlider.swift
//  CuiJian
//
//  Created by Rick on 16/1/23.
//  Copyright © 2016年 Rick. All rights reserved.
//

import UIKit

class TimelineSlider: UIView {

    let shortLineHeight: CGFloat = 10
    let shortLineYPos: CGFloat = 50
    let longLineHeight: CGFloat = 50
    let longLineYPos: CGFloat = 30
    let lineWidth: CGFloat = 3
    let pathSpacing:CGFloat = 10
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        // Draw short line
        for longLineIndex in 0...10 {
            drawLongLine(longLineIndex)
        }
    }
    
    func drawShortLine(lineIndex: Int) {
        let linePath = UIBezierPath()
        let xPos = CGFloat(lineIndex) * (pathSpacing + lineWidth)
        
        linePath.lineWidth = lineWidth
        linePath.moveToPoint(CGPoint(x: xPos, y: shortLineYPos))
        linePath.addLineToPoint(CGPoint(x: xPos, y: shortLineYPos + shortLineHeight))
        
        UIColor.whiteColor().setStroke()
        
        linePath.stroke()
    }
    
    func drawLongLine(lineIndex: Int) {
        
        for shortLineIndex in 1...4 {
            drawShortLine(shortLineIndex + (5 * lineIndex))
        }
        
        let linePath = UIBezierPath()
        let xPos = CGFloat(lineIndex * 5) * (pathSpacing + lineWidth)
        
        linePath.lineWidth = lineWidth
        linePath.moveToPoint(CGPoint(x: xPos, y: longLineYPos))
        linePath.addLineToPoint(CGPoint(x: xPos, y: longLineYPos + longLineHeight))
        
        UIColor.whiteColor().setStroke()
        
        linePath.stroke()
    }


}









