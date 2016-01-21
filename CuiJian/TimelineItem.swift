//
//  TimelineItem.swift
//  CuiJian
//
//  Created by Rick on 16/1/18.
//  Copyright © 2016年 Rick. All rights reserved.
//

import UIKit

class TimelineItem: UIView {

    
//     Only override drawRect: if you perform custom drawing.
//     An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect) {
//        
//    }
//    func loadContentView() {
//        let contentNib = UINib(nibName: "TimelineItem", bundle: nil)
//        
//        if let contentView = contentNib.instantiateWithOwner(self, options: nil).first as? UIView
//        {
//            self.addSubview(contentView)
//            
//            //  We could use autoresizing or manually setting some constraints here for the content view
//            contentView.translatesAutoresizingMaskIntoConstraints = true
//            contentView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
//            contentView.frame = self.bounds
//        }
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        loadContentView()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        loadContentView()
//    }
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var content: UITextView!
    
}
