//
//  SongViewController.swift
//  CuiJian
//
//  Created by Rick on 16/1/13.
//  Copyright © 2016年 Rick. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore

class SongViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate, SongListDelegate {
    
    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var songScrollView: UIScrollView! {
        didSet {
            songScrollView.delegate = self
        }
    }
    
    @IBOutlet weak var songTitle: UIImageView!
    
    @IBOutlet weak var songLyric: UITextView!
    
    let songData: [[String: String]] = [
        ["title": "song1Title", "content":"那天夜里\n我和太阳和月亮\n冻在一条线上\n光太沉重\n身体太软\n我的呼吸短浅\n\n闭上了眼\n月光穿过了冰\n扭曲在我的身上\n光的外面\n是僵硬的壳\n它让空气像是监狱", "song": "01guangdong.mp3"],
        ["title": "song2Title", "content":"我站在浪尖风口\n南墙碰了我的头\n我挺着身体背着手\n风你可以斩我的首\n废话穿透耳朵\n恐惧压歌喉\n土地松软沉默\n骨头变成了肉", "song": "02sibuhuitou.mp3"],
        ["title": "song3Title", "content":"天空太小\n让我碰到了你\n我是空中的鸟\n你是水里的鱼\n\n我没有把你吃掉\n只是含在嘴里\n我要带着你飞\n而不要你恐惧", "song": "03yuniaozhilian.mp3"],
        ["title": "song4Title", "content":"外面的妞\n我家房顶有个口\n时间一长久\n就象是一个星球\n外面的妞\n你的身旁是北斗\n我躺在床上起\n我要射中你的星球", "song": "04waimiandeniu.mp3"],
        ["title": "song5Title", "content":"这几年我活得规律\n 疯狂藏在心里\n发财的树\n象个通天的柱\n顶天立地\n——天塌下来我有树", "song": "05kuguashu.mp3"],
        ["title": "song6Title", "content":"你的眼神\n有一点湿润\n象是雨后清晨的天\n朝阳一仑\n你的表情\n有一点儿混\n象是乌云给夜晚\n守着大门", "song": "06jinsezaochen.mp3"],
        ["title": "song7Title", "content":"阴天的早晨  这床像个船\n我坐在船头  向最远的地方看\n我的身体  缓缓的开始荡漾\n嘿  我坚硬如石  我柔软如棉\n\n雨后的大地  走路更难\n因为这泥土  比这皮肤更软\n我不知道前面是否还有风险\n嘿  我慢慢地走着  像个滚动的蛋", "song": "07gundongdedan.mp3"],
        ["title": "song8Title", "content":"如果你在悠闲散步\n围绕着一片浑水的湖\n幸福不再是个目的\n而是水中的一条鱼\n\n同行的人还有谁\n看见我的心落水\n这时音乐突然停止\n幸福跳起变成落日 \n\n(副歌)\n水面就是一个边界\n与我只有零的距离\n我已经听到了水里发生的一切\n才知道浑水摸鱼的感觉\n然后我越过了边界\n听见了浑浊的音乐\n这时我知道我已离开了土地\n我只能在水下飞", "song": "08hunshuihumanbu.mp3"],
        ["title": "song9Title", "content":"放开你的手\n露出你胸上的肉\n感觉我的嘴\n和舌头\n摸住我的头\n让我听到你的心跳\n让我闻到你的\n味道", "song": "09yangguangxiademeng.mp3"]
    ]
    
    // string 的顺序关系到图层显示
    let songPosterData: [[String]] = [
        ["song1-1","song1-2"], ["song2-1","song2-2"], ["song3-1","song3-2","song3-3"], ["song4-1","song4-2","song4-3"], ["song5-1","song5-2","song5-3","song5-4"], ["song6-1","song6-2","song6-3"], ["song7-1","song7-2"], ["song8-1","song8-2"], ["song9-1","song9-2","song9-3"]
    ]
    
    let parallaxParameter:[CGFloat] = [0, 15, -10, 10]
    
    var pageImages: [[UIImage]] = []
    var pageViews: [UIView?] = []
    
    var curPageIndex: Int = -1
    
    var players: [SongPlayer] = []
    
    var pageScrollViewSize:CGSize!
    
    var lyricHeight: CGFloat?
    var lyricTop: CGFloat?
    var songTitleTop: CGFloat?
    var isCompressed: Bool = true
        
    @IBOutlet weak var loadingImg: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HelperFuc.bgParrallax(bgImageView)
        
        // 防止溢出，解决返回超出的bug
        self.view.layer.masksToBounds = true
        
        // get img url data and send to pageImages
        for (var i = 0; i < songPosterData.count; i++) {
            pageImages.append([])
            for (var j = 0; j < songPosterData[i].count; j++) {
                pageImages[i].append(UIImage(named: songPosterData[i][j])!)
            }
        }
        
        // init pageViews
        let pageCount = songData.count
        
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // 使用UIScreen的size来初始化，避免viewdidappear的时候出现一个大小的跳动。
        self.pageScrollViewSize = CGSize(width: UIScreen.mainScreen().bounds.size.width - 72, height: UIScreen.mainScreen().bounds.size.width - 72)
        
        // set scroll view contentSize
        songScrollView.contentSize = CGSize(width: self.pageScrollViewSize.width * CGFloat(songData.count), height: self.pageScrollViewSize.height)
        
        // make audio player and load all audio
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            self.loadAudios()
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                // load first 3 pages need be show
                self.loadVisiblePages()
                self.loadingImg.stopAnimating()
            }
        }
        
        addGestureToSongLyric()
        addGestureToSongTitle()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        updateSizeData()
    }
    
    func changeSongIndex(index: Int) {
        songScrollView.setContentOffset(CGPoint(x: pageScrollViewSize.width * CGFloat(index), y: 0), animated: true)
    }
    
    func updateSizeData() {
        lyricHeight = self.songLyric.bounds.height
        lyricTop = self.songLyric.frame.origin.y
        songTitleTop = self.songTitle.frame.origin.y
    }
    
    func loadPage(page: Int) {
        if page < 0 || page >= songData.count {
            return
        }
        
        // if page is not exist
        if pageViews[page] == nil {
            var frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.pageScrollViewSize)
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            // 让前后两页的page显示出一小部分
            frame = CGRectInset(frame, 10.0, 0.0)
            
            let newPageView = UIView()
            newPageView.frame = frame
            
            for (var pageImageIndex = 0; pageImageIndex < pageImages[page].count; pageImageIndex++) {
                let newImageView = UIImageView(image: pageImages[page][pageImageIndex])
                newImageView.contentMode = .ScaleAspectFit
                newPageView.addSubview(newImageView)
                newImageView.frame = newPageView.bounds
                if pageImageIndex > 0 {
                    HelperFuc.bgParrallax(newImageView, maximumRelativeValue: parallaxParameter[pageImageIndex])
                }
            }
            
            let newTextView = UILabel()
            let songDuration = players[page].player!.duration
            newTextView.text = stringFromTimeInterval(songDuration)
            newTextView.font = UIFont.systemFontOfSize(13)
            newTextView.textColor = UIColor(red: 110/255.0, green: 110/255.0, blue: 110/255.0, alpha: 1)
            newPageView.addSubview(newTextView)
            newTextView.bounds.size = CGSize(width: 50, height: 0.16 * newPageView.bounds.width)
            newTextView.frame.origin.x = newPageView.bounds.width - newTextView.bounds.width
            newTextView.frame.origin.y = newPageView.bounds.height - newTextView.bounds.height
            
            let playerBtnView = UIButton()
            newPageView.addSubview(playerBtnView)
            playerBtnView.bounds.size = CGSize(width: 0.16 * newPageView.bounds.width, height: 0.16 * newPageView.bounds.width)
            playerBtnView.frame.origin.x = newTextView.frame.origin.x - 8 - playerBtnView.bounds.width
            playerBtnView.frame.origin.y = newPageView.bounds.height - playerBtnView.bounds.height
            playerBtnView.addTarget(self, action: "playAudio:", forControlEvents: .TouchUpInside)
            
            players[page].setupBtnLayer(playerBtnView)
            
            songScrollView.addSubview(newPageView)
            
            pageViews[page] = newPageView
            
        }
    }
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
//        let hours = (interval / 3600)
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    func purgePage(page: Int) {
        if page < 0 || page >= songData.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            players[page].stopPlayer()
            pageViews[page] = nil
        }
    }
    
    func loadVisiblePages() {
        // First, determine which page is currently visible
        let pageWidth = self.pageScrollViewSize.width
        var newPageIndex = Int(floor((songScrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        if curPageIndex != newPageIndex {
            if newPageIndex < 0 {
                newPageIndex = 0
            } else if newPageIndex >= songData.count {
                newPageIndex = songData.count - 1
            }
            curPageIndex = newPageIndex
            if curPageIndex < 0 {
                curPageIndex = 0
            }
            
            // Work out which pages you want to load
            let firstPage = curPageIndex - 1
            let lastPage = curPageIndex + 1
            
            // Purge anything before the first page
            for var index = 0; index < firstPage; ++index {
                purgePage(index)
            }
            
            // Load pages in our range
            for index in firstPage...lastPage {
                loadPage(index)
            }
            
            // Purge anything after the last page
            for var index = lastPage+1; index < songData.count; ++index {
                purgePage(index)
            }
            
            // first time in page
            if self.songTitle.image == nil {
                setContentForCurrentPage(curPageIndex)
            }
        }
    }
    
    
    var timer = NSTimer()
    var lyricIsHidden = false
    
    // MARK: - ScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        loadVisiblePages()
        if players[curPageIndex].player?.playing == true {
            players[curPageIndex].pausePlayer()
        }
        
        hideSongContent()
        
        // delay 0.3, because of hideSongContent duration is 0.2
        // just in case user slide very fast less then 0.2
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "timeOut", userInfo: nil, repeats: false)
    }
    
    func timeOut() {
        setContentForCurrentPage(curPageIndex)
        showSongContent()
    }
    
    func hideSongContent() {
        if !lyricIsHidden {
            self.lyricIsHidden = true
            self.songTitle.layer.removeAllAnimations()
            self.songLyric.layer.removeAllAnimations()
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.songTitle.transform = CGAffineTransformMakeScale(0.001, 0.001)
                self.songLyric.transform = CGAffineTransformMakeScale(0.001, 0.001)
                }) { (finished) -> Void in
                    self.songTitle.hidden = true
                    self.songLyric.hidden = true
            }
        }
    }
    
    func showSongContent() {
        self.lyricIsHidden = false
        self.songTitle.layer.removeAllAnimations()
        self.songLyric.layer.removeAllAnimations()
        self.songTitle.transform = CGAffineTransformMakeScale(0.5, 0.5)
        self.songLyric.transform = CGAffineTransformMakeScale(0.7, 0.7)
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: .CurveEaseIn, animations: { () -> Void in
            self.songTitle.hidden = false
            self.songTitle.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: { (finished) -> Void in
                
        })
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .CurveEaseIn, animations: { () -> Void in
            self.songLyric.hidden = false
            self.songLyric.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: { (finished) -> Void in
//               self.lyricIsHidden = false
        })
    }
    
    func setContentForCurrentPage(index: Int) {
        songTitle.image = UIImage(named: songData[index]["title"]!)
        songLyric.text = songData[index]["content"]!
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 20
        style.alignment = .Center
        let attributes = [NSParagraphStyleAttributeName : style,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(15)]
        songLyric.attributedText = NSAttributedString(string: songLyric.text, attributes:attributes)
    }
    
    //MARK: - Audio Player
    func loadAudios() {
        for (var pageIndex = 0; pageIndex < songData.count; pageIndex++) {
            let fileFullName = songData[pageIndex]["song"]
            let strSplit = fileFullName?.componentsSeparatedByString(".")
            let fileName = String(strSplit![0])
            let fileType = String(strSplit![1])
            
            players.append(SongPlayer())
            if let songPlayer = players[pageIndex].setupAudioPlayerWithFile(fileName, type: fileType) {
                players[pageIndex].player = songPlayer
            }
        }
    }

    @IBAction func playAudio(sender: AnyObject) {
        if players[curPageIndex].player?.playing == true{
            players[curPageIndex].pausePlayer()
        } else {
            if players[curPageIndex].player != nil {
                players[curPageIndex].resumePlayer()
            }
        }
    }
    
        
    // MARK: - Scroll
    
    // add gesture to song lyric
    // if lyric is compressed -> scroll up -> release lyric(lyric add height & title image and img scroll view subtract offset y)
    // if lyric is releaseed -> scroll down -> if lyric scroll bar is on the top -> compress lyric
    func addGestureToSongLyric() {
        let panGesture = UIPanGestureRecognizer(target: self, action: "songTextGestureAction:")
        songLyric.addGestureRecognizer(panGesture)
        panGesture.delegate = self
    }
    
    func addGestureToSongTitle() {
        let panGesture = UIPanGestureRecognizer(target: self, action: "songTextGestureAction:")
        songTitle.addGestureRecognizer(panGesture)
    }
    
    func songTextGestureAction(pan: UIPanGestureRecognizer) {
        let songTitleTopOffset:CGFloat = 100
        let songTitleBottomOffset = self.songScrollView.bounds.height + self.songScrollView.frame.origin.y + 15.0
        // scrollbar on the top
        if songLyric.contentOffset.y <= CGPointZero.y {
            let translationInView = pan.translationInView(self.view).y
            let tanslationABS = abs(translationInView)
            if isCompressed && translationInView < 0 {
                
                switch pan.state {
                case .Changed:
                    if songTitle.frame.origin.y > 30 {
                        self.songLyric.bounds.size.height = tanslationABS + lyricHeight!
                        self.songLyric.frame.origin.y = lyricTop! - tanslationABS
                        if self.songScrollView.alpha > 0.0 {
                            self.songScrollView.alpha = (300 - tanslationABS) / 300
                        }
                        self.songTitle.frame.origin.y = songTitleTop! - tanslationABS
                    }
                    break
                case .Ended:
                    fallthrough
                case .Cancelled:
                    fallthrough
                case .Failed:
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.songScrollView.alpha = 0.0
                        self.songTitle.frame.origin.y = songTitleTopOffset
                        self.songLyric.bounds.size.height = self.view.bounds.height - self.songTitle.bounds.height - 100.0 - 15.0
                        self.songLyric.frame.origin.y = self.songTitle.bounds.height + 100.0 + 15.0
                        }, completion: { (finish) -> Void in
                            self.songScrollView.hidden = true
                            self.songLyric.scrollEnabled = true
                            self.isCompressed = false
                            self.updateSizeData()
                    })
                    break
                default: break
                }
            } else if !isCompressed && translationInView > 0 {
                self.songScrollView.hidden = false
                switch pan.state {
                case .Changed:
                    self.songLyric.bounds.size.height = lyricHeight! - tanslationABS
                    self.songLyric.frame.origin.y = lyricTop! + tanslationABS
                    if self.songScrollView.alpha < 1.0 {
                        self.songScrollView.alpha = tanslationABS / 300
                    }
                    self.songTitle.frame.origin.y = songTitleTop! + tanslationABS
                    break
                case .Ended:
                    fallthrough
                case .Cancelled:
                    fallthrough
                case .Failed:
                    
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.songScrollView.alpha = 1.0
                        self.songTitle.frame.origin.y = songTitleBottomOffset
                        self.songLyric.bounds.size.height = self.view.bounds.height - self.songTitle.frame.origin.y - self.songTitle.bounds.height - 15.0
                        self.songLyric.frame.origin.y = self.songTitle.frame.origin.y + self.songTitle.bounds.height + 15.0
                        }, completion: { (finish) -> Void in
                            self.isCompressed = true
                            self.updateSizeData()
                            self.songLyric.scrollEnabled = false
                            self.songLyric.layoutIfNeeded()
                    })
                    break
                default: break
                }
            }
            
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
    // MARK: - Navigation
    
    @IBAction func backBtn(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "songlistidentifier" {
            if let songlistVC = segue.destinationViewController as? SongListViewController {
                songlistVC.songListDelegte = self
            }
        }
    }
    
    
    
}
