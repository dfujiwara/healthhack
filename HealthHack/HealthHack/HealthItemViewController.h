//
//  HealthItemViewController.h
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/9/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthItemViewController : UIViewController

@property (strong, nonatomic) UIView *indicatorView;

- (id)initWithItemDictionary:(NSDictionary *)itemDictionary;

@end
