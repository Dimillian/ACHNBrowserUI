//  OCHamcrest by Jon Reid, https://qualitycoding.org/
//  Copyright 2019 hamcrest.org. See LICENSE.txt

#import "HCUnsignedLongLongReturnGetter.h"


@implementation HCUnsignedLongLongReturnGetter

- (instancetype)initWithSuccessor:(nullable HCReturnValueGetter *)successor
{
    self = [super initWithType:@encode(unsigned long long) successor:successor];
    return self;
}

- (id)returnValueFromInvocation:(NSInvocation *)invocation
{
    unsigned long long value;
    [invocation getReturnValue:&value];
    return @(value);
}

@end
