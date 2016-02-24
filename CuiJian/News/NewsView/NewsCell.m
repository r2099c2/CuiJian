//
//  NewsCell.m
//  Cuijian
//
//  Created by Moonths on 16/1/26.
//  Copyright © 2016年 Moonths. All rights reserved.
//

#import "NewsCell.h"
#import "NewsModel.h"
#import "UIImageView+WebCache.h"
//引入头文件 对coredata进行操作
#import "CuiJian-swift.h"
#import "News.h"

#define KscreenHeight [[UIScreen mainScreen] bounds].size.height
#define KscreenWidth [[UIScreen mainScreen] bounds].size.width
@implementation NewsCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

-(void) prepareForReuse{
    self.newsTitle.text = @"";
    //detail
    self.newsDetail.text = @"";
    //time
    self.newsTime.text = @"";
    //新闻头像
    self.newsImg = nil;

}

//拦截frame 使cell四周留有空白
//- (void)setFrame:(CGRect)frame
//{
//    frame = CGRectMake(frame.origin.x - 10, frame.origin.y, frame.size.width , frame.size.height);
//    [super setFrame:frame];
//}


-(void)setupViews
{
    self.cellBackground = [[UIImageView alloc]init];
    self.cellBackground.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.1];
    [self.contentView addSubview:self.cellBackground];
    
    self.newsImg = [[UIImageView alloc]init];
    self.newsImg.contentMode = UIViewContentModeScaleAspectFill;
    self.newsImg.layer.masksToBounds = YES;
    //self.newsImg.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.newsImg];
    
    self.newsTitle = [[UILabel alloc]init];
    //self.newsTitle.backgroundColor = [UIColor orangeColor];


    [self.contentView addSubview:self.newsTitle];
    
    self.newsDetail = [[UILabel alloc]init];
    //self.newsDetail.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:self.newsDetail];
    
    self.newsTitle = [[UILabel alloc]init];
    //self.newsTitle.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.newsTitle];
    
    self.newsTime = [[UILabel alloc]init];
    // self.newsTime.backgroundColor = [UIColor cyanColor];
    [self.contentView addSubview:self.newsTime];

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.cellBackground.frame = CGRectMake(10, 0, CGRectGetWidth(self.bounds)-20, CGRectGetHeight(self.bounds));
    
    self.newsImg.frame = CGRectMake(20, 8, KscreenWidth/2.8, KscreenWidth/2.8);
    
    self.newsTitle.frame = CGRectMake(CGRectGetMaxX(self.newsImg.frame)+10, CGRectGetMinY(self.newsImg.frame), KscreenWidth/1.95, KscreenWidth/9);
    self.newsTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
    
    self.newsDetail.frame = CGRectMake(CGRectGetMaxX(self.newsImg.frame)+10, CGRectGetMaxY(self.newsTitle.frame), KscreenWidth/1.95, KscreenWidth/6);
    
    self.newsTime.frame = CGRectMake(CGRectGetMinX(self.newsDetail.frame), CGRectGetMaxY(self.newsDetail.frame), KscreenWidth/1.95, KscreenWidth/12);
    
}

- (void)bindModel:(NewsModel *)model
{
    //title
    self.newsTitle.textColor = [UIColor colorWithRed:136/255.0 green:131/255.0 blue:110/255.0 alpha:1];
    self.newsTitle.numberOfLines = 0;
    //cell.newsTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
    self.newsTitle.text = model.post_title;
    //detail
    self.newsDetail.numberOfLines = 0;
    self.newsDetail.font = [UIFont systemFontOfSize:15.0];
    self.newsDetail.textAlignment=NSTextAlignmentJustified;
    self.newsDetail.textColor = [UIColor whiteColor];
    self.newsDetail.text = model.post_excerpt;
    //time
    self.newsTime.textColor = [UIColor whiteColor];
    self.newsTime.text = model.post_date;
    //新闻头像
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.newsImg.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.feature_image] placeholderImage:[UIImage imageNamed:@"newsBg"]];
    [self.newsImg removeFromSuperview];
    self.newsImg = nil;
    self.newsImg = imageView;
    [self addSubview:self.newsImg];
}




@end
