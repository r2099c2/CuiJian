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
    let shortLineYPos: CGFloat = 60
    let longLineHeight: CGFloat = 30
    let longLineYPos: CGFloat = 30
    let lineWidth: CGFloat = 1
    let pathSpacing:CGFloat = 10
    
    var superWidth: CGFloat = 0.0
    
    let dateDecade = ["1960s","1970s","1980s","1990s","2000s","2010s"]
    var curDecadeIndex = 2
    
    struct lineState {
        static let curLine: CGFloat = 50
        static let secLine: CGFloat = 40
        static let thdLine: CGFloat = 30
    }
    
    var isSlide: Bool = false
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        superWidth = (superview?.bounds.width)!
        
        // Draw line
        
        drawLine()
        
        centerFrame()
    }
    
    func drawLine() {
        // destroy old label
        for item in self.subviews {
            item.removeFromSuperview()
        }
        
        for longLineIndex in 0...dateDecade.count-1 {
            drawLongLine(longLineIndex)
        }
    }
    
    // every line block is 1 longLine 4 shortline 5 spacing except the last one
    
    func drawLongLine(lineIndex: Int) {
        var longH = longLineHeight
        
        if !isSlide {
            switch lineIndex {
            case curDecadeIndex:
                longH = lineState.curLine
                break
            case curDecadeIndex - 1:
                fallthrough
            case curDecadeIndex + 1:
                longH = lineState.secLine
                break
            case curDecadeIndex - 2:
                fallthrough
            case curDecadeIndex + 2:
                longH = lineState.thdLine
                break
            default:
                break
            }
        }
        
        
        let linePath = UIBezierPath()
        let xPos = CGFloat(lineIndex * 5) * (pathSpacing + lineWidth)
        
        linePath.lineWidth = lineWidth
        linePath.moveToPoint(CGPoint(x: xPos, y: bounds.height - longH))
        linePath.addLineToPoint(CGPoint(x: xPos, y: bounds.height))
        
        UIColor.whiteColor().setStroke()
        
        linePath.stroke()
        
        // add new label
        addLabel(dateDecade[lineIndex], xPos: xPos, yPos: bounds.height - longH)
        
        
        if lineIndex != (dateDecade.count - 1) {
            for shortLineIndex in 1...4 {
                drawShortLine(shortLineIndex + (5 * lineIndex))
            }
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
    
    func addLabel(text: String, xPos: CGFloat, yPos: CGFloat) {
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
    
    func centerFrame() {
        self.frame.origin.x = self.superWidth / 2 - (self.lineWidth*5 + self.pathSpacing*5) * CGFloat(self.curDecadeIndex)
    }
    
    func getCurDecade(frameX: CGFloat) -> Int {
        let curDecade =  round((superWidth/2 - frameX) / (lineWidth*5 + pathSpacing*5))
        print(curDecade)
        return Int(curDecade)
    }
    
    


}









