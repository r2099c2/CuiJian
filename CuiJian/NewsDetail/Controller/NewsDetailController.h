//
//  NewsDetailController.h
//  Cuijian
//
//  Created by Moonths on 16/1/27.
//  Copyright © 2016年 Moonths. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
@interface NewsDetailController : UITableViewController
@property (nonatomic, strong)NewsModel * Nmodel;
@property (nonatomic, strong)UIWebView * webView;
@property (nonatomic, strong)UIImageView * backImg;
@property (nonatomic, strong)UIImageView *bottomImage;
@end
