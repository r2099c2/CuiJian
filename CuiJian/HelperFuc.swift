//
//  HelperFuc.swift
//  CuiJian
//
//  Created by Rick on 16/1/29.
//  Copyright © 2016年 Rick. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

// BackGroundImageView Parallax
func bgParrallax(paraView: UIView) {
    // Set vertical effect
    let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
    verticalMotionEffect.minimumRelativeValue = -20
    verticalMotionEffect.maximumRelativeValue = 20
    
    // Set horizontal effect
    let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x",
        type: .TiltAlongHorizontalAxis)
    horizontalMotionEffect.minimumRelativeValue = -20
    horizontalMotionEffect.maximumRelativeValue = 20
    
    // Create group to combine both
    let group = UIMotionEffectGroup()
    group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
    
    // Add both effects to your view
    paraView.addMotionEffect(group)
}
