//
//  NewsDetailCell.m
//  Cuijian
//
//  Created by Moonths on 16/1/27.
//  Copyright © 2016年 Moonths. All rights reserved.
//

#import "NewsDetailCell.h"
#define KscreenHeight [[UIScreen mainScreen] bounds].size.height
#define KscreenWidth [[UIScreen mainScreen] bounds].size.width


@implementation NewsDetailCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupViews];
    }
    return self;
}

-(void)setupViews
{
    self.titleImg = [[UIImageView alloc]init];
    //self.titleImg.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.titleImg];
    
    self.titleBg = [[UIImageView alloc]init];
    self.titleBg.image = [UIImage imageNamed:@"titleBg"];
    
    //self.titleContent.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:self.titleBg];

    
    self.titleLabel = [[UILabel alloc]init];
    //self.titleLabel.backgroundColor = [UIColor orangeColor];
    self.titleLabel.textColor = [UIColor colorWithRed:136/255.0 green:131/255.0 blue:110/255.0 alpha:1];
    self.titleLabel.font = [UIFont systemFontOfSize:22];
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc]init];
    //self.timeLabel.backgroundColor = [UIColor yellowColor];
    
    self.timeLabel.textColor = [UIColor colorWithRed:136/255.0 green:131/255.0 blue:110/255.0 alpha:1];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.titleLabel];

    [self.contentView addSubview:self.timeLabel];
    
    self.lineLabel = [[UILabel alloc]init];
    self.lineLabel.backgroundColor = [UIColor colorWithRed:136/255.0 green:131/255.0 blue:110/255.0 alpha:1];
    [self.contentView addSubview:self.lineLabel];
    

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleImg.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight/2.45);
    self.titleBg.frame = CGRectMake(0, self.titleImg.frame.size.height / 2, KscreenWidth, self.titleImg.frame.size.height / 2);

    self.titleLabel.frame = CGRectMake(KscreenWidth/20, self.titleImg.frame.size.height - 10 - self.titleLabel.frame.size.height, KscreenWidth-KscreenWidth/10, self.titleLabel.frame.size.height);
    
    self.timeLabel.frame = CGRectMake(KscreenWidth/20, CGRectGetMaxY(self.titleImg.frame)+10, KscreenWidth, KscreenHeight/36.85);
    self.lineLabel.frame = CGRectMake(KscreenWidth/20, CGRectGetMaxY(self.timeLabel.frame)+20, 40, 2);
}

+(CGFloat)cellHeight:(CGFloat)height
{
    return height + 10;
}


- (void)awakeFromNib {
    // Initialization code
}

@end
