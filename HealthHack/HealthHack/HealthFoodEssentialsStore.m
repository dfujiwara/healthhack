//
//  HealthFoodEssentialsStore.m
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/9/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import "HealthFoodEssentialsStore.h"
#import "HealthConnection.h"
#import "HealthConstants.h"

static NSString *const kApiId = @"79dgsyxjstnnbvgrsdqhsa8r";
static NSString *const kURLString = @"http://api.foodessentials.com";
static NSString *const kAppId = @"foodguard";

@interface HealthFoodEssentialsStore () {
    NSString *_sessionId;
    NSDictionary *_profile;
}

- (BOOL)hasScannedBefore:(NSDictionary *)scannedItemDict;

@end


@implementation HealthFoodEssentialsStore

+ (HealthFoodEssentialsStore *)sharedStore {
    static HealthFoodEssentialsStore *foodEssentialsStore = nil;
    if (!foodEssentialsStore){
        // set up the singleton instance
        foodEssentialsStore = [[HealthFoodEssentialsStore alloc] init];
        foodEssentialsStore.scannedItems = [NSMutableArray array];
    }
    return foodEssentialsStore;
}


- (void)createSession:(void (^)(NSString *sessiondId))completionHandler {
    static NSString *uid = @"foodguard_no_food_for_you";
    NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
    NSString *uuidString = [uuid UUIDString];

    NSString *queryParameterString =
        [NSString stringWithFormat:@"uid=%@&appid=%@&devid=%@&f=%@&v=%@&api_key=%@",
         uid, kAppId, uuidString, @"json", @"2.00", kApiId];

    NSString *urlString = [NSString stringWithFormat:@"%@/createsession?%@",
                           kURLString, queryParameterString];

    NSLog(@"createSession - %@", urlString);

    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    HealthConnection *connection = [[HealthConnection alloc]
                                    initWithRequest:request];

    void (^requestCompletionHandler)(NSDictionary *jsonResponse, NSError *error) =
        ^void(id jsonResponse, NSError *error){
            if (!error) {
                if (jsonResponse[@"session_id"]) {
                    _sessionId = jsonResponse[@"session_id"];
                    if (completionHandler) {
                        completionHandler(_sessionId);
                    }
                } else {
                    NSLog(@"Creating session didn't return session id: %@", error);
                }
            } else {
                NSLog(@"Creating session failed: %@", error);
            }
        };
    
    connection.completionBlock = requestCompletionHandler;
    [connection start];
}


- (void)getProfile {
    NSString *queryParameterString =
        [NSString stringWithFormat:@"sid=%@&f=%@", _sessionId, @"json"];

    NSString *urlString = [NSString stringWithFormat:@"%@/?%@",
                           kURLString, queryParameterString];

    NSLog(@"getProfile - %@", urlString);

    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    HealthConnection *connection = [[HealthConnection alloc]
                                    initWithRequest:request];
    connection.completionBlock = nil;
    [connection start];
}


- (void)setProfile:(NSDictionary *)profileData {
    NSString *queryParameterString =
    [NSString stringWithFormat:@"sid=%@&f=%@", _sessionId, @"json"];

    NSString *urlString = [NSString stringWithFormat:@"%@/?%@",
                           kURLString, queryParameterString];

    
    NSLog(@"setProfile - %@", urlString);

    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:profileData
                                                       options:0
                                                         error:nil];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];

    HealthConnection *connection = [[HealthConnection alloc]
                                    initWithRequest:request];
    connection.completionBlock = nil;
    [connection start];
}


- (void)getLabel:(NSString *)barcodeUPC {
    void (^getLabelHandler)(NSString *sessionId) = ^void(NSString *sessionId){
        NSString *queryParameterString =
        [NSString stringWithFormat:@"u=%@&sessid=%@&appid=%@&f=%@&api_key=%@",
         barcodeUPC, _sessionId, kAppId, @"json", kApiId];

        NSString *urlString = [NSString stringWithFormat:@"%@/label?%@",
                               kURLString, queryParameterString];

        NSLog(@"getLabel - %@", urlString);

        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

        HealthConnection *connection = [[HealthConnection alloc]
                                        initWithRequest:request];

        void (^requestCompletionHandler)(NSDictionary *jsonResponse,
                                         NSError *error) =
            ^void(NSDictionary *jsonResponse, NSError *error){
                if (!error) {
                    NSLog(@"Label is %@", jsonResponse);
                    NSString *productName = jsonResponse[@"product_name"];
                    NSDictionary *productDict = @{kProductNameKey: productName,
                                                  kProductUPCKey: barcodeUPC};
                    if (![self hasScannedBefore:productDict]) {
                        // Only add previously unscanned item.
                        [_scannedItems addObject:productDict];
                    }
                } else {
                    NSLog(@"Failed to get the label: %@", error);
                }
            };

        connection.completionBlock = requestCompletionHandler;
        [connection start];
    };

    if (_sessionId){
        getLabelHandler(_sessionId);
    } else {
        [self createSession:getLabelHandler];
    }
}


#pragma mark - private methods

- (BOOL)hasScannedBefore:(NSDictionary *)scannedItemDict {
    BOOL hasScannedBefore = NO;
    for (NSDictionary *productDict in _scannedItems) {
        if (productDict[kProductUPCKey] == scannedItemDict[kProductUPCKey]) {
            hasScannedBefore = YES;
            break;
        }
    }
    return hasScannedBefore;
}


@end
