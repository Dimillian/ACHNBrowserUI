//  OCHamcrest by Jon Reid, https://qualitycoding.org/
//  Copyright 2019 hamcrest.org. See LICENSE.txt

#import <OCHamcrest/HCWrapInMatcher.h>

@import XCTest;


@interface HCWrapInMatcherTests : XCTestCase
@end

@implementation HCWrapInMatcherTests

- (void)test_wrapInMatcher_withNil_shouldReturnNil
{
    XCTAssertNil(HCWrapInMatcher(nil));
}

@end
