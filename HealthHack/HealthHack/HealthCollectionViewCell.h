//
//  HealthCollectionViewCell.h
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/10/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *kReuseableHealthCollectionViewCellIdentifier;
extern NSString *kHealthCollectionViewCellNibName;

@interface HealthCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *allergenLabel;
@property (strong, nonatomic) IBOutlet UIImageView *allergenImage;

@end
