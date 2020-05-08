//  OCHamcrest by Jon Reid, https://qualitycoding.org/
//  Copyright 2019 hamcrest.org. See LICENSE.txt

#import "HCDiagnosingMatcher.h"


@implementation HCDiagnosingMatcher

- (BOOL)matches:(nullable id)item
{
    return [self matches:item describingMismatchTo:nil];
}

- (BOOL)matches:(nullable id)item describingMismatchTo:(id <HCDescription>)mismatchDescription
{
    HC_ABSTRACT_METHOD;
    return NO;
}

- (void)describeMismatchOf:(nullable id)item to:(nullable id <HCDescription>)mismatchDescription
{
    [self matches:item describingMismatchTo:mismatchDescription];
}

@end
