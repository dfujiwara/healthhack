//
//  HealthDesignFactory.m
//  HealthHack
//
//  Created by Daisuke Fujiwara on 3/2/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//
//  A class that has utility methods to create design specific configurations
//  e.g. fonts, color, etc.

#import "HealthDesignFactory.h"

@implementation HealthDesignFactory

+ (UIColor *)colorForSetting:(HealthColorSetting)setting {
    UIColor *color = nil;
    switch (setting) {
        case kHealthColorSettingSelectedRedColor:
            color = [UIColor colorWithRed:1.0
                                    green:0.8
                                     blue:0.8
                                    alpha:0.8];
            break;
        case kHealthColorSettingSelectedGrayColor:
            color = [UIColor colorWithWhite:0.9
                                      alpha:1.0];
            break;
        default:
            break;
    }
    return color;
}

@end
