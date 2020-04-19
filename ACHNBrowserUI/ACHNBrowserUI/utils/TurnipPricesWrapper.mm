//
//  TurnipPricesWrapper.m
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/19/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

#import "TurnipPricesWrapper.h"
#include "TurnipPrices.h"

@implementation Day

- (id)initWithMorningPrice:(uint32_t)morning andAfternoonPrice:(uint32_t)afternoon
{
    self = [super init];
    if(self) {
        [self setMorningPrice:@(morning)];
        [self setAfternoonPrice:@(afternoon)];
    }
    
    return self;
}

@end

@implementation TurnipPricesWrapper

- (NSArray<Day *>*)calculateWithBasePrice:(NSNumber *)basePrice pattern:(NSNumber *)pattern seed:(NSNumber*)seed {
    TurnipPrices turnips = TurnipPrices();
    
    turnips.whatPattern = pattern.unsignedIntValue;
    turnips.rng.init(seed.unsignedIntValue);
    
    turnips.calculate();

    return @[
        [[Day alloc] initWithMorningPrice:turnips.basePrice andAfternoonPrice:0],
        [[Day alloc] initWithMorningPrice:turnips.sellPrices[2] andAfternoonPrice:turnips.sellPrices[3]],
        [[Day alloc] initWithMorningPrice:turnips.sellPrices[4] andAfternoonPrice:turnips.sellPrices[5]],
        [[Day alloc] initWithMorningPrice:turnips.sellPrices[6] andAfternoonPrice:turnips.sellPrices[7]],
        [[Day alloc] initWithMorningPrice:turnips.sellPrices[8] andAfternoonPrice:turnips.sellPrices[9]],
        [[Day alloc] initWithMorningPrice:turnips.sellPrices[10] andAfternoonPrice:turnips.sellPrices[11]],
        [[Day alloc] initWithMorningPrice:turnips.sellPrices[12] andAfternoonPrice:turnips.sellPrices[13]],
    ];
}

@end
