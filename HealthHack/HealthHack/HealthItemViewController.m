//
//  HealthItemViewController.m
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/9/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import "HealthItemViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "HealthConstants.h"
#import "HealthFoodEssentialsStore.h"
#import "HealthCollectionViewCell.h"
#import "HealthCollectionHeaderView.h"

@interface HealthItemViewController () {
    NSMutableDictionary *_itemDictionary;
    NSMutableArray *_allergenArray;
    NSMutableArray *_warningArray;
    NSArray *_allergenAlertArray;
}

@end

@implementation HealthItemViewController

- (id)initWithItemDictionary:(NSMutableDictionary *)itemDictionary {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _itemDictionary = itemDictionary;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithItemDictionary:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    _productNameLabel.text = _itemDictionary[kProductNameKey];

    UINib *nib = [UINib nibWithNibName:kHealthCollectionViewCellNibName
                                bundle:nil];
    [_collectionView registerNib:nib
      forCellWithReuseIdentifier:kReuseableHealthCollectionViewCellIdentifier];

    nib = [UINib nibWithNibName:kHealthCollectionHeaderViewNibName
                         bundle:nil];

    [_collectionView registerNib:nib
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
             withReuseIdentifier:kReuseableHealthCollectionHeaderViewIdentifier];

    _collectionView.backgroundColor = [UIColor grayColor];

    NSDictionary *userAllergens = [[HealthFoodEssentialsStore sharedStore]
                                   userAllergens];

    _allergenArray = [NSMutableArray array];
    _warningArray = [NSMutableArray array];
    _allergenAlertArray = @[_warningArray, _allergenArray];

    NSUInteger maxAllergentIndicator = 0;
    for (NSDictionary *allergenDict in _itemDictionary[kProductAllergens]) {
        NSLog(@"Allergen is %@", allergenDict[kProductAllergenName]);
        NSString *allergenName = allergenDict[kProductAllergenName];
        NSUInteger allergenValue = [allergenDict[kProductAllergenValue]
                                     unsignedIntegerValue];

        if (allergenValue > 0) {
            NSMutableArray *array = _allergenAlertArray[allergenValue - 1];
            NSMutableDictionary *allergenDataDict = [NSMutableDictionary dictionary];
            allergenDataDict[kProductAllergenName] = allergenName;

            if ([userAllergens[allergenName] boolValue]){
                maxAllergentIndicator = MAX(maxAllergentIndicator, allergenValue);
                allergenDataDict[kProductAllergic] = @(YES);
            } else {
                allergenDataDict[kProductAllergic] = @(NO);
            }

            [array addObject:allergenDataDict];
        }
    }

    switch(maxAllergentIndicator) {
        case 2:
            _indicatorView.backgroundColor = [UIColor redColor];
            _indicatorLabel.text = @"Sad Face";
            _itemDictionary[kProductAlleryScanResult] = @(kScannedResultBad);
            break;
        case 1:
            _indicatorView.backgroundColor = [UIColor yellowColor];
            _indicatorLabel.text = @"Confused Face";
            _itemDictionary[kProductAlleryScanResult] = @(kScannedResultOk);
            break;
        default:
            _indicatorView.backgroundColor = [UIColor greenColor];
            _indicatorLabel.text = @"Happy Face";
            _itemDictionary[kProductAlleryScanResult] = @(kScannedResultGood);
            break;
    }
}


#pragma mark - private methods

- (void)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (section == 0) {
        count = [_allergenArray count];
    } else {
        count = [_warningArray count];
    }
    return count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSArray *array = nil;
    if (indexPath.section == 0) {
        array = _allergenArray;
    } else {
        array = _warningArray;
    }

    HealthCollectionViewCell *cell =
    [_collectionView dequeueReusableCellWithReuseIdentifier:kReuseableHealthCollectionViewCellIdentifier
                                               forIndexPath:indexPath];

    NSDictionary *dict = array[indexPath.row];

    // Make sure to format the image name correctly by lower casing
    // and replacing any spaces with '-'.
    NSString *allergenName = [dict[kProductAllergenName] lowercaseString];
    allergenName = [allergenName stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSString *imageFileName = [NSString stringWithFormat:@"icon-%@", allergenName];

    if ([dict[kProductAllergic] boolValue]) {
        imageFileName = [NSString stringWithFormat:@"%@-selected", imageFileName];
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell.backgroundColor = [UIColor lightGrayColor];
    }

    cell.allergenLabel.text = allergenName;
    cell.allergenImage.image = [UIImage imageNamed:imageFileName];
    cell.layer.cornerRadius = 3;
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        HealthCollectionHeaderView * headerView =
        [_collectionView
         dequeueReusableSupplementaryViewOfKind:kind
         withReuseIdentifier:kReuseableHealthCollectionHeaderViewIdentifier
         forIndexPath:indexPath];

        if (indexPath.section == 0) {
            headerView.headerLabel.text = @"Contains";
        } else {
            headerView.headerLabel.text = @"Might Contain";
        }
        reusableView = headerView;
    }
    return reusableView;
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
    return UIEdgeInsetsMake(2, 0, 2, 0);
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


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.bounds.size.width, 20.0);
}

@end
