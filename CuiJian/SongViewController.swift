//
//  SongViewController.swift
//  CuiJian
//
//  Created by Rick on 16/1/13.
//  Copyright © 2016年 Rick. All rights reserved.
//

import UIKit

class SongViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var bgImageView: UIImageView! 
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    var isFirstLoad = true
    
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgParrallax()

        pageImages = [UIImage(named: "song1")!,UIImage(named: "song1")!,
            UIImage(named: "song1")!,UIImage(named: "song1")!,
            UIImage(named: "song1")!,UIImage(named: "song1")!,
            UIImage(named: "song1")!,UIImage(named: "song1")!,
            UIImage(named: "song1")!]
        
        let pageCount = pageImages.count
        
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        loadVisiblePages()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let pageScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pageScrollViewSize.width * CGFloat(pageImages.count), height: pageScrollViewSize.height)
        
        if isFirstLoad {
            for index in 0..<pageViews.count {
                if pageViews[index] != nil {
                    var frame = scrollView.bounds
                    frame.origin.x = frame.size.width * CGFloat(index)
                    frame.origin.y = 0.0
                    frame = CGRectInset(frame, 10.0, 0.0)
                    pageViews[index]!.frame = frame
                }
            }
            isFirstLoad = false
        }
        
    }
    
    
    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            return
        }
        
        if pageViews[page] == nil {
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            frame = CGRectInset(frame, 10.0, 0.0)
            
            let newPageView = UIImageView(image: pageImages[page])
//            newPageView.translatesAutoresizingMaskIntoConstraints = false
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
//            newPageView.frame = CGRectInset(newPageView.frame, 10.0, 0.0)
            scrollView.addSubview(newPageView)
            
//            let cstTop = NSLayoutConstraint(item: newPageView, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1, constant: 0)
//            scrollView.addConstraint(cstTop)
//            
//            let cstLeft = NSLayoutConstraint(item: newPageView, attribute: .Leading, relatedBy: .Equal, toItem: scrollView, attribute: .Leading, multiplier: 1, constant: scrollView.bounds.size.width * CGFloat(page))
//            scrollView.addConstraint(cstLeft)
//            
//            let constraintH = NSLayoutConstraint(item: newPageView, attribute: .Height, relatedBy: .Equal, toItem: scrollView, attribute: .Height, multiplier: 1, constant: 0)
//            scrollView.addConstraint(constraintH)
//            
//            let constraintW = NSLayoutConstraint(item: newPageView, attribute: .Width, relatedBy: .Equal , toItem: newPageView, attribute: .Height, multiplier: 1, constant: 0)
//            newPageView.addConstraint(constraintW)
            
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    func loadVisiblePages() {
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        loadVisiblePages()
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
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    @IBAction func backBtn(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    

}
