//  OCHamcrest by Jon Reid, https://qualitycoding.org/
//  Copyright 2019 hamcrest.org. See LICENSE.txt

#import <OCHamcrest/HCBaseMatcher.h>


@NS_ASSUME_NONNULL_BEGIN

interface Mismatchable : HCBaseMatcher

+ (instancetype)mismatchable:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
