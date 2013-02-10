//
//  HealthFoodEssentialsStore.h
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/9/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthFoodEssentialsStore : NSObject

@property (strong, nonatomic) NSMutableArray *scannedItems;

+ (HealthFoodEssentialsStore *)sharedStore;

- (void)createSession:(void (^)(NSString *sessiondId))completionHandler;

- (void)getProfile;
- (void)setProfile:(NSDictionary *)profileData;

- (void)getLabel:(NSString *)barcodeUPC;

@end
