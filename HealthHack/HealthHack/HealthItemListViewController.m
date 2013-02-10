//
//  HealthItemListViewController.m
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/9/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import "HealthItemListViewController.h"
#import "HealthFoodEssentialsStore.h"
#import "HealthItemViewController.h"
#import "HealthConstants.h"

@implementation HealthItemListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"List";
        self.tabBarItem.image = [UIImage imageNamed:@"icon-list"];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_scannedItemListView reloadData];

    if ([_scannedItemListView numberOfRowsInSection:0] == 0) {
        UILabel *tableFooterLabel = [[UILabel alloc]
                                     initWithFrame:CGRectMake(0, 0,
                                                              _scannedItemListView.bounds.size.width,
                                                              _scannedItemListView.bounds.size.height)];

        tableFooterLabel.text = @"NO SCANNED ITEMS";
        tableFooterLabel.textAlignment = NSTextAlignmentCenter;
        _scannedItemListView.tableFooterView = tableFooterLabel;
    } else {
        _scannedItemListView.tableFooterView = nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - table data source methods

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseableCellIdentifier = @"HealthItemListView";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:reuseableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:reuseableCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    NSDictionary *scannedItemDict =
        [HealthFoodEssentialsStore sharedStore].scannedItems[indexPath.row];
    cell.textLabel.text = scannedItemDict[kProductNameKey];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSInteger itemCount = [[HealthFoodEssentialsStore sharedStore].scannedItems count];
    return itemCount;
}


#pragma mark - table delegate methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *scannedItemDict =
        [HealthFoodEssentialsStore sharedStore].scannedItems[indexPath.row];
    HealthItemViewController *itemViewController =
        [[HealthItemViewController alloc] initWithItemDictionary:scannedItemDict];

    UINavigationController *navController =
        [[UINavigationController alloc] initWithRootViewController:itemViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
