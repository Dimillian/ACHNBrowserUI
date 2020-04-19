//
//  TurnipPricesWrapper.h
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/19/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Day : NSObject

@property(assign) NSNumber *morningPrice;
@property(assign) NSNumber *afternoonPrice;

- (id)initWithMorningPrice:(uint32_t)morning andAfternoonPrice:(uint32_t)afternoon;

@end

@interface TurnipPricesWrapper : NSObject

- (NSArray<Day *>*)calculateWithBasePrice:(NSNumber *)basePrice pattern:(NSNumber *)pattern seed:(NSNumber*)seed;

@end

NS_ASSUME_NONNULL_END
