//
//  HealthItemListViewController.h
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/9/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthItemListViewController : UIViewController
    <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *scannedItemListView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end
