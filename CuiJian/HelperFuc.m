//
//  HelperFuc.m
//  CuiJian
//
//  Created by BriceZHOU on 2/3/16.
//  Copyright © 2016 Rick. All rights reserved.
//

#import "HelperFuc.h"

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
    
    [paraView addMotionEffect:group];
}

+(void) bgParrallax:(UIView *)paraView{
    [HelperFuc bgParrallax:paraView maximumRelativeValue:20];
}

@end