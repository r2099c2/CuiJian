//
//  TCPlayerViewController.swift
//  CuiJian
//
//  Created by logicdesign on 5/16/16.
//  Copyright © 2016 Rick. All rights reserved.
//


class TCPlayerViewController: UIViewController, TCPlayerEngineDelegate {
    var playerView: TCCloudPlayerView!
    var backBtn: UIButton!
    override func viewDidLoad() {
        self.playerView = TCCloudPlayerView(frame: self.view.frame)
        self.view.addSubview(playerView)
        self.playerView.playerDelegate = self
        self.backBtn = UIButton(frame: CGRect(x: 15, y: 15, width: 30, height: 30))
        self.backBtn.setImage(UIImage(named: "backArrow"), forState: .Normal)
        self.playerView.addSubview(self.backBtn)
        self.backBtn.addTarget(self, action: #selector(TCPlayerViewController.endplay), forControlEvents: .TouchDown)
    }
    
    func play(video1:String, video2:String){
        let res = TCPlayResItem()
        let item = TCPlayItem()
        item.url = video1
        item.type = "标清"
        res.items.addObject(item)
        let item1 = TCPlayItem()
        item1.url = video2
        item1.type = "高清"
        res.items.addObject(item1)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(self, animated: true, completion: {
            self.playerView.play(res, atIndex: 0)
            self.playerView.changeToFullScreen(true)
        })
    }
    
    func onPlayerFailed(player: TCPlayerEngine!, errorType errType: TCPlayerErrorType) {
        self.playerView.changeToFullScreen(false)
        let alertView:UIAlertView = UIAlertView(title: "网络异常", message: "网络访问出现异常，请确保网络连接正常再尝试。", delegate: self, cancelButtonTitle: "确定")
        alertView.show()
    }
    
    func onPlayOver(player: TCPlayerEngine!) {
        self.endplay()
    }
    func endplay() {
        self.playerView.changeToFullScreen(false)
        self.playerView.stop()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
