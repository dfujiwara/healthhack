//
//  HealthItemListViewController.m
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/9/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import "HealthItemListViewController.h"
#import "HealthFoodEssentialsStore.h"

@implementation HealthItemListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"List";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_scannedItemListView reloadData];
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
    }

    NSDictionary *scannedItemDict =
        [HealthFoodEssentialsStore sharedStore].scannedItems[indexPath.row];
    cell.textLabel.text = scannedItemDict[kProductNameKey];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [[HealthFoodEssentialsStore sharedStore].scannedItems count];
}


#pragma mark - table delegate methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO: open up the detail view.

}

@end
