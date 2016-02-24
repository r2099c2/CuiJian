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
//#import "MJRefresh.h"
#import "HelperFuc.h"

#define KscreenHeight [[UIScreen mainScreen] bounds].size.height
#define KscreenWidth [[UIScreen mainScreen] bounds].size.width
@interface NewsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) VVSpringCollectionViewFlowLayout *layout;
@property (nonatomic, strong)NSArray * dataArray;
@property (nonatomic, strong)UICollectionView * collectionView;


@end

//static NSString *reuseId = @"collectionViewCellReuseId";

@implementation NewsViewController

////懒加载数据数组
//- (NSMutableArray *)dataArray
//{
//    if (_dataArray == nil) {
//        self.dataArray = [NSMutableArray array];
//    }
//    return _dataArray;
//}




- (void)viewDidLoad
{
    [super viewDidLoad];


    [HelperFuc getNews:NO finished:^(BOOL finished, id results) {
        self.dataArray = results;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLoadData) name:@"finishData" object:nil];
    
    
    
    //nav上的左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftAction:)];

    self.navigationItem.title = @"新闻";
    
    //添加背景的星空图
    self.starBackground = [[UIImageView alloc]initWithFrame:CGRectMake(-15, -15, KscreenWidth + 30, KscreenHeight + 30)];
    [HelperFuc bgParrallax:self.starBackground];
    self.starBackground.image = [UIImage imageNamed:@"star"];
    [self.view addSubview:self.starBackground];
    
    
    self.layout = [[VVSpringCollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
    //向下偏移64使navigationbar显出来
    self.collectionView.contentInset = UIEdgeInsetsMake(74, 0, 10, 0);
    //注册cell
    [self.collectionView registerClass:[NewsCell class] forCellWithReuseIdentifier:@"Cell"];

    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.navigationController.navigationBar setBackgroundImage:NULL forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:true];
    
    //MJRefresh
    //self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
    //    [self.collectionView.mj_header endRefreshing];
        
    //}];
    //[self.collectionView.mj_header beginRefreshing];
    
    
}

//通知中心实现刷新页面
- (void)finishLoadData
{
    [self.collectionView reloadData];
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
    //return self.dataArray.count;
    return self.dataArray.count;

    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"Populating data");
    NewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
   // NSLog(@"Cell get");
/*
//    if (_dataArray && _dataArray.count > 0) {
//        NewsModel *data = self.dataArray[indexPath.row];
//        if (data) {
//            [cell bindModel:[[DataHelper defaultDataHelper] modelWithIndex:indexPath.row]];
//        }
//    }
 */ 
    [cell bindModel:self.dataArray[indexPath.item]];
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
    dVC.Nmodel = self.dataArray[indexPath.item];
    [self.navigationController pushViewController:dVC animated:YES];
}



@end
