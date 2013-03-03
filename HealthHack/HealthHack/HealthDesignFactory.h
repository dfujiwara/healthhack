//
//  HealthDesignFactory.h
//  HealthHack
//
//  Created by Daisuke Fujiwara on 3/2/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kHealthColorSettingSelectedRedColor = 1,
    kHealthColorSettingSelectedGrayColor = 2
} HealthColorSetting;

@interface HealthDesignFactory : NSObject

+ (UIColor *)colorForSetting:(HealthColorSetting)setting;

@end
