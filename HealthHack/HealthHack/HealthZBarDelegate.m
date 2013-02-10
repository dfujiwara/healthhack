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

@implementation HealthZBarDelegate


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
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

    void (^completionHandler)(NSDictionary *productDict) = ^void(NSDictionary *productDict) {
        NSDictionary *userInfo = @{kNotificationKeyProductDict: productDict,
                                   kNotificationKeyViewControllerIndex: @(0)};
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameShowItem
                                                            object:nil
                                                          userInfo:userInfo];
    };
    [[HealthFoodEssentialsStore sharedStore] getLabel:barcodeData
                                    completionHandler:completionHandler];
}

@end
