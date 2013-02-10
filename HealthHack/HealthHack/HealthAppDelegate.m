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
#import "HealthZBarDelegate.h"

@interface HealthAppDelegate () {
    HealthZBarDelegate *_zbarDelegate;
}

- (ZBarReaderViewController *)setupBarReaderViewController;

@end


@implementation HealthAppDelegate

#pragma mark - private methods

- (ZBarReaderViewController *)setupBarReaderViewController {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];

    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    _zbarDelegate = [[HealthZBarDelegate alloc]
                     initWithCompletionHandler:nil];
    reader.readerDelegate = _zbarDelegate;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here

    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    return reader;
}


#pragma mark - public methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc]
                   initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    HealthItemListViewController *itemListViewController =
        [[HealthItemListViewController alloc] initWithNibName:nil bundle:nil];

    ZBarReaderViewController *reader = [self setupBarReaderViewController];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[reader, itemListViewController]];

    [self.window setRootViewController:tabBarController];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
