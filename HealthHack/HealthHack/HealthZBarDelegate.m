//
//  HealthZBarDelegate.m
//  HealthHack
//
//  Created by Daisuke Fujiwara on 2/9/13.
//  Copyright (c) 2013 dfujiwara. All rights reserved.
//

#import "HealthZBarDelegate.h"

@interface HealthZBarDelegate () {
    void (^_handler)(NSString *barcodeData);
}

@end

@implementation HealthZBarDelegate

-(id)initWithCompletionHandler:(void (^)(NSString *))handler {
    self = [super init];
    if (self) {
        _handler = handler;
    }
    return self;
}


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
    if (_handler) {
        _handler(barcodeData);
    }
}

@end
