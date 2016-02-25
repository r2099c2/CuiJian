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
        
        let maskView = UIView(frame: frame)
        maskView.frame.origin = CGPointZero
        maskView.backgroundColor = UIColor(red: 136.0/255.0, green: 131.0/255.0, blue: 109.0/255.0, alpha: 0.8)
        self.addSubview(maskView)
        
        self.titleLabel = UILabel(frame: CGRect(x: 32, y: 24, width: frame.width - 64, height: 48))
        self.titleLabel.textColor = UIColor.whiteColor()
        if #available(iOS 8.2, *) {
            self.titleLabel.font = UIFont.systemFontOfSize(36, weight: UIFontWeightLight)
        } else {
            self.titleLabel.font = UIFont.systemFontOfSize(32)
        }
        self.addSubview(self.titleLabel)
        
        self.contentLabel = UILabel(frame: CGRect(x: 32, y: 84, width: frame.width - 64, height: frame.height - 100))
        self.contentLabel.textColor = UIColor.whiteColor()
        self.contentLabel.numberOfLines = 0
        self.contentLabel.font = UIFont.systemFontOfSize(13)
        self.contentLabel.textAlignment = .Justified

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
        
        let attrText = NSMutableAttributedString(string: "\(news.post_content!)")
        let paragraphAttr = NSMutableParagraphStyle()
        paragraphAttr.lineSpacing = 6
        paragraphAttr.alignment = .Justified
        attrText.addAttribute(NSParagraphStyleAttributeName, value: paragraphAttr, range: NSRange(location: 0, length: news.post_content!.characters.count))
        attrText.addAttribute(NSFontAttributeName, value: self.contentLabel.font, range: NSRange(location: 0, length: news.post_content!.characters.count))
        self.contentLabel.attributedText = attrText

        let maxHeight : CGFloat = 10000
        let rect = self.contentLabel.attributedText?.boundingRectWithSize(CGSizeMake(self.contentLabel.frame.width, maxHeight),
            options: .UsesLineFragmentOrigin, context: nil)
        var frame = self.contentLabel.frame
        frame.size.height = rect!.size.height
        self.contentLabel.frame = frame
        
        if(news.feature_image != nil){
            self.imageView.sd_setImageWithURL(NSURL(string: news.feature_image as! String)!)
        }
        else{
            self.imageView.image = UIImage(named: "defaultAbout")
        }
    }
    
}
