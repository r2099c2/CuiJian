//
//  TimeLineViewController.swift
//  CuiJian
//
//  Created by Rick on 16/1/14.
//  Copyright © 2016年 Rick. All rights reserved.
//

import UIKit

class TimeLineViewController: UIViewController {

    @IBOutlet weak var bgImageView: UIImageView!
    
    var preItem: TimelineItem?
    var currentItem: TimelineItem!
    var itemInshow1: TimelineItem?
    var itemInshow2: TimelineItem?
    var itemInshow3: TimelineItem?
    var nextItem: TimelineItem?
    
    
    
    var slideFactor: CGFloat! = 0.01
    
    // the postion and size for Tileline items
    struct TimelineItemState {
        static let preItem: CGRect = CGRectMake(57, 700 , 300, 300)
        static let currentItem: CGRect = CGRectMake(57, 266, 300, 300)
        static let itemInshow1: CGRect = CGRectMake(77, 190, 260, 260)
        static let itemInshow2: CGRect = CGRectMake(97, 149, 220, 220)
        static let itemInshow3: CGRect = CGRectMake(117, 116, 180, 180)
        static let nextItem: CGRect = CGRectMake(117, 116, 170, 170)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        bgParrallax()
        
        // create timeline item
        initTimeLineItem()
        
        self.view.translatesAutoresizingMaskIntoConstraints = true
        self.view.updateConstraintsIfNeeded()
        
        // add gesture to timeline item super view
        let panGusture = UIPanGestureRecognizer()
        panGusture.addTarget(self, action: "handleOnViewPanGusture:")
        self.view.addGestureRecognizer(panGusture)
        
    }
    
    func initTimeLineItem() {
        for index in 1...6 {
            let item = NSBundle.mainBundle().loadNibNamed("TimelineItem", owner: nil, options: nil)[0] as! TimelineItem
            item.title.text = String(index)
            item.backgroundColor = UIColor(red: CGFloat(index*40)/255, green: 123/255, blue: 123/255, alpha: 1)
            
            switch index {
            case 6:
                item.bounds.size = TimelineItemState.preItem.size
                item.frame.origin = TimelineItemState.preItem.origin
                
                preItem = item
                break
            case 5:
                item.bounds.size = TimelineItemState.currentItem.size
                item.frame.origin = TimelineItemState.currentItem.origin
                
                currentItem = item
                break
            case 4:
                item.bounds.size = TimelineItemState.itemInshow1.size
                item.frame.origin = TimelineItemState.itemInshow1.origin
                
                itemInshow1 = item
                break
            case 3:
                item.bounds.size = TimelineItemState.itemInshow2.size
                item.frame.origin = TimelineItemState.itemInshow2.origin

                itemInshow2 = item
                break
            case 2:
                item.bounds.size = TimelineItemState.itemInshow3.size
                item.frame.origin = TimelineItemState.itemInshow3.origin
                
                itemInshow3 = item
                break
            case 1:
                item.bounds.size = TimelineItemState.nextItem.size
                item.frame.origin = TimelineItemState.nextItem.origin
                
                nextItem = item
                break
            default: break
            }
            
            item.frame.origin.x = centerXItem(item.bounds.width)
            
            self.view.addSubview(item)
        }
    }
    
    func handleOnViewPanGusture(pan: UIPanGestureRecognizer) {
        
        let itemDisPreToCur = calcDistance(preItem!, toView: currentItem)
        let itemDisCurTo1 = calcDistance(currentItem, toView: itemInshow1!)
        let itemDis1To2 = calcDistance(itemInshow1!, toView: itemInshow2!)
        let itemDis2To3 = calcDistance(itemInshow2!, toView: itemInshow3!)
        let itemDis3ToNext = calcDistance(itemInshow3!, toView: nextItem!)
        
        let translationInView = pan.translationInView(self.view).y
        let velocityInView = pan.velocityInView(self.view).y
        
        switch pan.state {
        case UIGestureRecognizerState.Changed:
            if translationInView >= 0 {
                currentItem.frame.origin.y += velocityInView * slideFactor
                
                itemInshow1?.frame.origin.y += velocityInView * slideFactor * itemDisCurTo1 / itemDisPreToCur
                itemInshow1?.bounds.size.width += velocityInView * slideFactor * (TimelineItemState.currentItem.width - TimelineItemState.itemInshow1.width) / TimelineItemState.currentItem.width
                itemInshow1?.bounds.size.height += velocityInView * slideFactor * (TimelineItemState.currentItem.width - TimelineItemState.itemInshow1.width) / TimelineItemState.currentItem.width
                itemInshow1?.frame.origin.x = centerXItem((itemInshow1?.bounds.width)!)
                
                itemInshow2?.frame.origin.y += velocityInView * slideFactor * itemDis1To2 / itemDisPreToCur
                itemInshow2?.bounds.size.width += velocityInView * slideFactor * (TimelineItemState.currentItem.width - TimelineItemState.itemInshow2.width) / TimelineItemState.currentItem.width
                itemInshow2?.bounds.size.height += velocityInView * slideFactor * (TimelineItemState.currentItem.width - TimelineItemState.itemInshow2.width) / TimelineItemState.currentItem.width
                itemInshow2?.frame.origin.x = centerXItem((itemInshow2?.bounds.width)!)
                
                itemInshow3?.frame.origin.y += velocityInView * slideFactor * itemDis2To3 / itemDisPreToCur
                itemInshow3?.bounds.size.width += velocityInView * slideFactor * (TimelineItemState.currentItem.width - TimelineItemState.itemInshow3.width) / TimelineItemState.currentItem.width
                itemInshow3?.bounds.size.height += velocityInView * slideFactor * (TimelineItemState.currentItem.width - TimelineItemState.itemInshow3.width) / TimelineItemState.currentItem.width
                itemInshow3?.frame.origin.x = centerXItem((itemInshow3?.bounds.width)!)
                
                
//                currentItem.frame.origin.y += itemChangeDelta(velocityInView, preOrigY: TimelineItemState.preItem.origin.y, curOrigY: TimelineItemState.currentItem.origin.y, selfOrigY: currentItem.frame.origin.y)
//                itemInshow1!.frame.origin.y += itemChangeDelta(velocityInView, preOrigY: TimelineItemState.currentItem.origin.y, curOrigY: TimelineItemState.itemInshow1.origin.y, selfOrigY: itemInshow1!.frame.origin.y)
//                itemInshow2!.frame.origin.y += itemChangeDelta(velocityInView, preOrigY: TimelineItemState.itemInshow1.origin.y, curOrigY: TimelineItemState.itemInshow2.origin.y, selfOrigY: itemInshow2!.frame.origin.y)
//                itemInshow3!.frame.origin.y += itemChangeDelta(velocityInView, preOrigY: TimelineItemState.itemInshow2.origin.y, curOrigY: TimelineItemState.itemInshow3.origin.y, selfOrigY: itemInshow3!.frame.origin.y)
//                
//                currentItem.frame.size
            }
            
            break
        case UIGestureRecognizerState.Ended:
            fallthrough
        case UIGestureRecognizerState.Cancelled:
            fallthrough
        case UIGestureRecognizerState.Failed:
            if translationInView >= 60 {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    
                    self.currentItem.frame.origin.y = TimelineItemState.preItem.origin.y
                    self.itemInshow1?.frame.origin.y = TimelineItemState.currentItem.origin.y
                    self.itemInshow2?.frame.origin.y = TimelineItemState.itemInshow1.origin.y
                    self.itemInshow3?.frame.origin.y = TimelineItemState.itemInshow2.origin.y
                    self.nextItem?.frame.origin.y = TimelineItemState.itemInshow3.origin.y
                    
                    self.currentItem.bounds.size = TimelineItemState.preItem.size
                    self.itemInshow1?.bounds.size = TimelineItemState.currentItem.size
                    self.itemInshow2?.bounds.size = TimelineItemState.itemInshow1.size
                    self.itemInshow3?.bounds.size = TimelineItemState.itemInshow2.size
                    self.nextItem?.bounds.size = TimelineItemState.itemInshow3.size
                    
                    self.currentItem.frame.origin.x = self.centerXItem(self.currentItem.bounds.width)
                    self.itemInshow1!.frame.origin.x = self.centerXItem(self.itemInshow1!.bounds.width)
                    self.itemInshow2!.frame.origin.x = self.centerXItem(self.itemInshow2!.bounds.width)
                    self.itemInshow3!.frame.origin.x = self.centerXItem(self.itemInshow3!.bounds.width)
                    self.nextItem!.frame.origin.x = self.centerXItem(self.nextItem!.bounds.width)
                    
                    
                    }, completion: { (Bool finished) -> Void in
                        
                        self.preItem?.removeFromSuperview()
                        self.preItem = self.currentItem
                        self.currentItem = self.itemInshow1
                        self.itemInshow1 = self.itemInshow2
                        self.itemInshow2 = self.itemInshow3
                        self.itemInshow3 = self.nextItem
                        self.nextItem = self.createNewItem(TimelineItemState.nextItem)
                        self.view.addSubview(self.nextItem!)
                        self.view.insertSubview(self.nextItem!, aboveSubview: self.view.subviews[1])
                })
            }
            break
        default: break
        }
    }
    
    func createNewItem(itemRect: CGRect) -> TimelineItem {
        let item = NSBundle.mainBundle().loadNibNamed("TimelineItem", owner: nil, options: nil)[0] as! TimelineItem
        item.bounds.size = itemRect.size
        item.frame.origin = itemRect.origin
        item.frame.origin.x = centerXItem(item.bounds.width)
        item.backgroundColor = UIColor(red: CGFloat((random() % 255)/255), green: 120/255, blue: 120/255, alpha: 1)
        return item
    }
    
//    // ds/s = x/𝛑/2  sin(x)
//    func itemChangeDelta(velocityInView: CGFloat, preRect: CGRect, curRect: CGRect, selfRect: CGRect) -> CGRect {
//        let factor = itemChangeFactor(preRect.origin.y, curOrigY: curRect.origin.y, selfOrigY: selfRect.origin.y)
//        
//        let rect = calcDifBetweenRect(<#T##fromRect: CGRect##CGRect#>, toRect: <#T##CGRect#>)
//        return velocityInView * factor * slideFactor
//    }
    
    func itemChangeFactor(preOrigY: CGFloat, curOrigY: CGFloat, selfOrigY: CGFloat) -> CGFloat {
        let radian = CGFloat(M_PI_2) * (preOrigY - selfOrigY) / (preOrigY - curOrigY)
        return sin(radian)
    }
    
    func centerXItem(itemWidth: CGFloat) -> CGFloat {
        return (self.view.bounds.size.width - itemWidth) / 2
    }
    
    func moveItem(item: UIView, deltY: CGFloat) {
        item.frame.origin.y += deltY
    }
    
    func calcDifBetweenRect(fromRect: CGRect, toRect: CGRect) -> CGRect {
        let rect: CGRect = CGRect(x: fromRect.origin.x - toRect.origin.x, y: fromRect.origin.y - toRect.origin.y, width: fromRect.size.width - toRect.size.height, height: fromRect.size.height - toRect.size.height)
        return rect
    }
    
    func calcDistance(fromView: UIView, toView: UIView) -> CGFloat {
        return abs(CGFloat(fromView.frame.origin.y - toView.frame.origin.y))
    }
    
    // BackGroundImageView Parallax
    func bgParrallax() {
        // Set vertical effect
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -20
        verticalMotionEffect.maximumRelativeValue = 20
        
        // Set horizontal effect
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x",
            type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -20
        horizontalMotionEffect.maximumRelativeValue = 20
        
        // Create group to combine both
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        // Add both effects to your view
        bgImageView.addMotionEffect(group)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func dismissVC(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
