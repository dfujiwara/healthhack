//
//  HealthItemViewController.h
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/9/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthItemViewController : UIViewController
    <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UIView *indicatorView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

- (id)initWithItemDictionary:(NSDictionary *)itemDictionary;

@end
