//
//  HelperFuc.h
//  CuiJian
//
//  Created by BriceZHOU on 2/3/16.
//  Copyright © 2016 Rick. All rights reserved.
//

#ifndef HelperFuc_h
#define HelperFuc_h

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIKit.h>
#import "NewsModel.h"

typedef void(^Completion)(BOOL, id);

@interface HelperFuc : NSObject

+ (void)bgParrallax: (UIView *)paraView maximumRelativeValue:(CGFloat)maximumRelativeValue;
+ (void)bgParrallax: (UIView *)paraView;

+ (void)getNews: (BOOL)needRefresh finished:(Completion)finished;
+ (void)getAbout: (BOOL)needRefresh finished:(Completion) finished;
+ (void) refreshData;

@end


#endif /* HelperFuc_h */
