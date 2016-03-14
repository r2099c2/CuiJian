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
    [self.contentView addSubview:self.newsImg];
    
    self.newsTitle = [[UILabel alloc]init];
    [self.contentView addSubview:self.newsTitle];
    
    self.newsDetail = [[UILabel alloc]init];
    self.newsDetail.numberOfLines = 0;
    self.newsDetail.textColor = [UIColor colorWithRed:136/255.0 green:131/255.0 blue:109/255.0 alpha:1];
    [self.contentView addSubview:self.newsDetail];
    
    self.newsTitle = [[UILabel alloc]init];
    self.newsTitle.numberOfLines = 0;
    self.newsTitle.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.newsTitle];
    
    self.newsTime = [[UILabel alloc]init];
    self.newsTime.textColor = [UIColor colorWithRed:136/255.0 green:131/255.0 blue:109/255.0 alpha:1];
    [self.newsTime setFont:[UIFont systemFontOfSize:11]];
    [self.contentView addSubview:self.newsTime];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.cellBackground.frame = CGRectMake(10, 0, CGRectGetWidth(self.bounds)-20, CGRectGetHeight(self.bounds));
    
    self.newsImg.frame = CGRectMake(20, 8, KscreenWidth/2.8, KscreenWidth/2.8);
    
    self.newsTitle.frame = CGRectMake(CGRectGetMaxX(self.newsImg.frame)+10, CGRectGetMinY(self.newsImg.frame) + 6, KscreenWidth/1.95, KscreenWidth/5);
    
    CGRect rect = [self.newsTitle.attributedText boundingRectWithSize:CGSizeMake(self.newsTitle.frame.size.width, KscreenWidth/5) options:NSStringDrawingUsesLineFragmentOrigin context:Nil];
    CGRect labelFrame = self.newsTitle.frame;
    labelFrame.size.height = fmin(rect.size.height, KscreenWidth/5);
    self.newsTitle.frame = labelFrame;
    self.newsTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.newsTime.frame = CGRectMake(CGRectGetMinX(self.newsTitle.frame), CGRectGetMaxY(self.newsImg.frame) - 18, KscreenWidth/1.95, 18);
    
    double hei = KscreenWidth/2.8 - labelFrame.size.height - 38;
    self.newsDetail.frame = CGRectMake(CGRectGetMaxX(self.newsImg.frame)+10, CGRectGetMaxY(self.newsTitle.frame) + 10, KscreenWidth/1.95, hei);
    CGRect rect1 = [self.newsDetail.attributedText boundingRectWithSize:CGSizeMake(self.newsDetail.frame.size.width, hei) options:NSStringDrawingUsesLineFragmentOrigin context:Nil];
    CGRect labelFrame1 = self.newsDetail.frame;
    labelFrame1.size.height = fmin(rect1.size.height, hei);
    self.newsDetail.frame = labelFrame1;
    self.newsDetail.lineBreakMode = NSLineBreakByTruncatingTail;
    
}

- (void)bindModel:(NewsModel *)model
{
    //title
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.post_title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];//调整行间距
    [paragraphStyle setAlignment:NSTextAlignmentJustified];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.post_title length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, [model.post_title length])];
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
    
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:model.post_excerpt];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:4];//调整行间距
    [paragraphStyle1 setAlignment:NSTextAlignmentJustified];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [model.post_excerpt length])];
    [attributedString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, [model.post_excerpt length])];
    self.newsDetail.attributedText = attributedString1;
    
    //time
    self.newsTime.text = model.post_date;
    
}




@end
