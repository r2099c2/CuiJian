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
    
    @IBOutlet weak var songImg: UIImageView!
    
    @IBOutlet weak var songText: UITextView!
    
    
    let songData: [[String: String]] = [
        ["imgUrl": "song1", "title": "song1Title", "content":"我站在浪尖风口\n南墙碰了我的头\n我挺着身体背着手\n风你可以斩我的首\n废话穿透耳朵\n恐惧压歌喉\n土地松软沉默\n骨头变成了肉"],
        ["imgUrl": "song2", "title": "song2Title", "content":"外面的妞\n我家房顶有个口\n时间一长久\n就象是一个星球\n外面的妞\n你的身旁是北斗\n我躺在床上起\n我要射中你的星球"],
        ["imgUrl": "song3", "title": "song3Title", "content":"你的眼神\n有一点湿润\n象是雨后清晨的天\n朝阳一仑\n你的表情\n有一点儿混\n象是乌云给夜晚\n守着大门"],
        ["imgUrl": "song4", "title": "song4Title", "content":"放开你的手\n露出你胸上的肉\n感觉我的嘴\n和舌头\n摸住我的头\n让我听到你的心跳\n让我闻到你的\n味道"],
        ["imgUrl": "song5", "title": "song5Title", "content":"那天夜里\n我和太阳和月亮\n冻在一条线上\n光太沉重\n身体太软\n我的呼吸短浅\n\n闭上了眼\n月光穿过了冰\n扭曲在我的身上\n光的外面\n是僵硬的壳\n它让空气像是监狱"],
        ["imgUrl": "song6", "title": "song6Title", "content":"如果你在悠闲散步\n围绕着一片浑水的湖\n幸福不再是个目的\n而是水中的一条鱼\n\n同行的人还有谁\n看见我的心落水\n这时音乐突然停止\n幸福跳起变成落日 \n\n(副歌)\n水面就是一个边界\n与我只有零的距离\n我已经听到了水里发生的一切\n才知道浑水摸鱼的感觉\n然后我越过了边界\n听见了浑浊的音乐\n这时我知道我已离开了土地\n我只能在水下飞"],
        ["imgUrl": "song7", "title": "song7Title", "content":"这几年我活得规律\n 疯狂藏在心里\n发财的树\n象个通天的柱\n顶天立地\n——天塌下来我有树"],
        ["imgUrl": "song8", "title": "song8Title", "content":"天空太小\n让我碰到了你\n我是空中的鸟\n你是水里的鱼\n\n我没有把你吃掉\n只是含在嘴里\n我要带着你飞\n而不要你恐惧"],
        ["imgUrl": "song9", "title": "song9Title", "content":"阴天的早晨  这床像个船\n我坐在船头  向最远的地方看\n我的身体  缓缓的开始荡漾\n嘿  我坚硬如石  我柔软如棉\n\n雨后的大地  走路更难\n因为这泥土  比这皮肤更软\n我不知道前面是否还有风险\n嘿  我慢慢地走着  像个滚动的蛋"]
    ]
    
    var isFirstLoad = true
    
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgParrallax(bgImageView)

        for item in songData {
            pageImages.append(UIImage(named: item["imgUrl"]!)!)
        }
        
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
        
        getContent(page)
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        loadVisiblePages()
    }
    
    func getContent(index: Int) {
        songImg.image = UIImage(named: songData[index]["title"]!)
        songText.text = songData[index]["content"]!
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 26
        style.alignment = .Center
        let attributes = [NSParagraphStyleAttributeName : style,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(15)]
        songText.attributedText = NSAttributedString(string: songText.text, attributes:attributes)
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
