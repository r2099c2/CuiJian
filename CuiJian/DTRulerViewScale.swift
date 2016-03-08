//
//  DTRulerViewScale.swift
//  CuiJian
//
//  Created by BriceZHOU on 2/22/16.
//  Copyright © 2016 Rick. All rights reserved.
//

import UIKit

let DTRulerScaleBlockWidth:CGFloat = 100.0
let DTRulerScaleGap:CGFloat = 10.0


class DTRulerViewScale: UIView {
    var value:Int?
    
    init(value: Int, height: CGFloat){
        super.init(frame: CGRect(x: 0,y: 0,width: DTRulerScaleBlockWidth, height: height))
        self.value = value
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setvalue(value:Int){
        if(self.value != value){
            self.value = value
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        self.doScaleWithValue(self.value!, rect: rect, context: context)
    }

    
    func doScaleWithValue(value:Int, rect:CGRect, context:CGContextRef){
        let startX = CGRectGetMidX(rect) + DTRulerScaleGap / 2
        let startY = CGRectGetMinY(rect)
        let endY = CGRectGetMaxY(rect)
        let valueLabel:NSString = "\(self.value!)"
        
        let actualFont = UIFont.systemFontOfSize(14)
        let textFontAttributes = [
            NSFontAttributeName: actualFont,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        
        let textSize = valueLabel.sizeWithAttributes(textFontAttributes)
        

        valueLabel.drawInRect(CGRect(x: startX - textSize.width / 2, y: startY + 14, width: textSize.width, height: textSize.height), withAttributes: textFontAttributes)
        
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextSetLineWidth(context, 0.5)
        CGContextMoveToPoint(context, startX, endY * 0.6)
        CGContextAddLineToPoint(context, startX, endY)
        CGContextDrawPath(context, .Stroke)
        self.doScaleFromMidToEgdeWithStartX(startX, endY: endY, counter: 4, plus: true, context: context)
        self.doScaleFromMidToEgdeWithStartX(startX, endY: endY, counter: 5, plus: false, context: context)
        
    }
    
    func doScaleFromMidToEgdeWithStartX(var startX: CGFloat, endY: CGFloat, counter:Int, plus:Bool, context:CGContextRef){
        CGContextSetLineWidth(context, 0.5)
        for (var i = 0; i < counter; i++) {
            if(plus){
                startX += DTRulerScaleGap
            }
            else{
                startX -= DTRulerScaleGap
            }
            if i % 2 == 1{
                CGContextMoveToPoint(context, startX, endY * 0.75);
                CGContextAddLineToPoint(context, startX, endY*0.9);
            }
            CGContextDrawPath(context, .Stroke);
        }

    }
}
