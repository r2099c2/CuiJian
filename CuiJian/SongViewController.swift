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
    @IBOutlet weak var bgParaImage: UIImageView!
    
    
    @IBOutlet weak var songScrollView: UIScrollView! {
        didSet {
            songScrollView.delegate = self
        }
    }
    @IBOutlet weak var titlecons: NSLayoutConstraint!
    
    @IBOutlet weak var songTitle: UIImageView!
    
    @IBOutlet weak var songLyric: UITextView!
    
    let songData: [[String: String]] = [
        ["title": "song1Title", "content":"那天夜里\n我和太阳和月亮\n冻在一条线上\n光太沉重\n身体太软\n我的呼吸短浅\n闭上了眼\n月光穿过了冰\n扭曲在我的身上\n光的外面\n是僵硬的壳\n它让空气像是监狱\n睁开了眼 睁开双眼\n你来到光的里面\n闭上双眼 闭上了双眼\n这就是冰的里面\n\n—★—\n\n第二天夜里\n天上没有星星\n如同你没有表情\n欲望太大\n力气太小\n希望总在挣扎里\n闭上了眼\n如同停止了呼吸\n却感受到了光芒\n光的里面\n是凝固的汗水\n突然要和我一起歌唱\n睁开了眼 睁开双眼\n你来到我的身边\n闭上了眼 闭上了双眼\n融化我在这冰的里面\n\n-★-\n\n今天夜里\n你要带我走出\n这冰冻多年的梦里\n你的表情冷漠\n你的喘气热乎乎\n你要给我人的温度\n你张开了胸怀\n拥抱我这冰中的\n最顽固的身体\n时间过得太久\n温度太低\n我已经是奄奄一息\n睁开了双眼 睁开双眼\n你来到光的里面\n闭上双眼 闭上了双眼\n这就是冰的里面\n睁开双眼 睁开双眼\n你来到了我的身边\n闭上双眼 闭上了双眼\n融化我在这冰的里面\n\n—★—\n\n今天夜里\n你会带我走出\n这冰冻多年的梦里\nOh Ye"],
        ["title": "song2Title", "content":"我站在浪尖风口\n南墙碰了我的头\n我挺着身体背着手\n风你可以斩我的首\n废话穿透了耳朵\n恐惧压歌喉\n土地松软沉默\n骨头变成了肉\n\n—★—\n\n姑娘你跟在我身后\n恐惧变忧愁\n你是否还要跟我走\n如果我死不回头\n南墙突然开个口\n要吃掉我的头\n它是否已经害怕我\n知道我死不回头\n嘟——\n如果我死不回头\n\n—★—\n\n谁让我撞上了墙口\n闻到了腐朽的臭\n墙外到底是什么\n等我把南墙撞透"],
        ["title": "song3Title", "content":"天空太小\n让我碰到了你\n我是空中的鸟\n你是水里的鱼\n我没有把你吃掉\n只是含在嘴里\n我要带着你飞\n而不要你恐惧\n\n—★—\n\n故事太巧\n偏偏是我和你\n看我们的身体\n羽毛中的鱼\n你还我一个自由\n你要放我回去\n因为我离不开海水\n你也离不开空气\n一会儿是风\n一会儿是水\n海面像个朦朦胧胧的\n大大的床\n拉我（你）入水\n你却难以站立\n你说要用海水\n清洗我（你）的肺\n\n—★—\n\n天涯海角\n我只能属于你\n我是孤独的鸟\n你是多情的鱼\n我差点被你吃掉\n羽毛还在你嘴里\n我要离开海水\n却使不出力气\n\n—★—\n\n你湿湿的身体\n像条奇怪的鱼\n我在水中吻你\n你却无法呼吸\n我没有沉到水底\n你也没有飞起\n海浪给了我和你\n一个恨的距离\n一会儿是风\n一会儿是水\n海面像个动动荡荡的\n大大的床\n推我（你）出水\n我却不愿意飞起\n你说海水就是\n鱼的眼泪"],
        ["title": "song4Title", "content":"外面的妞\n我家房顶有个口\n时间一长久\n就像是一个星球\n外面的妞\n你的身旁是北斗\n我躺在床上起\n我要射中你的星球\n外面的妞\n请你带我离家走\n外面的妞\n带我飞出这地球\n\n—★—\n\n外面的妞\n我看月亮有点儿熟\n原来是你的心\n堵住了天空的漏\n外面的妞\n你可千万别害羞\n给我你的手\n再爱我一宿\n外面的妞\n请你带我离家走\n外面的妞\n带我飞出这地球"],
        ["title": "song5Title", "content":"这几年我活得规律\n疯狂藏在心里\n发财的树\n像个通天的柱\n顶天立地\n天塌下来我有树\n鸟儿飞来飞去\n树叶变色落地\n黄金般的泥土\n来得凶猛\n残酷\n泥土就要埋没我的树\n鸟儿越是飞\n飞得越高\n越是惭愧\n绿叶看起来\n看起来越美\n越是颓废\n泥土带着风\n闻着新鲜\n让人沉睡\n泥土就要埋没我的树\n\n—★—\n\n脱下衣服吧 宝贝\n躺在床上盖被\n如果我是个动物\n你是否会更舒服\n我是你温柔的动物\n阳光照着我是浪费\n雨水早就是白给\n千年的树皮\n像是给我\n一个嘱咐\n越是冷漠越是酷"],
        ["title": "song6Title", "content":"你的眼神\n有一点湿润\n像是雨后清晨的天\n朝阳一轮\n你的表情\n有一点儿混\n像是乌云给夜晚\n守着大门\n我没有拒绝你\n在这金色早晨里\n阳光照着我身体\n轻轻站立\n我没有拒绝你\n在这金色早晨里\n天空和我的距离\n乌云远去\n\n—★—\n\n你的脸庞\n压着我胸膛\n就像乌云上面的天\n鸟在飞翔\n我闭上眼睛\n看见黑色的阳光\n才知清晨和夜晚\n是一样的混\n我没有拒绝你\n在这金色早晨里\n阳光照着我身体\n轻轻站立\n我没有拒绝你\n在这金色早晨里\n天空和我的距离\n乌云远去"],
        ["title": "song7Title", "content":"阴天的早晨\n这床像个船\n我坐在船头\n向最远的地方看\n我的身体\n缓缓的开始荡漾\n嘿\n我坚硬如石\n我柔软如棉\n雨后的大地\n走路更难\n因为这泥土\n比这皮肤更软\n我不知道前面是否还有风险\n嘿\n我慢慢地走着\n像个滚动的蛋\nYE——\n嘿\n我慢慢地走着\n像个滚动的蛋\n\n—★—\n\n太阳照着乌云\n像是一块壁毯\n使我的身体\n感到了温暖\n路边的花儿\n看起来真的新鲜\n嘿\n他们似乎在哭\n他们似乎在喊\n鲜花的下面\n是干枯的树杆\n组成了心\n和屁股的图案\n突然他们倒下\n挡住了我的路\n嘿\n我不能够停止\n因为我是个滚动的蛋\nYE——\n嘿\n我不能够停止\n因为我是个滚动的蛋"],
        ["title": "song8Title", "content":"如果你在悠闲散步\n围绕着一片浑水的湖\n幸福不再是个目的\n而是水中的一条鱼\n同行的人还有谁\n看见我的心落水\n这时音乐突然停止\n幸福跳起变成落日\n水面就是一个世界\n与我只有零的距离\n我已经听到水里发生的一切\n才知道是浑水摸鱼的感觉\n然后我越过了边界\n听见了浑浊的音乐\n这时我知道我已离开了土地\n我只能在水下飞\n呼呼 呼呼\n吸吸 吸吸\n浑水就是新鲜空气\n自由不再是个目的\n因为我就在这目的里\n\n—★—\n\n跳下去有点简单\n跳出来却没那么容易\n如果你还没有幸福\n你一定是迷恋土地\n上面的人先别下水\n告诉你我曾经是谁\n你听音乐突然响起\n告诉你水中也是监狱\n水面就是一个世界\n与我只有零的距离\n我已经听到水里发生的一切\n才知道是浑水摸鱼的感觉\n然后我越过了边界\n听见了浑浊的音乐\n这时我知道我已离开了土地\n我只能在水下飞\n呼呼 呼呼\n吸吸 吸吸\n浑水就是新鲜空气"],
        ["title": "song9Title", "content":"放开你的手\n露出你胸上的肉\n感觉我的嘴\n和舌头\n摸住我的头\n让我听到你的心跳\n让我闻到你的\n味道\n阳光下的梦\n是个温暖的坑\n我的汗水在流\n可我的心寒冷\n阳光下的梦\n是粉红的天空\n我的口水在流\n我要吐出我心胸\n\n—★—\n\n现实像条狗\n就在你面前颤抖\n就在你的绳下\n行走\n快放开你的手\n让我向更远的地方走\n在黑夜中流浪\n自由\n阳光下的梦\n是个温暖的坑\n我的汗水在流\n可我的心寒冷\n阳光下的梦\n是粉红的天空\n我的口水在流\n我要吐出我的心胸"]
    ]
    
    // string 的顺序关系到图层显示
    let songPosterData: [[String]] = [
        ["song1-1","song1-2"], ["song2-1","song2-2"], ["song3-1","song3-2","song3-3"], ["song4-1","song4-2","song4-3"], ["song5-1","song5-2","song5-3","song5-4"], ["song6-1","song6-2"], ["song7-1","song7-2"], ["song8-1","song8-2","song8-3"], ["song9-1","song9-2","song9-3"]
    ]
    
    let parallaxParameter:[CGFloat] = [0, -20, 15, -10]
    
    var pageImages: [[UIImage]] = []
    var pageViews: [UIView?] = []
    
    var curPageIndex: Int = -1
    
    var player =  (UIApplication.sharedApplication().delegate as! AppDelegate).songPlayer
    
    var pageScrollViewSize:CGSize!
    /*
    var lyricHeight: CGFloat?
    var lyricTop: CGFloat?
    var songTitleTop: CGFloat?
    var isCompressed: Bool = true
    */
    var beginCon:CGFloat?
    var maxCon:CGFloat?
    var minCon:CGFloat?

        
    @IBOutlet weak var loadingImg: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HelperFuc.bgParrallax(bgImageView, maximumRelativeValue: 20)
        HelperFuc.bgParrallax(bgParaImage, maximumRelativeValue: -20)
        
        self.songTitle.tag = 1
        
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
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                self.loadVisiblePages()
                // load first 3 pages need be show
                self.loadingImg.stopAnimating()
            }
        }
        
        addGestureToSongLyric()
        addGestureToSongTitle()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    func willEnterForeground(notification: NSNotification!) {
        // update player animation layer state when the app is brought back to the foreground
        updatePlayerState()
    }
    
    deinit {
        // make sure to remove the observer when this view controller is dismissed/deallocated
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: nil, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //updateSizeData()
    }
    
    func changeSongIndex(index: Int) {
        songScrollView.setContentOffset(CGPoint(x: pageScrollViewSize.width * CGFloat(index), y: 0), animated: true)
    }
    /*
    func updateSizeData() {
        lyricHeight = self.songLyric.bounds.height
        lyricTop = self.songLyric.frame.origin.y
        songTitleTop = self.songTitle.frame.origin.y
    }
    */
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
            let songDuration = player.songDuration[page]
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
            
            player.setupPlayerBtnLayer(playerBtnView, index: page)
            
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
        style.lineSpacing = 15
        style.alignment = .Center
        let attributes = [NSParagraphStyleAttributeName : style,
            NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.6),
            NSFontAttributeName: UIFont.systemFontOfSize(15),
            NSKernAttributeName: CGFloat(5)]
        songLyric.attributedText = NSAttributedString(string: songLyric.text, attributes:attributes)
    }
    

    // MARK: - Player
    func updatePlayerState() {
        songScrollView.setContentOffset(CGPoint(x: pageScrollViewSize.width * CGFloat(player.curIndex), y: 0), animated: true)
        player.resetPlayerAnimation()
    }
    
    @IBAction func playAudio(sender: AnyObject) {
        if player.curIndex == curPageIndex {
            if player.player!.playing == true {
                player.pausePlayer()
            } else {
                player.resumePlayer()
            }
        } else {
            player.playNewSong(curPageIndex)
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
        let songTitleTopOffset: CGFloat = 80
        // scrollbar on the top
        if songLyric.contentOffset.y <= CGPointZero.y || pan.view?.tag == 1{
            let translationInView = pan.translationInView(self.view).y
            switch pan.state {
            case .Began:
                self.beginCon = titlecons.constant
                self.minCon = songTitleTopOffset - self.songScrollView.frame.maxY
                self.maxCon = 15
                self.songScrollView.hidden = false
                break
            case .Changed:
                    if self.beginCon! + translationInView < self.maxCon && self.beginCon! + translationInView > self.minCon{
                        self.songScrollView.alpha = min(1, max(0, (self.beginCon! + translationInView - self.minCon!) / (self.maxCon! - self.minCon!)))
                        titlecons.constant = self.beginCon! + translationInView
                        self.view.layoutIfNeeded()
                    }
                break
            case .Ended:
                fallthrough
            case .Cancelled:
                fallthrough
            case .Failed:
                if titlecons.constant < (self.maxCon! + self.minCon!) / 2{
                    self.songLyric.scrollEnabled = true
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.songScrollView.alpha = 0.0
                        self.titlecons.constant = self.minCon!
                        self.view.layoutIfNeeded()
                        }, completion: { (finish) -> Void in
                            self.songScrollView.hidden = true
                            self.view.layoutIfNeeded()
                    })
                }
                else{
                    self.songLyric.scrollEnabled = false
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.songScrollView.alpha = 1
                        self.titlecons.constant = self.maxCon!
                        self.view.layoutIfNeeded()
                        }, completion: { (finish) -> Void in
                            self.view.layoutIfNeeded()
                    })
                }
                break
            default: break
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
