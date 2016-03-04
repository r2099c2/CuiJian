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
                UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:@"网络异常"message:@"请请检查您的互联网状态。" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
                [unavailAlert show];
            });
            if (finished != NULL) {
                finished(NO, dataArray);
            }
            return ;
            
        }
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        for (NSDictionary * dict in dic) {
            NewsModel * m = [[NewsModel alloc]init];
            [m setValuesForKeysWithDictionary:dict];
            if (m.post_id == nil) {
                continue;
            }
            [dataArray addObject:m];
            AppDelegate * myDelegate = [[UIApplication sharedApplication]delegate];
            NSManagedObjectContext * context1 = myDelegate.managedObjectContext;
            
            NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"News"];
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"post_id==%@", m.post_id];
            [request setPredicate:predicate];
            NSArray * results = [context1 executeFetchRequest:request error:nil];
            
            for (NSManagedObject* result in results) {
                [context1 deleteObject:result];
            }
            
            @try {
                News * news = (News *)[NSEntityDescription insertNewObjectForEntityForName:@"News" inManagedObjectContext:context1];
                news.post_title = m.post_title;
                news.post_id = m.post_id;
                news.post_date = m.post_date;
                news.post_excerpt = m.post_excerpt;
                news.post_modified = m.post_modified;
                news.post_content = m.post_content;
                news.term_id = [NSNumber numberWithInt:type];
                news.feature_image = m.feature_image;
                NSError * error = nil;
                BOOL isSaveSuccess = [myDelegate.managedObjectContext save:&error];
                if (isSaveSuccess && error == nil) {
                }
                else {
                    NSLog(@"%@", error);
                }
            }
            @catch (NSException *exception) {
                [myDelegate.managedObjectContext rollback];
            }
            
            @finally {
                
            }        }
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
        AppDelegate * myDelegate = [[UIApplication sharedApplication]delegate];
        NSManagedObjectContext * context1 = myDelegate.managedObjectContext;
        NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"News"];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"term_id==%d", 2];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"post_date" ascending:NO];
        [request setPredicate:predicate];
        [request setSortDescriptors:@[sort]];
        NSArray * result = [context1 executeFetchRequest:request error:nil];
        finished(YES, result);
    }
}
+ (void)getAbout: (BOOL)needRefresh finished:(Completion) finished{
    if (needRefresh == YES) {
        [HelperFuc getDataFromNetWork:3 finished:finished];
    }
    else{
        AppDelegate * myDelegate = [[UIApplication sharedApplication]delegate];
        NSManagedObjectContext * context1 = myDelegate.managedObjectContext;
        NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"News"];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"term_id==%d", 3];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"post_date" ascending:YES];
        [request setPredicate:predicate];
        [request setSortDescriptors:@[sort]];
        NSArray * result = [context1 executeFetchRequest:request error:nil];
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


@end