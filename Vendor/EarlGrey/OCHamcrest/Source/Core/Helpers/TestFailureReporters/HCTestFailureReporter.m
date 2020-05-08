//  OCHamcrest by Jon Reid, https://qualitycoding.org/
//  Copyright 2019 hamcrest.org. See LICENSE.txt

#import "HCTestFailureReporter.h"

@interface HCTestFailureReporter (SubclassResponsibility)
- (BOOL)willHandleFailure:(HCTestFailure *)failure;
- (void)executeHandlingOfFailure:(HCTestFailure *)failure;
@end


@implementation HCTestFailureReporter

- (void)handleFailure:(HCTestFailure *)failure
{
    if ([self willHandleFailure:failure])
        [self executeHandlingOfFailure:failure];
    else
        [self.successor handleFailure:failure];
}

@end
