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
    

    //消除tableView头部的距离
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    
    //背景灰色图
    self.backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    self.backImg.image = [UIImage imageNamed:@"songBgImage"];
    [self.tableView setBackgroundView:self.backImg];
    
    //注册cell
    [self.tableView registerClass:[NewsDetailCell class] forCellReuseIdentifier:@"NewsDetailCell"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftAction:)];
    
    //把导航栏设置为透明（用透明图片代替导航栏）
    
    self.navigationItem.title = @"新闻";
    
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
        cell.titleLabel.textColor = [UIColor colorWithRed:136/255.0 green:131/255.0 blue:110/255.0 alpha:1];
        cell.titleLabel.numberOfLines = 0;
        cell.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
        cell.titleLabel.text = self.Nmodel.post_title;
        
        //timeLabel
        cell.timeLabel.textColor = [UIColor colorWithRed:136/255.0 green:131/255.0 blue:110/255.0 alpha:1];
        cell.timeLabel.text = self.Nmodel.post_modified;
        
//        //titlecontent
//        cell.titleContent.textColor = [UIColor whiteColor];
//        //cell.titleContent.numberOfLines = 0;
//        cell.titleContent.lineBreakMode = NSLineBreakByWordWrapping;
//        cell.titleContent.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
        //[cell.titleContent sizeToFit];
        //cell.titleContent.text = self.Nmodel.post_excerpt;
        
        
        
        return cell;
    }else{
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:_webView];
            
            /* 忽略点击效果 */
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return cell;
        
    }

    
  
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    if(indexPath.row == 1){
        /* 通过webview代理获取到内容高度后,将内容高度设置为cell的高 */
        return _webView.frame.size.height+1;
    }else{
        //return KscreenHeight/1.5;
//        return [NewsDetailCell cellHeight:[self heightWithString:self.Nmodel.post_excerpt]];
        return KscreenHeight/2.45+KscreenHeight/10+KscreenHeight/36.85;
    }
}

#warning 暂时不用 取消
//DetailCell<1>自适应高度
-(CGFloat)heightWithString:(NSString *)aString
{
    CGRect r =[aString boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.tableView.frame)-10, 2000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil];
    return  r.size.height+10+KscreenHeight/2.45+KscreenHeight/10+KscreenHeight/36.85+30;
    
   
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle};
//    CGSize labelSize = [self.Nmodel.post_excerpt boundingRectWithSize:CGSizeMake(207, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//    
//    return labelSize.height+10+KscreenHeight/2.45+KscreenHeight/12.28+KscreenHeight/36.85+65;
    
}


#pragma mark - UIWebView Delegate Methods
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //获取到webview的高度
    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.webView.frame = CGRectMake(self.webView.frame.origin.x,self.webView.frame.origin.y, KscreenWidth-10, height+700);
    [self.tableView reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
