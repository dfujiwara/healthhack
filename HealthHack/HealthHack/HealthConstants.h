//
//  HealthConstants.h
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/9/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>

// Dictionary keys.
extern NSString *kProductNameKey;
extern NSString *kProductUPCKey;
extern NSString *kProductAllergens;
extern NSString *kProductAllergenName;
extern NSString *kProductAllergenValue;
extern NSString *kProductName;
extern NSString *kProductValue;
extern NSString *kProductAllergic;
extern NSString *kProductAlleryScanResult;

// Notification names.
extern NSString *kNotificationNameShowItem;

// Notification info keys
extern NSString *kNotificationKeyProductDict;
extern NSString *kNotificationKeyViewControllerIndex;

// User default keys
extern NSString *kAllergenUserDefaultKey;
extern NSString *kScannedItemUserDefaultKey;

typedef enum {
    kScannedResultGood = 0,
    kScannedResultOk = 1,
    kScannedResultBad = 2

} kScannedResult;