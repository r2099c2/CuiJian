//
//  NewsCell.h
//  Cuijian
//
//  Created by Moonths on 16/1/26.
//  Copyright © 2016年 Moonths. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

@interface NewsCell : UICollectionViewCell
@property (nonatomic, strong)UIImageView * newsImg;
@property (nonatomic, strong)UILabel * newsTitle;
@property (nonatomic, strong)UILabel * newsDetail;
@property (nonatomic, strong)UILabel * newsTime;
@property (nonatomic, strong)UIImageView * cellBackground;

- (void)bindModel:(NewsModel *)model;



@end
