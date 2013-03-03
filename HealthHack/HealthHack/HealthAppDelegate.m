//
//  HealthAppDelegate.m
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/9/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import "HealthAppDelegate.h"

#import "ZBarSDK.h"

#import "HealthItemListViewController.h"
#import "HealthItemViewController.h"
#import "HealthConstants.h"
#import "HealthZBarDelegate.h"
#import "HealthFoodEssentialsStore.h"
#import "HealthProfileViewController.h"

@interface HealthAppDelegate () {
    HealthZBarDelegate *_zbarDelegate;
    UITabBarController *_tabBarController;
}

- (ZBarReaderViewController *)setupBarReaderViewController;

- (void)registerNotification;

@end


@implementation HealthAppDelegate

#pragma mark - private methods

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter]
     addObserverForName:kNotificationNameShowItem
     object:nil
     queue:[NSOperationQueue mainQueue]
     usingBlock:^void(NSNotification *notification) {

         NSDictionary *productDict = notification.userInfo[kNotificationKeyProductDict];
         NSInteger viewControllerIndex =
            [notification.userInfo[kNotificationKeyViewControllerIndex] integerValue];

         HealthItemViewController *itemViewController =
            [[HealthItemViewController alloc] initWithItemDictionary:productDict];

         UIViewController *vc = _tabBarController.viewControllers[viewControllerIndex];
         [vc presentViewController:itemViewController animated:YES completion:nil];
     }];
}


- (ZBarReaderViewController *)setupBarReaderViewController {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];

    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    _zbarDelegate = [[HealthZBarDelegate alloc] initWithController:reader];
    reader.readerDelegate = _zbarDelegate;
    ZBarImageScanner *scanner = reader.scanner;

    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];

    [scanner setSymbology:ZBAR_UPCA
                   config:ZBAR_CFG_ENABLE
                       to:1];

    reader.showsZBarControls = NO;
    reader.tabBarItem.title = @"Scan";
    reader.tabBarItem.image = [UIImage imageNamed:@"icon-scan"];

    // To show the status bar.
    reader.wantsFullScreenLayout = NO;

    UIToolbar *toolbar = [[UIToolbar alloc]
                          initWithFrame:CGRectMake(0, -1,
                                                   reader.view.bounds.size.width,
                                                   44)];
    UIBarButtonItem *flexibleBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                      target:nil
                                                      action:nil];

    UIBarButtonItem *titleBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Scan Barcode"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    toolbar.items = @[flexibleBarButtonItem, titleBarButtonItem, flexibleBarButtonItem];
    toolbar.tintColor = [UIColor redColor];
    toolbar.userInteractionEnabled = NO;
    [reader.view addSubview:toolbar];
    return reader;
}


#pragma mark - public methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc]
                   initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    ZBarReaderViewController *reader = [self setupBarReaderViewController];

    HealthItemListViewController *itemListViewController =
        [[HealthItemListViewController alloc] initWithNibName:nil bundle:nil];

    HealthProfileViewController *profileViewController =
        [[HealthProfileViewController alloc] initWithNibName:nil bundle:nil];

    _tabBarController = [[UITabBarController alloc] init];
    [_tabBarController setViewControllers:@[reader,
                                            itemListViewController,
                                            profileViewController]];

    [self.window setRootViewController:_tabBarController];

    [self registerNotification];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

@end
