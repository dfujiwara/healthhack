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
#import "HealthCollectionViewCell.h"


@implementation HealthProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Allergens";
        self.tabBarItem.image = [UIImage imageNamed:@"icon-allergies"];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    UINib *nib = [UINib nibWithNibName:kHealthCollectionViewCellNibName
                                bundle:nil];
    [_collectionView registerNib:nib
      forCellWithReuseIdentifier:kReuseableHealthCollectionViewCellIdentifier];
    
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

    HealthCollectionViewCell *cell =
        [_collectionView dequeueReusableCellWithReuseIdentifier:kReuseableHealthCollectionViewCellIdentifier
                                                   forIndexPath:indexPath];

    cell.allergenLabel.text = profileAllergenDict[kProductName];

    NSString *imageFileName = [NSString stringWithFormat:@"icon-%@",
                               [profileAllergenDict[kProductName] lowercaseString]];

    if ([profileAllergenDict[kProductValue] boolValue]) {
        cell.backgroundColor = [UIColor redColor];
        imageFileName = [NSString stringWithFormat:@"%@-selected", imageFileName];
    } else {
        cell.backgroundColor = [UIColor grayColor];
    }   

    cell.allergenImage.image = [UIImage imageNamed:imageFileName];
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
    BOOL currentValue = [profileAllergenDict[kProductValue] boolValue];

    profileAllergenDict[kProductValue] = @(!currentValue);
    
    [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

@end
