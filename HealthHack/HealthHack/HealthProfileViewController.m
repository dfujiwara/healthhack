//
//  HealthProfileViewController.m
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/9/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import "HealthProfileViewController.h"
#import "HealthFoodEssentialsStore.h"
#import "HealthConstants.h"

static NSString *reuseableCellIdentifier = @"HealthProfileView";

@implementation HealthProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Allergens";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [_collectionView registerClass:[UICollectionViewCell class]
        forCellWithReuseIdentifier:reuseableCellIdentifier];
    
    void (^completionHandler)(NSDictionary *profile) = ^void(NSDictionary *profile) {
        NSLog(@"Profile is %@", profile);
        [_collectionView reloadData];
    };
    [[HealthFoodEssentialsStore sharedStore] getProfile:completionHandler];
}


- (void)viewWillDisappear:(BOOL)animated {
    [[HealthFoodEssentialsStore sharedStore] setProfile:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    UICollectionViewCell *cell =
        [_collectionView dequeueReusableCellWithReuseIdentifier:reuseableCellIdentifier
                                                   forIndexPath:indexPath];
    if ([profileAllergenDict[kProductAllergenValue] boolValue]) {
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell.backgroundColor = [UIColor grayColor];
    }
    return cell;
}


#pragma mark - collection flow layout delegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 80);
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *profile =
        [HealthFoodEssentialsStore sharedStore].userProfile;

    NSMutableArray *profileAllergens = profile[kProductAllergens];
    
    NSMutableDictionary *profileAllergenDict = profileAllergens[indexPath.row];
    BOOL currentValue = [profileAllergenDict[kProductAllergenValue] boolValue];

    profileAllergenDict[kProductAllergenValue] = @(!currentValue);
    
    [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

@end
