//
//  NewsDetailCell.h
//  Cuijian
//
//  Created by Moonths on 16/1/27.
//  Copyright © 2016年 Moonths. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailCell : UITableViewCell
@property (nonatomic, strong)UIImageView * titleImg;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * timeLabel;
@property (nonatomic, strong)UILabel * lineLabel;
@property (nonatomic, strong)UIImageView * titleBg;

//cell自适应高度
+(CGFloat)cellHeight:(CGFloat)height;
@end
