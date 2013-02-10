//
//  HealthItemViewController.m
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/9/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import "HealthItemViewController.h"
#import "HealthConstants.h"

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
    // Do any additional setup after loading the view from its nib.
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
