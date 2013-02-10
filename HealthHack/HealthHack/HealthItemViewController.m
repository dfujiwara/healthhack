//
//  HealthItemViewController.m
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/9/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import "HealthItemViewController.h"
#import "HealthConstants.h"
#import "HealthFoodEssentialsStore.h"
#import "HealthCollectionViewCell.h"

@interface HealthItemViewController () {
    NSDictionary *_itemDictionary;
    NSMutableArray *_allergenArray;
    NSMutableArray *_warningArray;
    NSArray *_allergenAlertArray;
}

- (void)dismiss:(id)sender;

@end

@implementation HealthItemViewController

- (id)initWithItemDictionary:(NSDictionary *)itemDictionary {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _itemDictionary = itemDictionary;
        self.navigationItem.title = _itemDictionary[kProductNameKey];
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                             target:self
                                                                             action:@selector(dismiss:)];
        self.navigationItem.rightBarButtonItem = bbi;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithItemDictionary:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    UINib *nib = [UINib nibWithNibName:kHealthCollectionViewCellNibName
                                bundle:nil];
    [_collectionView registerNib:nib
      forCellWithReuseIdentifier:kReuseableHealthCollectionViewCellIdentifier];
    
    NSDictionary *userAllergens = [[HealthFoodEssentialsStore sharedStore]
                                   userAllergens];

    _allergenArray = [NSMutableArray array];
    _warningArray = [NSMutableArray array];
    _allergenAlertArray = @[_warningArray, _allergenArray];

    NSUInteger maxAllergentIndicator = 0;
    for (NSDictionary *allergenDict in _itemDictionary[kProductAllergens]) {
        NSLog(@"Allergen is %@", allergenDict[kProductAllergenName]);
        NSString *allergentName = allergenDict[kProductAllergenName];
        if ([userAllergens[allergentName] boolValue]) {
            NSUInteger allergentValue = [allergenDict[kProductAllergenValue] unsignedIntegerValue];
            maxAllergentIndicator = MAX(maxAllergentIndicator, allergentValue);

            if (allergentValue > 0) {
                NSMutableSet *set = _allergenAlertArray[allergentValue - 1];
                [set addObject:allergentName];
            }
        }
    }

    switch(maxAllergentIndicator) {
        case 2:
            _indicatorView.backgroundColor = [UIColor redColor];
            _indicatorLabel.text = @"Sad Face";
            break;
        case 1:
            _indicatorView.backgroundColor = [UIColor yellowColor];
            _indicatorLabel.text = @"Confused Face";
            break;
        default:
            _indicatorView.backgroundColor = [UIColor greenColor];
            _indicatorLabel.text = @"Sad Face";
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    UIColor *backgroundColor = nil;
    NSString *allergenName = nil;
    if (indexPath.section == 0) {
        allergenName = _allergenArray[indexPath.row];
        backgroundColor = [UIColor redColor];
    } else {
        allergenName = _warningArray[indexPath.row];
        backgroundColor = [UIColor yellowColor];
    }

    HealthCollectionViewCell *cell =
    [_collectionView dequeueReusableCellWithReuseIdentifier:kReuseableHealthCollectionViewCellIdentifier
                                               forIndexPath:indexPath];
    cell.backgroundColor = backgroundColor;
    cell.allergenLabel.text = allergenName;

    return cell;
}


#pragma mark - collection flow layout delegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 80);
}

@end
