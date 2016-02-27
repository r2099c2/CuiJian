//
//  NewsDetailController.m
//  Cuijian
//
//  Created by Moonths on 16/1/27.
//  Copyright © 2016年 Moonths. All rights reserved.
//

#import "NewsDetailController.h"
#import "NewsDetailCell.h"
#import "UIImageView+WebCache.h"
#define KscreenHeight [[UIScreen mainScreen] bounds].size.height
#define KscreenWidth [[UIScreen mainScreen] bounds].size.width
@interface NewsDetailController ()<UIWebViewDelegate>

@end

@implementation NewsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置WebView
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 0)];
    _webView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
    
    //_webView.scalesPageToFit=YES;
    //webView背景透明
    _webView.backgroundColor = [UIColor clearColor];
    [self.webView setOpaque:NO];
    
    //预先加载url
    [self.webView loadHTMLString:self.Nmodel.post_content baseURL:nil];
    
    self.bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, KscreenHeight - 100, KscreenWidth, 100)];
    [self.bottomImage setImage:[UIImage imageNamed:@"titleBg"]];
    [self.bottomImage setContentMode:UIViewContentModeScaleToFill];
    self.bottomImage.layer.zPosition = 999;
    
    [self.view addSubview:self.bottomImage];
    
    [self.tableView setAllowsSelection:NO];

    //消除tableView头部的距离
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 54.0f)];
    
    //背景灰色图
    self.backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    self.backImg.image = [UIImage imageNamed:@"songBgImage"];
    [self.tableView setBackgroundView:self.backImg];
    
    //注册cell
    [self.tableView registerClass:[NewsDetailCell class] forCellReuseIdentifier:@"NewsDetailCell"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftAction:)];
    
    //把导航栏设置为透明（用透明图片代替导航栏）
    
    self.navigationItem.title = @"";
    
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    //去掉cell之间的线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//nav上的左按钮点击事件
-(void)leftAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NewsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsDetailCell" forIndexPath:indexPath];
        
        //cell透明
        cell.backgroundColor = [UIColor clearColor];
        //titleImg
        [cell.titleImg sd_setImageWithURL:[NSURL URLWithString:self.Nmodel.feature_image]];
        
        //title
        cell.titleLabel.numberOfLines = 0;
        cell.titleLabel.text = self.Nmodel.post_title;
        [cell.titleLabel sizeToFit];
        
        //timeLabel
        cell.timeLabel.text = self.Nmodel.post_date;
        return cell;
    }else{
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:_webView];
        }
        return cell;
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _bottomImage.transform = CGAffineTransformMakeTranslation(0, scrollView.contentOffset.y);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    if(indexPath.row == 1){
        /* 通过webview代理获取到内容高度后,将内容高度设置为cell的高 */
        return _webView.frame.size.height+1;
    }else{
        return KscreenHeight/2.45+KscreenHeight/10+KscreenHeight/36.85;
    }
}

#pragma mark - UIWebView Delegate Methods
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //获取到webview的高度
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
    [self.tableView reloadData];
}




@end
