//
//  HealthCollectionHeaderView.h
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/24/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kHealthCollectionHeaderViewNibName;
extern NSString *const kReuseableHealthCollectionHeaderViewIdentifier;

@interface HealthCollectionHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@end
