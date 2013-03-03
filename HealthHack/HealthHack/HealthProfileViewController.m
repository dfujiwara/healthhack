//
//  HealthProfileViewController.m
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/9/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import "HealthProfileViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "HealthFoodEssentialsStore.h"
#import "HealthConstants.h"
#import "HealthCollectionViewCell.h"
#import "HealthDesignFactory.h"


@implementation HealthProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Allergens";
        self.tabBarItem.image = [UIImage imageNamed:@"icon-allergies"];

        UINavigationItem *navigationItem = [self navigationItem];
        navigationItem.title = @"My Allergies";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    UINib *nib = [UINib nibWithNibName:kHealthCollectionViewCellNibName
                                bundle:nil];
    [_collectionView registerNib:nib
      forCellWithReuseIdentifier:kReuseableHealthCollectionViewCellIdentifier];

    _collectionView.backgroundColor = [UIColor grayColor];

    void (^completionHandler)(NSDictionary *profile) = ^void(NSDictionary *profile) {
        NSLog(@"Profile is %@", profile);
        [_collectionView reloadData];
    };
    [[HealthFoodEssentialsStore sharedStore] getProfile:completionHandler];
    
    _toolbar.userInteractionEnabled = NO;
}


#pragma mark - collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    NSDictionary *profile = [HealthFoodEssentialsStore sharedStore].userProfile;
    if (!profile || !profile[kProductAllergens]) {
        return 0;
    }
    return [profile[kProductAllergens] count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *profile = [HealthFoodEssentialsStore sharedStore].userProfile;
    NSDictionary *profileAllergenDict = profile[kProductAllergens][indexPath.row];

    HealthCollectionViewCell *cell =
        [_collectionView dequeueReusableCellWithReuseIdentifier:kReuseableHealthCollectionViewCellIdentifier
                                                   forIndexPath:indexPath];

    cell.allergenLabel.text = profileAllergenDict[kProductName];

    // Make sure to format the image name correctly by lower casing
    // and replacing any spaces with '-'.
    NSString *allergenName = [profileAllergenDict[kProductName] lowercaseString];
    allergenName = [allergenName stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSString *imageFileName = [NSString stringWithFormat:@"icon-%@", allergenName];

    if ([profileAllergenDict[kProductValue] boolValue]) {
        cell.contentView.backgroundColor =
            [HealthDesignFactory colorForSetting:kHealthColorSettingSelectedRedColor];
        imageFileName = [NSString stringWithFormat:@"%@-selected", imageFileName];
    } else {
        cell.contentView.backgroundColor =
            [HealthDesignFactory colorForSetting:kHealthColorSettingSelectedGrayColor];
    }   

    cell.allergenImage.image = [UIImage imageNamed:imageFileName];
    cell.layer.cornerRadius = 3;
    return cell;
}


#pragma mark - collection flow layout delegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(106, 90);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2.0, 0, 0, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}


- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *profile =
        [HealthFoodEssentialsStore sharedStore].userProfile;
    NSMutableArray *profileAllergens = profile[kProductAllergens];
    NSMutableDictionary *profileAllergenDict = profileAllergens[indexPath.row];
    BOOL currentValue = [profileAllergenDict[kProductValue] boolValue];
    profileAllergenDict[kProductValue] = @(!currentValue);

    [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

@end
