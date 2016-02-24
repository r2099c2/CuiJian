//
//  CardCollectionViewCell.swift
//  CuiJian
//
//  Created by BriceZHOU on 2/23/16.
//  Copyright © 2016 Rick. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    var imageView:UIImageView!
    var titleLabel:UILabel!
    var contentLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView = UIImageView(frame: frame)
        self.imageView.frame.origin = CGPointZero
        self.addSubview(self.imageView)
        
        self.titleLabel = UILabel(frame: CGRect(x: 16, y: 32, width: frame.width - 32, height: 32))
        self.titleLabel.textColor = UIColor.whiteColor()
        self.addSubview(self.titleLabel)
        
        self.contentLabel = UILabel(frame: CGRect(x: 16, y: 54, width: frame.width - 32, height: frame.height - 60))
        self.contentLabel.textColor = UIColor.whiteColor()
        self.addSubview(self.contentLabel)
        
        self.backgroundColor = UIColor.blackColor()
        
        let layer = self.layer
        layer.shadowOffset = CGSizeZero
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowColor = UIColor.blackColor().CGColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCellData(news:News){
        self.titleLabel.text = "\(news.post_title!)"
        self.contentLabel.text = "\(news.post_content!)"
        self.contentLabel.numberOfLines = 0
        self.contentLabel.sizeThatFits(self.contentLabel.frame.size)
        if(news.feature_image != nil){
            self.imageView.sd_setImageWithURL(NSURL(string: news.feature_image as! String)!, placeholderImage: UIImage(named: "newsBg"))
        }
        else{
            self.imageView.image = UIImage(named: "newsBg")
        }
    }
    
}
