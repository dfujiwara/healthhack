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
    // Raise an exception here.
    return nil;
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

    UILabel *scanningLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                  _viewController.readerView.bounds.size.width - (2 * 10),
                                                  40)];
    scanningLabel.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
    scanningLabel.text = @"Scanning...";
    scanningLabel.textAlignment = NSTextAlignmentCenter;
    scanningLabel.textColor = [UIColor whiteColor];
    scanningLabel.center = _viewController.readerView.center;
    
    [_viewController.readerView addSubview:scanningLabel];
    _viewController.tracksSymbols = NO;

    void (^completionHandler)(NSDictionary *productDict) = ^void(NSDictionary *productDict) {
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
            [scanningLabel removeFromSuperview];
            _viewController.tracksSymbols = YES;
            _scanningInProgress = NO;
        });
    };
    _scanningInProgress = YES;
    [[HealthFoodEssentialsStore sharedStore] getLabel:barcodeData
                                    completionHandler:completionHandler];
}

@end
