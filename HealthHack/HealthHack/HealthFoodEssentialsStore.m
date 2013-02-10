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
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionHandler(_sessionId);
                        });
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


- (void)getProfile:(void (^)(NSDictionary *profileDict))completionHandler {

    void (^getProfileHandler)(NSString *sessionId) = ^void(NSString *sessionId){
        NSString *queryParameterString =
        [NSString stringWithFormat:@"sid=%@&f=%@&api_key=%@",
         sessionId, @"json", kApiId];

        NSString *urlString = [NSString stringWithFormat:@"%@/getprofile?%@",
                               kURLString, queryParameterString];

        NSLog(@"getProfile - %@", urlString);

        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

        HealthConnection *connection = [[HealthConnection alloc]
                                        initWithRequest:request];


        void (^requestCompletionHandler)(NSMutableDictionary *jsonResponse,
                                         NSError *error) =
            ^void(NSMutableDictionary *jsonResponse, NSError *error){
                if (!error) {
                    NSLog(@"Profile is %@", jsonResponse);
                    _userProfile = jsonResponse;
                    if (completionHandler) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionHandler(_userProfile);
                        });
                    }
                } else {
                    NSLog(@"Failed to get the profile: %@", error);
                }
            };
        
        connection.completionBlock = requestCompletionHandler;
        [connection start];
    };

    if (_sessionId){
        getProfileHandler(_sessionId);
    } else {
        [self createSession:getProfileHandler];
    }
}


- (void)setProfile:(void (^)())completionHandler {
    void (^setProfileHandler)(NSString *sessionId) = ^void(NSString *sessionId){
        if (!_userProfile) {
            NSLog(@"User profile is not set");
            return;
        }
        NSString *queryParameterString =
            [NSString stringWithFormat:@"sid=%@&f=%@&api_key=%@",
             _sessionId, @"json", kApiId];

        NSString *urlString = [NSString stringWithFormat:@"%@/setprofile?%@",
                               kURLString, queryParameterString];


        NSLog(@"setProfile - %@", urlString);

        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:_userProfile
                                                           options:0
                                                             error:nil];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];

        HealthConnection *connection = [[HealthConnection alloc]
                                        initWithRequest:request];

        void (^requestCompletionHandler)(NSMutableDictionary *jsonResponse,
                                         NSError *error) =
            ^void(NSMutableDictionary *jsonResponse, NSError *error){
            if (!error) {
                if (completionHandler) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler();
                    });
                }
            } else {
                NSLog(@"Failed to set the profile: %@", error);
            }
        };
        connection.completionBlock = requestCompletionHandler;
        [connection start];
    };

    if (_sessionId){
        setProfileHandler(_sessionId);
    } else {
        [self createSession:setProfileHandler];
    }
}


- (void)getLabel:(NSString *)barcodeUPC
completionHandler:(void (^)(NSDictionary *productDict))completionHandler {
    
    void (^getLabelHandler)(NSDictionary *profile) = ^void(NSDictionary *profile){
        // At this point, we assume that the session id is valid.
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
                    NSString *productName = jsonResponse[kProductNameKey];
                    NSArray *productAllergens = jsonResponse[kProductAllergens];
                    NSDictionary *productDict = @{kProductNameKey: productName,
                                                  kProductUPCKey: barcodeUPC,
                                                  kProductAllergens:productAllergens};

                    if (![self hasScannedBefore:productDict]) {
                        // Only add previously unscanned item.
                        [_scannedItems addObject:productDict];
                    }

                    if (completionHandler) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionHandler(productDict);
                        });
                    }
                } else {
                    NSLog(@"Failed to get the label: %@", error);
                }
            };

        connection.completionBlock = requestCompletionHandler;
        [connection start];
    };

    if (_userProfile){
        getLabelHandler(_userProfile);
    } else {
        [self getProfile:getLabelHandler];
    }
}


- (NSDictionary *)userAllergens {
    if (!_userProfile) {
        return nil;
    }
    NSMutableDictionary *userAllergensDict = [NSMutableDictionary dictionary];
    NSMutableArray *userAllergens = _userProfile[kProductAllergens];

    for (NSDictionary *userAllergen in userAllergens) {
        userAllergensDict[userAllergen[kProductName]] = userAllergen[kProductValue];
    }
    return [userAllergensDict copy];
}

#pragma mark - private methods

- (BOOL)hasScannedBefore:(NSDictionary *)scannedItemDict {
    BOOL hasScannedBefore = NO;
    for (NSDictionary *productDict in _scannedItems) {
        if ([productDict[kProductUPCKey] isEqualToString:scannedItemDict[kProductUPCKey]]) {
            hasScannedBefore = YES;
            break;
        }
    }
    return hasScannedBefore;
}


@end
