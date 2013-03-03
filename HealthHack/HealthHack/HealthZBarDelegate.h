//
//  HealthZBarDelegate.h
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/9/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBarSDK.h"

@interface HealthZBarDelegate : NSObject <ZBarReaderDelegate>

// Designated initializer.
- (id)initWithController:(ZBarReaderViewController *)viewController;

@end
