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

@interface HealthItemViewController () {
    NSDictionary *_itemDictionary;
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
    _indicatorView.backgroundColor = [UIColor greenColor];

    NSDictionary *userAllergens = [[HealthFoodEssentialsStore sharedStore]
                                   userAllergens];

    NSMutableSet *allergentSet = [NSMutableSet set];
    NSMutableSet *warningSet = [NSMutableSet set];
    NSArray *allergentAlertArray = @[warningSet, allergentSet];

    NSUInteger maxAllergentIndicator = 0;
    for (NSDictionary *allergenDict in _itemDictionary[kProductAllergens]) {
        NSLog(@"Allergen is %@", allergenDict[kProductAllergenName]);
        NSString *allergentName = allergenDict[kProductAllergenName];
        if ([userAllergens[allergentName] boolValue]) {
            NSUInteger allergentValue = [allergenDict[kProductAllergenValue] unsignedIntegerValue];
            maxAllergentIndicator = MAX(maxAllergentIndicator, allergentValue);

            if (allergentValue > 0) {
                NSMutableSet *set = allergentAlertArray[allergentValue - 1];
                [set addObject:allergentName];
            }
        }
    }

    switch(maxAllergentIndicator) {
        case 2:
            _indicatorView.backgroundColor = [UIColor redColor];
            break;
        case 1:
            _indicatorView.backgroundColor = [UIColor yellowColor];
            break;
        default:
            _indicatorView.backgroundColor = [UIColor greenColor];
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

@end
