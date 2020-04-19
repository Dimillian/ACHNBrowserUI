//
//  TurnipPricesWrapper.m
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/19/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

#import "TurnipPricesWrapper.h"
#include "TurnipPrices.h"

@implementation TurnipPricesWrapper

- (void)calculate:(NSNumber *)pattern {
    TurnipPrices turnips = TurnipPrices();
    turnips.whatPattern = pattern.unsignedIntValue;

    turnips.calculate();
    printf("Pattern %d:\n", turnips.whatPattern);
    printf("Sun  Mon  Tue  Wed  Thu  Fri  Sat\n");
    printf("%3d  %3d  %3d  %3d  %3d  %3d  %3d\n",
           turnips.basePrice,
           turnips.sellPrices[2], turnips.sellPrices[4], turnips.sellPrices[6],
           turnips.sellPrices[8], turnips.sellPrices[10], turnips.sellPrices[12]);
    printf("     %3d  %3d  %3d  %3d  %3d  %3d\n",
           turnips.sellPrices[3], turnips.sellPrices[5], turnips.sellPrices[7],
           turnips.sellPrices[9], turnips.sellPrices[11], turnips.sellPrices[13]);
}

@end
