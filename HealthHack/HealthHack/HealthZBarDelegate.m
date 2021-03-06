//
//  HealthZBarDelegate.m
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/9/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import "HealthZBarDelegate.h"
#import "HealthFoodEssentialsStore.h"
#import "HealthConstants.h"

@interface HealthZBarDelegate () {
    __weak ZBarReaderViewController *_viewController;
    BOOL _scanningInProgress;
}

@end


@implementation HealthZBarDelegate

- (id)initWithController:(ZBarReaderViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
        _scanningInProgress = NO;
    }
    return self;
}


// Overriding the parent's designated initializer.
- (id)init {
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Not supported"
                                 userInfo:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (_scanningInProgress) {
        // Not to scan while previous scanning is in progress.
        NSLog(@"Scanning is in progress");
        return;
    }

    // ADD: get the decode results
    id<NSFastEnumeration> results =
        [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results) {
        // EXAMPLE: just grab the first barcode
        break;
    }

    NSString *barcodeData = symbol.data;
    NSLog(@"the bar code data is %@", barcodeData);

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    UIActivityIndicatorView *indicatorView =
        [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.center = _viewController.readerView.center;
    [_viewController.readerView addSubview:indicatorView];
    [indicatorView startAnimating];

    _viewController.tracksSymbols = NO;

    void (^completionHandler)(NSDictionary *productDict) = ^void(NSDictionary *productDict) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        if (productDict) {
            NSDictionary *userInfo = @{kNotificationKeyProductDict: productDict,
                                       kNotificationKeyViewControllerIndex: @(0)};
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameShowItem
                                                                object:nil
                                                              userInfo:userInfo];

        } else {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:nil
                                      message:@"Didn't find the scanned item"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [indicatorView stopAnimating];
            [indicatorView removeFromSuperview];
            _viewController.tracksSymbols = YES;
            _scanningInProgress = NO;
        });
    };
    _scanningInProgress = YES;
    [[HealthFoodEssentialsStore sharedStore] getLabel:barcodeData
                                    completionHandler:completionHandler];
}

@end
