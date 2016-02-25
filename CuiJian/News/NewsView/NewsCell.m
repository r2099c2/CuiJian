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




-(void)setupViews
{
    self.cellBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newsBg"]];
    self.cellBackground.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.3];
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
    [self.newsTitle setFont:[UIFont systemFontOfSize:19]];
    self.newsTitle.numberOfLines = 0;
    self.newsTitle.textColor = [UIColor colorWithRed:136/255.0 green:131/255.0 blue:110/255.0 alpha:1];
    [self.contentView addSubview:self.newsTitle];
    
    self.newsTime = [[UILabel alloc]init];
    self.newsTime.textColor = [UIColor whiteColor];
    [self.newsTime setFont:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:self.newsTime];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.cellBackground.frame = CGRectMake(10, 0, CGRectGetWidth(self.bounds)-20, CGRectGetHeight(self.bounds));
    
    self.newsImg.frame = CGRectMake(20, 8, KscreenWidth/2.8, KscreenWidth/2.8);
    
    self.newsTitle.frame = CGRectMake(CGRectGetMaxX(self.newsImg.frame)+10, CGRectGetMinY(self.newsImg.frame) + 6, KscreenWidth/1.95, KscreenWidth/3.5);
    CGRect rect = [self.newsTitle.attributedText boundingRectWithSize:CGSizeMake(self.newsTitle.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:Nil];
    CGRect labelFrame = self.newsTitle.frame;
    labelFrame.size.height = rect.size.height;
    self.newsTitle.frame = labelFrame;
    
    self.newsTime.frame = CGRectMake(CGRectGetMinX(self.newsTitle.frame), CGRectGetMaxY(self.newsImg.frame) - 30, KscreenWidth/1.95, KscreenWidth/12);
    
}

- (void)bindModel:(News *)model
{
    //title
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.post_title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:9];//调整行间距
    [paragraphStyle setAlignment:NSTextAlignmentJustified];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.post_title length])];
    [attributedString addAttribute:NSFontAttributeName value:self.newsTitle.font range:NSMakeRange(0, [model.post_title length])];
    self.newsTitle.attributedText = attributedString;
    
    //新闻头像
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 8, KscreenWidth/2.8, KscreenWidth/2.8)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.feature_image] placeholderImage:[UIImage imageNamed:@"newsBg"]];
    [self addSubview:imageView];
    [self.newsImg removeFromSuperview];
    self.newsImg = nil;
    self.newsImg = imageView;
    
    
    //time
    self.newsTime.text = model.post_date;
    
}




@end
