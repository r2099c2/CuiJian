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
    let longLineMidHeight: CGFloat = 40
    let longLineSmlHeight: CGFloat = 30
    let longLineYPos: CGFloat = 30
    let lineWidth: CGFloat = 3
    let pathSpacing:CGFloat = 10
    
    let dateDecade = ["1960s","1970s","1980s","1990s","2000s","2010s","2020s","1960s","1970s","1980s","1990s","2000s","2010s","2020s","1960s","1970s","1980s","1990s","2000s","2010s","2020s"]
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Draw line
        for longLineIndex in 0...dateDecade.count-1 {
            drawLongLine(longLineIndex)
        }
        
        // Update position
        updatePos()
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
        
        makeLabel(dateDecade[lineIndex], xPos: xPos, yPos: longLineYPos)
    }
    
    func makeLabel(text: String, xPos: CGFloat, yPos: CGFloat) {
        let nubLabel = UILabel()
        self.addSubview(nubLabel)
        
        nubLabel.text = text
        nubLabel.textColor = UIColor.whiteColor()
        nubLabel.font = UIFont.systemFontOfSize(13)
        nubLabel.textAlignment = .Center
        nubLabel.frame.size = CGSize(width: 50, height: 20)
        nubLabel.frame.origin.x = xPos - 25
        nubLabel.frame.origin.y = yPos - 20
        
    }
    
    func updatePos() {
        
    }


}









