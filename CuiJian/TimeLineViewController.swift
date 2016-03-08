//
//  TimeLineViewController.swift
//  CuiJian
//
//  Created by BriceZHOU on 2/22/16.
//  Copyright © 2016 Rick. All rights reserved.
//

import UIKit

class TimeLineViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    @IBOutlet weak var rulerView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var leftCoverImage:UIImageView!
    var rightCoverImage:UIImageView!
    
    var data:[News]?
    
    func getDataCount() -> Int{
        if self.data != nil{
            return self.data!.count
        }
        return 0;
    }
    
    override func viewDidLoad() {
        self.leftCoverImage = UIImageView(frame: CGRect(x: -5, y: 0, width: UIScreen.mainScreen().bounds.width / 2, height: 70))
        self.leftCoverImage.image = UIImage(named: "rulerCoverL")
        self.rightCoverImage = UIImageView(frame: CGRect(x: UIScreen.mainScreen().bounds.size.width / 2 + 5, y: 0, width: UIScreen.mainScreen().bounds.width / 2, height: 70))
        self.rightCoverImage.image = UIImage(named: "rullerCover")
        self.rulerView.addSubview(self.leftCoverImage)
        self.rulerView.addSubview(self.rightCoverImage)
        self.rulerView.tag = 1
        self.leftCoverImage.layer.zPosition = 999
        self.rightCoverImage.layer.zPosition = 999
        self.rulerView.delegate = self
        self.initRule()
        self.rulerView.showsHorizontalScrollIndicator = false
        
        self.collectionView.registerClass(CardCollectionViewCell.self, forCellWithReuseIdentifier: "ItemIdentifier")
        self.collectionView.indicatorStyle = .White
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        
        HelperFuc.getAbout(false) { (finished, results) -> Void in
            self.data = results as? [News]
            self.collectionView.reloadData()
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.rulerView.contentOffset.x = self.rulerView.contentSize.width - self.rulerView.bounds.size.width + self.rulerView.contentInset.right
        }
        
        let itemWidth = (self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width

        self.collectionView.scrollRectToVisible(CGRect(x: 0, y: CGFloat(self.getDataCount()) * itemWidth, width: self.collectionView!.frame.width, height: self.collectionView!.frame.height), animated: true)

    }
    
    func initRule(){
        var width:CGFloat! = 0
        for(var i = 0; i < 12; i++){
            let ruleCell = DTRulerViewScale(value: 1930 + i * 10, height: 70)
            ruleCell.frame.origin.x = ruleCell.frame.width * CGFloat(i)
            self.rulerView.addSubview(ruleCell)
            width = ruleCell.frame.width
        }
        self.rulerView.contentSize = CGSize(width: width * CGFloat(12), height: 70)
        self.rulerView.contentInset = UIEdgeInsets(top: 0, left: -CGFloat(3.5) * width - DTRulerScaleGap / 2 - 1 + 0.5 * UIScreen.mainScreen().bounds.size.width, bottom: 0, right: -CGFloat(3.5) * width + DTRulerScaleGap / 2 + 1 + 0.5 * UIScreen.mainScreen().bounds.size.width)
    }
    
    @IBAction func backBt(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(scrollView.tag == 1){
            self.leftCoverImage.transform = CGAffineTransformMakeTranslation(scrollView.contentOffset.x, 0);
            self.rightCoverImage.transform = CGAffineTransformMakeTranslation(scrollView.contentOffset.x, 0);
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.tag == 1{
            self.makeCenter()
        }
        else{
            self.makeCollectionCenter()
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(decelerate == false){
            if scrollView.tag == 1{
                self.makeCenter()
            }
            else{
                self.makeCollectionCenter()
            }
        }
    }
    
    func makeCenter(){
        let distance = self.rulerView.contentOffset.x + self.rulerView.contentInset.left
        let deltaDistance = distance - round(distance / 100) * 100
        var finalDistance = round(distance / 100) * 100
        if deltaDistance >= 50.0{
            finalDistance += 100
        }
        UIView.animateWithDuration(0.3) { () -> Void in
            self.rulerView.contentOffset.x = finalDistance - self.rulerView.contentInset.left
        }
        
        let currentYears = 1960 + Int(finalDistance) / 10
        let itemWidth = (self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width

        for(var index = 0; index < self.getDataCount(); index++){
            if(self.getYear(self.data![index].post_date!) >= currentYears)
            {
                self.collectionView.scrollRectToVisible(CGRect(x: 0, y: CGFloat(index) * itemWidth, width: self.collectionView!.frame.width, height: self.collectionView!.frame.height), animated: true)
                break;
            }
        }
        
    }
    
    func makeCollectionCenter(){
        let distance = self.collectionView!.contentOffset.y
        let itemWidth = (self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width
        let deltaDistance = distance - round(distance / itemWidth) * itemWidth
        var finalDistance = round(distance / itemWidth) * itemWidth
        if deltaDistance >= itemWidth / 2{
            finalDistance += itemWidth
        }
        
        self.collectionView.scrollRectToVisible(CGRect(x: 0, y: finalDistance, width: self.collectionView!.frame.width, height: self.collectionView!.frame.height), animated: true)
        
        let currentYears = floor(CGFloat(self.getYear(self.data![Int(round(distance / itemWidth))].post_date!)) / 10.0) * 10.0
        let scroll = (currentYears - 1960) / 10 * 100 - self.rulerView.contentInset.left
        UIView.animateWithDuration(0.3) { () -> Void in
            self.rulerView.contentOffset.x = scroll
        }

        
    }
    
    func getYear(date:NSString) -> Int{
        let yearString = date.substringToIndex(4)
        return Int(yearString)!
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.getDataCount()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CardCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ItemIdentifier", forIndexPath: indexPath) as! CardCollectionViewCell
        cell.setCellData(self.data![indexPath.item])
        return cell
    }
    
}
