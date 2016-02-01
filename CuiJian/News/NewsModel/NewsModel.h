//
//  NewsModel.h
//  Cuijian
//
//  Created by Moonths on 16/1/26.
//  Copyright © 2016年 Moonths. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
@property (nonatomic, copy)NSString * feature_image;
@property (nonatomic, copy)NSString * ID;
@property (nonatomic, copy)NSString * post_content;
@property (nonatomic, copy)NSString * post_date;
@property (nonatomic, copy)NSString * post_modified;
@property (nonatomic, copy)NSString * post_title;
@property (nonatomic, copy)NSString * post_excerpt;
@end
