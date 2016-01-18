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
    
    var preItem: UIView?
    var currentItem: UIView!
    var itemInshow1: UIView?
    var itemInshow2: UIView?
    var itemInshow3: UIView?
    var nextItem: UIView?
    
    
    
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
        
        // add gesture to timeline item
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
//                item.frame.origin = TimelineItemState.currentItem.origin
                
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
            
            self.view.addSubview(item)
            
            let constains = NSLayoutConstraint(item: item, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
            item.superview!.addConstraint(constains)
        }
    }
    
    func handleOnViewPanGusture(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case UIGestureRecognizerState.Changed:
            moveItem(pan.velocityInView(self.view).y * slideFactor)
            break
        default: break
        }
    }
    
    func moveItem(deltY: CGFloat) {
        preItem!.frame.origin.y += (deltY * 2)
        currentItem.frame.origin.y += deltY
        itemInshow1!.frame.origin.y += (deltY * 0.5)
        itemInshow2!.frame.origin.y += (deltY * 0.3)
        itemInshow3!.frame.origin.y += (deltY * 0.1)
        nextItem!.frame.origin.y += (deltY * 0.08)
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
