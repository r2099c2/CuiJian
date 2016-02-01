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
    self.cellBackground.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.1];
    [self.contentView addSubview:self.cellBackground];
    
    self.newsImg = [[UIImageView alloc]init];
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
    
    self.newsImg.frame = CGRectMake(10, 8, KscreenWidth/2.8, KscreenWidth/2.8);
    
    self.newsTitle.frame = CGRectMake(CGRectGetMaxX(self.newsImg.frame)+10, CGRectGetMinY(self.newsImg.frame), KscreenWidth/1.9, KscreenWidth/9);
    
    self.newsDetail.frame = CGRectMake(CGRectGetMaxX(self.newsImg.frame)+10, CGRectGetMaxY(self.newsTitle.frame), KscreenWidth/1.9, KscreenWidth/6);
    
    self.newsTime.frame = CGRectMake(CGRectGetMinX(self.newsDetail.frame), CGRectGetMaxY(self.newsDetail.frame), KscreenWidth/1.9, KscreenWidth/12);
}
@end
