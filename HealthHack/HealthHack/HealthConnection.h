//
//  HealthConnection.h
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/9/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthConnection : NSObject <NSURLConnectionDelegate>

- (id)initWithRequest:(NSURLRequest *)req;
- (void)start;

@property (nonatomic, copy) void (^completionBlock)(id obj, NSError *err);

@end
