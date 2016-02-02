//
//  NewsViewController.m
//  Cuijian
//
//  Created by Moonths on 16/1/26.
//  Copyright © 2016年 Moonths. All rights reserved.
//

#import "NewsViewController.h"
#import "VVSpringCollectionViewFlowLayout.h"
#import "NewsModel.h"
#import "NewsCell.h"
#import "UIImageView+WebCache.h"
#import "NewsDetailController.h"
#define KscreenHeight [[UIScreen mainScreen] bounds].size.height
#define KscreenWidth [[UIScreen mainScreen] bounds].size.width
@interface NewsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) VVSpringCollectionViewFlowLayout *layout;
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)UICollectionView * collectionView;
@end

//static NSString *reuseId = @"collectionViewCellReuseId";

@implementation NewsViewController

//懒加载数据数组
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self makeData];
    
    //nav上的左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftAction:)];

    self.navigationItem.title = @"新闻";
    
    //添加背景的星空图
    self.starBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    self.starBackground.image = [UIImage imageNamed:@"star"];
    [self.view addSubview:self.starBackground];
    
    
    self.layout = [[VVSpringCollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    //向下偏移64使navigationbar显出来
    self.collectionView.contentInset = UIEdgeInsetsMake(74, 0, 10, 0);
    //注册cell
    [self.collectionView registerClass:[NewsCell class] forCellWithReuseIdentifier:@"Cell"];

    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    //self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    //self.navigationController!.navigationBar.shadowImage = UIImage()
    [self.navigationController.navigationBar setBackgroundImage:NULL forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:true];
    
}

//解析数据
-(void)makeData
{
    NSURLSession * session = [NSURLSession sharedSession];
    NSURL * url = [NSURL URLWithString:@"http://cuijian.logicdesign.cn/api.php?term_id=2"];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       // NSLog(@"AAA");
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        self.dataArray = [NSMutableArray array];
        for (NSDictionary * dict in dic) {
            //NSLog(@"BBB");
            NewsModel * m = [[NewsModel alloc]init];
            [m setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:m];

        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // NSLog(@"CCC");
            [self.collectionView reloadData];
            //[(VVSpringCollectionViewFlowLayout *)self.collectionView.collectionViewLayout resetLayout];
            //[self.collectionView layoutIfNeeded];
            //[self.collectionView reloadData];

        });

    }];
    [task resume];
}


//nav上的左按钮点击事件
-(void)leftAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //#warning Incomplete implementation, return the number of sections
    //NSLog(@"Get sections");
    return 1;

   
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //NSLog(@"Get items per section");
    return self.dataArray.count;

    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"Populating data");
    NewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
   // NSLog(@"Cell get");

    if (_dataArray && _dataArray.count > 0) {
        NewsModel *data = self.dataArray[indexPath.row];
        if (data) {
            //title
            cell.newsTitle.numberOfLines = 0;
            cell.newsTitle.text = data.post_title;
            //detail
            cell.newsDetail.numberOfLines = 0;
            cell.newsDetail.textAlignment=NSTextAlignmentLeft;
            cell.newsDetail.text = data.post_excerpt;
            //time
            cell.newsTime.text = data.post_date;
            //新闻头像
            [cell.newsImg sd_setImageWithURL:[NSURL URLWithString:data.feature_image]];
        }
    }
    
    return cell;
}
//设置cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, KscreenWidth/2.5);

}

//推出详情界面
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewsDetailController * dVC = [[NewsDetailController alloc]initWithStyle:(UITableViewStyleGrouped)];
    dVC.Nmodel = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:dVC animated:YES];
}



@end
