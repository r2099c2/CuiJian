//
//  NewsCell.m
//  Cuijian
//
//  Created by Moonths on 16/1/26.
//  Copyright © 2016年 Moonths. All rights reserved.
//

#import "NewsCell.h"
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
    self.cellBackground.image = [UIImage imageNamed:@"newsBg"];
    [self.contentView addSubview:self.cellBackground];
    
    self.newsImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.newsImg];
    
    self.newsTitle = [[UILabel alloc]init];
    [self.newsTitle setFont:[UIFont systemFontOfSize:18]];
    self.newsTitle.textColor = [UIColor colorWithRed:187/255.0 green:177/255.0 blue:141/255.0 alpha:1];
    [self.contentView addSubview:self.newsTitle];
    
    self.newsDetail = [[UILabel alloc]init];
    [self.newsDetail setFont:[UIFont systemFontOfSize:14]];
    self.newsDetail.textColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1];
    [self.contentView addSubview:self.newsDetail];
    
    self.newsTime = [[UILabel alloc]init];
    [self.newsTime setFont:[UIFont systemFontOfSize:12]];
    self.newsTime.textColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1];
    [self.contentView addSubview:self.newsTime];
    
    


}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.cellBackground.frame = CGRectMake(10, 0, CGRectGetWidth(self.bounds)-20, CGRectGetHeight(self.bounds));
    
    self.newsImg.frame = CGRectMake(18, 8, KscreenWidth/2.8, KscreenWidth/2.8);
    
    self.newsTitle.frame = CGRectMake(CGRectGetMaxX(self.newsImg.frame)+10, CGRectGetMinY(self.newsImg.frame), KscreenWidth/1.9, KscreenWidth/12);
    
    self.newsDetail.frame = CGRectMake(CGRectGetMaxX(self.newsImg.frame)+10, CGRectGetMaxY(self.newsTitle.frame), KscreenWidth/1.9, KscreenWidth/4.8);
    
    self.newsTime.frame = CGRectMake(CGRectGetMinX(self.newsDetail.frame), CGRectGetMaxY(self.newsDetail.frame), KscreenWidth/1.9, KscreenWidth/16);
}
@end
