//
//  MVCell.swift
//  CuiJian
//
//  Created by BriceZHOU on 1/31/16.
//  Copyright © 2016 Rick. All rights reserved.
//

import UIKit

class MVCell: UICollectionViewCell {
    var imageView:UIImageView!
    var playBt:UIButton!
    var _mvData:MVData?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initComponent()
    }
    
    func initComponent(){
        
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.imageView!.contentMode = UIViewContentMode.ScaleAspectFill
        self.addSubview(self.imageView!)
        
        self.playBt = UIButton(type: UIButtonType.Custom)
        self.playBt.frame = CGRect(x: self.frame.width * 0.92 - 70, y: self.frame.height * 0.9 - 70, width: 70, height: 70)
        self.playBt.setImage(UIImage(named: "mvplay"), forState: UIControlState.Normal)
        self.addSubview(self.playBt)

    }
    
    func setData(mv:MVData){
        self._mvData = mv
        self.imageView.image = UIImage(named: mv.imageName)
    }
    
}

class MVData {
    var imageName:String = ""
    var videoName:String = ""
    init(imageName:String, videoName:String){
        self.imageName = imageName
        self.videoName = videoName
    }
}
