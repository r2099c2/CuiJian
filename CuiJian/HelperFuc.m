//
//  HelperFuc.m
//  CuiJian
//
//  Created by BriceZHOU on 2/3/16.
//  Copyright © 2016 Rick. All rights reserved.
//

#import "HelperFuc.h"
#import "CuiJian-swift.h"


@implementation HelperFuc

+(void) bgParrallax:(UIView *)paraView maximumRelativeValue:(CGFloat)maximumRelativeValue {
    
    UIInterpolatingMotionEffect* verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-maximumRelativeValue);
    verticalMotionEffect.maximumRelativeValue = @(maximumRelativeValue);
    
    UIInterpolatingMotionEffect* horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-maximumRelativeValue);
    horizontalMotionEffect.maximumRelativeValue = @(maximumRelativeValue);

    UIMotionEffectGroup* group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    
    for (UIMotionEffectGroup *motion in paraView.motionEffects) {
        [paraView removeMotionEffect:motion];
    }
    
    [paraView addMotionEffect:group];
}

+(void) bgParrallax:(UIView *)paraView{
    [HelperFuc bgParrallax:paraView maximumRelativeValue:20];
}

+(void)getDataFromNetWork:(int)type finished:(Completion) finished{
    NSURLSession * session = [NSURLSession sharedSession];
    NSURL * url = [NSURL URLWithString:[@"http://cuijian.logicdesign.cn/api.php?term_id=" stringByAppendingFormat:@"%d", type]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSMutableArray* dataArray = [NSMutableArray array];
        if (response == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:@"网络异常"message:@"请检查您的互联网状态。" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
                [unavailAlert show];
            });
            if (finished != NULL) {
                finished(NO, dataArray);
            }
            return ;
        }
        
        [HelperFuc writeJsonData:type jsonData:data];
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        for (NSDictionary * dict in dic) {
            NewsModel * m = [[NewsModel alloc]init];
            [m setValuesForKeysWithDictionary:dict];
            if (m.post_id == nil) {
                continue;
            }
            if (type == 2) {
                [dataArray addObject:m];
            }
            else{
                [dataArray insertObject:m atIndex:0];
            }
        }
        // 当数据处理完毕
        if (finished != NULL) {
            finished(YES, dataArray);
        }
    }];
    [task resume];

}

+ (void)getNews: (BOOL)needRefresh finished:(Completion) finished{
    if (needRefresh == YES) {
        [HelperFuc getDataFromNetWork:2 finished:finished];
    }
    else{
        NSArray * result = [HelperFuc readJsonData:2];
        finished(YES, result);
    }
}
+ (void)getAbout: (BOOL)needRefresh finished:(Completion) finished{
    if (needRefresh == YES) {
        [HelperFuc getDataFromNetWork:3 finished:finished];
    }
    else{
        NSArray * result = [HelperFuc readJsonData:3];
        finished(YES, result);
    }

}
+ (void) refreshData{
    [HelperFuc getDataFromNetWork:2 finished:^(BOOL finished, id data) {
        if (finished) {
            [HelperFuc getDataFromNetWork:3 finished:NULL];
        }
    }];
}

+ (void) writeJsonData: (int)fileType jsonData:(NSData*) jsonData{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"data%d.json", fileType]];
    [jsonData writeToFile:filePath atomically:YES];
}

+ (NSArray*) readJsonData: (int)fileType{
    NSMutableArray* dataArray = [NSMutableArray array];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"data%d.json", fileType]];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    if (data == nil || data.length == 0) {
        [HelperFuc refreshData];
        UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:@"网络异常" message:@"网络异常，请稍后再试。" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [unavailAlert show];
        return dataArray;
    }
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
    for (NSDictionary * dict in dic) {
        NewsModel * m = [[NewsModel alloc]init];
        [m setValuesForKeysWithDictionary:dict];
        if (m.post_id == nil) {
            continue;
        }
        if (fileType == 2) {
            [dataArray addObject:m];
        }
        else{
            [dataArray insertObject:m atIndex:0];
        }

    }

    return dataArray;
}


@end