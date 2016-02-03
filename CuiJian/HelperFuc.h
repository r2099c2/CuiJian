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

@interface HelperFuc : NSObject

+ (void)bgParrallax: (UIView *)paraView maximumRelativeValue:(CGFloat)maximumRelativeValue;
+ (void)bgParrallax: (UIView *)paraView;

@end


#endif /* HelperFuc_h */
