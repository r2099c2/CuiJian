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
    
    self.titleLabel = [[UILabel alloc]init];
    //self.titleLabel.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc]init];
    //self.timeLabel.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:self.timeLabel];
    
    self.lineLabel = [[UILabel alloc]init];
    self.lineLabel.backgroundColor = [UIColor colorWithRed:136/255.0 green:131/255.0 blue:110/255.0 alpha:1];
    [self.contentView addSubview:self.lineLabel];
    
    self.titleContent = [[UILabel alloc]init];
    self.titleContent.numberOfLines = 0;
    self.titleContent.lineBreakMode = NSLineBreakByWordWrapping;

    //self.titleContent.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:self.titleContent];
    

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleImg.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight/2.45);
    self.titleLabel.frame = CGRectMake(KscreenWidth/10, CGRectGetMaxY(self.titleImg.frame)/5*3.5, KscreenWidth-KscreenWidth/5, KscreenHeight/10);
    self.timeLabel.frame = CGRectMake(KscreenWidth/10, CGRectGetMaxY(self.titleImg.frame)+20, KscreenWidth, KscreenHeight/36.85);
    self.lineLabel.frame = CGRectMake(KscreenWidth/10, CGRectGetMaxY(self.timeLabel.frame)+20, KscreenWidth/18.42, 5);
       // CGSize size = [self.titleContent sizeThatFits:CGSizeMake(KscreenWidth, MAXFLOAT)];
//    self.titleContent.frame = CGRectMake(KscreenWidth/10, CGRectGetMaxY(self.lineLabel.frame)+20, KscreenWidth-KscreenWidth/5, size.height);
   // self.contentWebView.frame = CGRectMake(KscreenWidth/10, 0, KscreenWidth-KscreenWidth/5, 100);
    
}

+(CGFloat)cellHeight:(CGFloat)height
{
    return height + 10;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
