//
//  SongViewController.swift
//  CuiJian
//
//  Created by Rick on 16/1/13.
//  Copyright © 2016年 Rick. All rights reserved.
//

import UIKit
import AVFoundation

class SongViewController: UIViewController, UIScrollViewDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var bgImageView: UIImageView! 
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var songTitle: UIImageView!
    
    @IBOutlet weak var songText: UITextView!
    
    
    let songData: [[String: String]] = [
        ["imgUrl": "song1", "title": "song1Title", "content":"我站在浪尖风口\n南墙碰了我的头\n我挺着身体背着手\n风你可以斩我的首\n废话穿透耳朵\n恐惧压歌喉\n土地松软沉默\n骨头变成了肉", "song": "testSong.mp3"],
        ["imgUrl": "song2", "title": "song2Title", "content":"外面的妞\n我家房顶有个口\n时间一长久\n就象是一个星球\n外面的妞\n你的身旁是北斗\n我躺在床上起\n我要射中你的星球", "song": "testSong.mp3"],
        ["imgUrl": "song3", "title": "song3Title", "content":"你的眼神\n有一点湿润\n象是雨后清晨的天\n朝阳一仑\n你的表情\n有一点儿混\n象是乌云给夜晚\n守着大门", "song": "testSong.mp3"],
        ["imgUrl": "song4", "title": "song4Title", "content":"放开你的手\n露出你胸上的肉\n感觉我的嘴\n和舌头\n摸住我的头\n让我听到你的心跳\n让我闻到你的\n味道", "song": "testSong.mp3"],
        ["imgUrl": "song5", "title": "song5Title", "content":"那天夜里\n我和太阳和月亮\n冻在一条线上\n光太沉重\n身体太软\n我的呼吸短浅\n\n闭上了眼\n月光穿过了冰\n扭曲在我的身上\n光的外面\n是僵硬的壳\n它让空气像是监狱", "song": "testSong.mp3"],
        ["imgUrl": "song6", "title": "song6Title", "content":"如果你在悠闲散步\n围绕着一片浑水的湖\n幸福不再是个目的\n而是水中的一条鱼\n\n同行的人还有谁\n看见我的心落水\n这时音乐突然停止\n幸福跳起变成落日 \n\n(副歌)\n水面就是一个边界\n与我只有零的距离\n我已经听到了水里发生的一切\n才知道浑水摸鱼的感觉\n然后我越过了边界\n听见了浑浊的音乐\n这时我知道我已离开了土地\n我只能在水下飞", "song": "testSong.mp3"],
        ["imgUrl": "song7", "title": "song7Title", "content":"这几年我活得规律\n 疯狂藏在心里\n发财的树\n象个通天的柱\n顶天立地\n——天塌下来我有树", "song": "testSong.mp3"],
        ["imgUrl": "song8", "title": "song8Title", "content":"天空太小\n让我碰到了你\n我是空中的鸟\n你是水里的鱼\n\n我没有把你吃掉\n只是含在嘴里\n我要带着你飞\n而不要你恐惧", "song": "testSong.mp3"],
        ["imgUrl": "song9", "title": "song9Title", "content":"阴天的早晨  这床像个船\n我坐在船头  向最远的地方看\n我的身体  缓缓的开始荡漾\n嘿  我坚硬如石  我柔软如棉\n\n雨后的大地  走路更难\n因为这泥土  比这皮肤更软\n我不知道前面是否还有风险\n嘿  我慢慢地走着  像个滚动的蛋", "song": "testSong.mp3"]
    ]
    
    var pageImages: [UIImage] = []
    var pageViews: [UIView?] = []
    
    var curPageIndex = 0
    
    var player: AVAudioPlayer?
    var isPlay = false
    
    var pageScrollViewSize:CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HelperFuc.bgParrallax(bgImageView)
        
        // 防止溢出，解决返回超出的bug
        self.view.layer.masksToBounds = true

        // get img url data and send to pageImages
        for item in songData {
            pageImages.append(UIImage(named: item["imgUrl"]!)!)
        }
        
        // init pageViews
        let pageCount = pageImages.count
        
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // 使用UIScreen的size来初始化，避免viewdidappear的时候出现一个大小的跳动。
        self.pageScrollViewSize = CGSize(width: UIScreen.mainScreen().bounds.size.width - 72, height: UIScreen.mainScreen().bounds.size.width - 72)
        
        // set scroll view contentSize
        scrollView.contentSize = CGSize(width: self.pageScrollViewSize.width * CGFloat(pageImages.count), height: self.pageScrollViewSize.height)
        
        // load first 3 pages need be show
        loadVisiblePages()
    }
    
    
    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
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
            
            let newImgView = UIImageView(image: pageImages[page])
            newImgView.contentMode = .ScaleAspectFit
            newPageView.addSubview(newImgView)
            newImgView.frame = newPageView.bounds
            
            let newTextView = UILabel()
            newTextView.text = "30’试听"
            newTextView.font = UIFont.systemFontOfSize(13)
            newTextView.textColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1)
            newPageView.addSubview(newTextView)
            newTextView.bounds.size = CGSize(width: 50, height: 0.16 * newPageView.bounds.width)
            newTextView.frame.origin.x = newPageView.bounds.width - newTextView.bounds.width
            newTextView.frame.origin.y = newPageView.bounds.height - newTextView.bounds.height
            
            let playerBtnView = UIButton()
            newPageView.addSubview(playerBtnView)
            playerBtnView.backgroundColor = UIColor.greenColor()
            playerBtnView.bounds.size = CGSize(width: 0.16 * newPageView.bounds.width, height: 0.16 * newPageView.bounds.width)
            playerBtnView.frame.origin.x = newTextView.frame.origin.x - 8 - playerBtnView.bounds.width
            playerBtnView.frame.origin.y = newPageView.bounds.height - playerBtnView.bounds.height
            playerBtnView.addTarget(self, action: "playAudio:", forControlEvents: .TouchUpInside)
            
            scrollView.addSubview(newPageView)
            
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
        let pageWidth = self.pageScrollViewSize.width
        curPageIndex = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
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
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
        
        // first time in page
        if self.songTitle.image == nil {
            setContentForCurrentPage(curPageIndex)
            makeAudio()
        }
    }
    
    // MARK: - ScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        loadVisiblePages()
        if isPlay {
            player?.stop()
            isPlay = (player?.playing)!
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        hideSongContent()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        setContentForCurrentPage(curPageIndex)
        showSongContent()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        makeAudio()
    }
    
    func hideSongContent() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.songTitle.transform = CGAffineTransformMakeScale(0.001, 0.001)
            self.songText.transform = CGAffineTransformMakeScale(0.001, 0.001)
            }) { (finished) -> Void in
                self.songTitle.hidden = true
                self.songText.hidden = true
        }
    }
    
    func showSongContent() {
        self.songTitle.transform = CGAffineTransformMakeScale(0.5, 0.5)
        self.songText.transform = CGAffineTransformMakeScale(0.7, 0.7)
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: .CurveEaseIn, animations: { () -> Void in
            self.songTitle.hidden = false
            self.songTitle.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: nil)
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .CurveEaseIn, animations: { () -> Void in
            self.songText.hidden = false
            self.songText.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: nil)
    }
    
    func setContentForCurrentPage(index: Int) {
        songTitle.image = UIImage(named: songData[index]["title"]!)
        songText.text = songData[index]["content"]!
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 26
        style.alignment = .Center
        let attributes = [NSParagraphStyleAttributeName : style,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(15)]
        songText.attributedText = NSAttributedString(string: songText.text, attributes:attributes)
    }
    
    //MARK: - Audio Player
    func setupAudioPlayerWithFile(file: String, type: String) -> AVAudioPlayer? {
        let path = NSBundle.mainBundle().pathForResource(file, ofType: type)
        let url = NSURL.fileURLWithPath(path!)
        
        var audioPlayer: AVAudioPlayer?
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("wrong audio")
        }
        
        return audioPlayer
    }
    
    func makeAudio() {
        let fileFullName = songData[curPageIndex]["song"]
        let strSplit = fileFullName?.componentsSeparatedByString(".")
        let fileName = String(strSplit![0])
        let fileType = String(strSplit![1])
        
        if let songPlayer = setupAudioPlayerWithFile(fileName, type: fileType) {
            player = songPlayer
        }
        
    }
    
    @IBAction func playAudio(sender: AnyObject) {
        if isPlay {
            player?.stop()
            isPlay = (player?.playing)!
        } else {
            if player != nil {
                player!.play()
                isPlay = (player?.playing)!
            }
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        isPlay = false
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        isPlay = false
    }
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer) {
        player.stop()
        isPlay = player.playing
    }
    
    func audioPlayerEndInterruption(player: AVAudioPlayer) {
        player.play()
        isPlay = player.playing
    }
    
    
    // MARK: - Navigation

    @IBAction func backBtn(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    

}
