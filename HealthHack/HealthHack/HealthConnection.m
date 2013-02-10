//
//  HealthConnection.m
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/9/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import "HealthConnection.h"

// This is necessary to keep the OnTimeConnection around after the caller's
// frame goes out of scope.
static NSMutableArray *sharedConnectionList = nil;

@interface HealthConnection () {
    NSURLRequest *_request;
    NSURLConnection *_internalConnection;
    NSURLResponse *_response;
    NSMutableData *_container;
}

@end


@implementation HealthConnection

@synthesize completionBlock;

- (id)initWithRequest:(NSURLRequest *)req {
    self = [super init];
    if (self) {
        if (!req){
            [NSException raise:@"Request not provided"
                        format:@"Request needs to be provided for the connection"];
            return nil;
        }
        _request = req;
    }
    return self;
}


- (id)init {
    [NSException raise:@"Default init failed"
                format:@"Reason: init is not supported by %@", [self class]];
    return nil;
}


- (void)start {
    _container = [[NSMutableData alloc] init];
    _internalConnection = [[NSURLConnection alloc] initWithRequest:_request
                                                          delegate:self
                                                  startImmediately:YES];
    if (!sharedConnectionList){
        sharedConnectionList = [NSMutableArray array];
    }
    [sharedConnectionList addObject:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // Store the url response for the later use.
    _response = response;
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_container appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // By default we expect JSON response
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:_container
                                                             options:0
                                                               error:nil];
    NSInteger statusCode = ((NSHTTPURLResponse *)_response).statusCode;
    NSError *error = nil;
    if (statusCode != 200) {
        static NSString *errorDomain = @"http error";
        error = [NSError errorWithDomain:errorDomain
                                    code:statusCode
                                userInfo:nil];
    }
    if (self.completionBlock){
        self.completionBlock(jsonData, error);
    }
    [sharedConnectionList removeObject:self];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (self.completionBlock){
        self.completionBlock(nil, error);
    }
    [sharedConnectionList removeObject:self];
}

@end
