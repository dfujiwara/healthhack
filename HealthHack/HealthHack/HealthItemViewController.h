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

@property (weak, nonatomic) IBOutlet UIView *indicatorView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *indicatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

- (id)initWithItemDictionary:(NSDictionary *)itemDictionary;

- (IBAction)dismiss:(id)sender;

@end
