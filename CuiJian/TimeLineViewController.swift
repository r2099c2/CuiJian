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
    
    @IBOutlet weak var itemsView: UIView!
    
    @IBOutlet weak var slideMaskView: SlideMaskView!
    
    @IBOutlet weak var TimelineSlideView: TimelineSlider!
    
    var firstLoadTimeline = true
    
    var preItem: TimelineItem?
    var currentItem: TimelineItem!
    var itemInshow1: TimelineItem?
    var itemInshow2: TimelineItem?
    var itemInshow3: TimelineItem?
    var nextItem: TimelineItem?
    
    var isAnimating: Bool = false
    
    var slideFactor: CGFloat! = 0.015
    
    
    // the postion and size for Tileline items
    private struct TLItemState {
        static let preItem: CGRect = CGRectMake(57, 600 , 300, 300)
        static let currentItem: CGRect = CGRectMake(57, 200, 300, 300)
        static let itemInshow1: CGRect = CGRectMake(77, 140, 260, 260)
        static let itemInshow2: CGRect = CGRectMake(97, 100, 220, 220)
        static let itemInshow3: CGRect = CGRectMake(117, 90, 180, 180)
        static let nextItem: CGRect = CGRectMake(117, 100, 170, 170)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        bgParrallax()
        
        // init timeline item
        initTimeLineItem()
        
        
        // add gesture to timeline item super view
        let panGusture = UIPanGestureRecognizer()
        panGusture.addTarget(self, action: "handleOnViewPanGusture:")
        self.itemsView.addGestureRecognizer(panGusture)
        
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: "slideGestureHandle:")
        slideMaskView.addGestureRecognizer(panGesture)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        firstLoadTimeline = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        TimelineSlideView.centerFrame()
    }
    
    
    // MARK: - Page item slide
    func initTimeLineItem() {
        for index in 1...6 {
            if let item = NSBundle.mainBundle().loadNibNamed("TimelineItem", owner: nil, options: nil)[0] as? TimelineItem {
                self.itemsView.addSubview(item)
                
                item.title.text = String(index)
                item.backgroundColor = UIColor(red: CGFloat(index*40)/255, green: 123/255, blue: 123/255, alpha: 1)
                
                switch index {
                case 6:
                    item.bounds.size = TLItemState.preItem.size
                    item.frame.origin = TLItemState.preItem.origin
                    
                    preItem = item
                    break
                case 5:
                    item.bounds.size = TLItemState.currentItem.size
                    item.frame.origin = TLItemState.currentItem.origin
                    
                    currentItem = item
                    break
                case 4:
                    item.bounds.size = TLItemState.itemInshow1.size
                    item.frame.origin = TLItemState.itemInshow1.origin
                    
                    itemInshow1 = item
                    break
                case 3:
                    item.bounds.size = TLItemState.itemInshow2.size
                    item.frame.origin = TLItemState.itemInshow2.origin
                    
                    itemInshow2 = item
                    break
                case 2:
                    item.bounds.size = TLItemState.itemInshow3.size
                    item.frame.origin = TLItemState.itemInshow3.origin
                    
                    itemInshow3 = item
                    break
                case 1:
                    item.bounds.size = TLItemState.nextItem.size
                    item.frame.origin = TLItemState.nextItem.origin
                    
                    nextItem = item
                    break
                default: break
                }
                
                item.frame.origin.x = centerXItem(item.bounds.width)
            }
            
        }
    }
    
    func handleOnViewPanGusture(pan: UIPanGestureRecognizer) {
        
        let translationInView = pan.translationInView(self.itemsView).y
        let itemVelocity = pan.velocityInView(self.itemsView).y * slideFactor
        
        switch pan.state {
        case UIGestureRecognizerState.Changed:
            
            if !isAnimating {
                if translationInView >= 0 {
                    // slide down
                    
                    updateItem(currentItem, nextState: TLItemState.preItem, velocity: itemVelocity)
                    updateItem(itemInshow1!, nextState: TLItemState.currentItem, velocity: itemVelocity)
                    updateItem(itemInshow2!, nextState: TLItemState.itemInshow1, velocity: itemVelocity)
                    updateItem(itemInshow3!, nextState: TLItemState.itemInshow2, velocity: itemVelocity)
                    updateItem(nextItem!, nextState: TLItemState.itemInshow3, velocity: itemVelocity)
                    
                } else {
                    // slide up
                    
                    updateItem(preItem!, nextState: TLItemState.currentItem, velocity: itemVelocity)
                    updateItem(currentItem!, nextState: TLItemState.itemInshow1, velocity: itemVelocity)
                    updateItem(itemInshow1!, nextState: TLItemState.itemInshow2, velocity: itemVelocity)
                    updateItem(itemInshow2!, nextState: TLItemState.itemInshow3, velocity: itemVelocity)
                    updateItem(itemInshow3!, nextState: TLItemState.nextItem, velocity: itemVelocity)
                    
                }
                
            }
            break
        case UIGestureRecognizerState.Ended:
            fallthrough
        case UIGestureRecognizerState.Cancelled:
            fallthrough
        case UIGestureRecognizerState.Failed:
            if translationInView >= 60 {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    
                    self.isAnimating = true
                    
                    self.itemInshow1?.bounds.size = TLItemState.currentItem.size
                    self.itemInshow2?.bounds.size = TLItemState.itemInshow1.size
                    self.itemInshow3?.bounds.size = TLItemState.itemInshow2.size
                    self.nextItem?.bounds.size = TLItemState.itemInshow3.size
                    
                    self.currentItem.frame.origin.y = TLItemState.preItem.origin.y
                    self.itemInshow1?.frame.origin.y = TLItemState.currentItem.origin.y
                    self.itemInshow2?.frame.origin.y = TLItemState.itemInshow1.origin.y
                    self.itemInshow3?.frame.origin.y = TLItemState.itemInshow2.origin.y
                    self.nextItem?.frame.origin.y = TLItemState.itemInshow3.origin.y
                    
                    self.centerAllItems()
                    
                    
                    }, completion: { (Bool finished) -> Void in
                        
                        self.preItem?.removeFromSuperview()
                        self.preItem = self.currentItem
                        self.currentItem = self.itemInshow1
                        self.itemInshow1 = self.itemInshow2
                        self.itemInshow2 = self.itemInshow3
                        self.itemInshow3 = self.nextItem
                        self.nextItem = self.createNewItem(TLItemState.nextItem)
                        self.itemsView.addSubview(self.nextItem!)
                        self.itemsView.sendSubviewToBack(self.nextItem!)
                        
                        self.isAnimating = false
                })
            } else if translationInView <= -60 {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    
                    self.isAnimating = true
                    
                    self.preItem?.bounds.size = TLItemState.currentItem.size
                    self.currentItem.bounds.size = TLItemState.itemInshow1.size
                    self.itemInshow1?.bounds.size = TLItemState.itemInshow2.size
                    self.itemInshow2?.bounds.size = TLItemState.itemInshow3.size
                    self.itemInshow3?.bounds.size = TLItemState.nextItem.size
                    self.nextItem?.bounds.size = TLItemState.nextItem.size
                    
                    self.preItem?.frame.origin.y = TLItemState.currentItem.origin.y
                    self.currentItem.frame.origin.y = TLItemState.itemInshow1.origin.y
                    self.itemInshow1?.frame.origin.y = TLItemState.itemInshow2.origin.y
                    self.itemInshow2?.frame.origin.y = TLItemState.itemInshow3.origin.y
                    self.itemInshow3?.frame.origin.y = TLItemState.nextItem.origin.y
                    self.nextItem?.frame.origin.y = TLItemState.nextItem.origin.y
                    
                    self.centerAllItems()
                    
                    }, completion: { (Bool finished) -> Void in
                        
                        self.nextItem?.removeFromSuperview()
                        self.nextItem = self.itemInshow3
                        self.itemInshow3 = self.itemInshow2
                        self.itemInshow2 = self.itemInshow1
                        self.itemInshow1 = self.currentItem
                        self.currentItem = self.preItem
                        self.preItem = self.createNewItem(TLItemState.preItem)
                        self.itemsView.addSubview(self.preItem!)
                        
                        self.isAnimating = false
                })
            } else {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    
                    self.isAnimating = true
                    
                    self.preItem?.bounds.size = TLItemState.preItem.size
                    self.currentItem.bounds.size = TLItemState.currentItem.size
                    self.itemInshow1?.bounds.size = TLItemState.itemInshow1.size
                    self.itemInshow2?.bounds.size = TLItemState.itemInshow2.size
                    self.itemInshow3?.bounds.size = TLItemState.itemInshow3.size
                    self.nextItem?.bounds.size = TLItemState.nextItem.size
                    
                    self.preItem?.frame.origin.y = TLItemState.preItem.origin.y
                    self.currentItem.frame.origin.y = TLItemState.currentItem.origin.y
                    self.itemInshow1?.frame.origin.y = TLItemState.itemInshow1.origin.y
                    self.itemInshow2?.frame.origin.y = TLItemState.itemInshow2.origin.y
                    self.itemInshow3?.frame.origin.y = TLItemState.itemInshow3.origin.y
                    self.nextItem?.frame.origin.y = TLItemState.nextItem.origin.y
                    
                    self.centerAllItems()
                    
                    
                    }, completion: { (Bool finished) -> Void in
                        self.isAnimating = false
                })
            }
            break
        default: break
        }
    }
    
    func centerAllItems(){
        self.preItem?.frame.origin.x = self.centerXItem(self.preItem!.bounds.width)
        self.currentItem.frame.origin.x = self.centerXItem(self.currentItem.bounds.width)
        self.itemInshow1!.frame.origin.x = self.centerXItem(self.itemInshow1!.bounds.width)
        self.itemInshow2!.frame.origin.x = self.centerXItem(self.itemInshow2!.bounds.width)
        self.itemInshow3!.frame.origin.x = self.centerXItem(self.itemInshow3!.bounds.width)
        self.nextItem!.frame.origin.x = self.centerXItem(self.nextItem!.bounds.width)
    }
    
    func createNewItem(itemRect: CGRect) -> TimelineItem {
        let item = NSBundle.mainBundle().loadNibNamed("TimelineItem", owner: nil, options: nil)[0] as! TimelineItem
        item.bounds.size = itemRect.size
        item.frame.origin = itemRect.origin
        item.frame.origin.x = centerXItem(item.bounds.width)
        item.backgroundColor = UIColor(red: CGFloat((random() % 255)/255), green: CGFloat((random() % 255))/255, blue: CGFloat((random() % 255))/255, alpha: 1)
        return item
    }
    
    func updateItem(selfView: UIView, nextState: CGRect, velocity: CGFloat) {
        let absV = abs(velocity)
        let absDis = calcDistance(preItem!, toRect: TLItemState.currentItem)
        let sizeDelt = absV * (nextState.size.width - selfView.bounds.size.width) / nextState.size.width
        
        selfView.bounds.size.width += sizeDelt
        selfView.bounds.size.height += sizeDelt
        selfView.frame.origin.y += absV * (nextState.origin.y - selfView.frame.origin.y) / absDis
        selfView.frame.origin.x = centerXItem(selfView.bounds.width)
    }
    
    func centerXItem(itemWidth: CGFloat) -> CGFloat {
        return (self.itemsView.bounds.size.width - itemWidth) / 2
    }
   
    func calcDistance(fromView: UIView, toRect: CGRect) -> CGFloat {
        return abs(CGFloat(fromView.frame.origin.y - toRect.origin.y))
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
    
    // MARK: - Timeline View
    // Slider PanGesture
    func slideGestureHandle(pan: UIPanGestureRecognizer) {
        let translationInView = pan.translationInView(self.itemsView).x
        let itemVelocity = pan.velocityInView(self.itemsView).x * slideFactor
        
        switch pan.state {
        case .Began:
            TimelineSlideView.isSlide = true
            updateTimeline()
            break
        case .Changed:
            // TODO: cant slide when out range
            TimelineSlideView.isSlide = false
            TimelineSlideView.frame.origin.x += itemVelocity
            break
        case .Ended:
            // TODO: add animation
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.TimelineSlideView.curDecadeIndex = self.TimelineSlideView.getCurDecade(self.TimelineSlideView.frame.origin.x)
                self.updateTimeline()
            })
            
            break
        default:
            break
        }
    }
    
    func updateTimeline() {
        TimelineSlideView.setNeedsDisplay()
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
