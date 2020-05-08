//  OCHamcrest by Jon Reid, https://qualitycoding.org/
//  Copyright 2019 hamcrest.org. See LICENSE.txt

#import "HCShortReturnGetter.h"


@implementation HCShortReturnGetter

- (instancetype)initWithSuccessor:(nullable HCReturnValueGetter *)successor
{
    self = [super initWithType:@encode(short) successor:successor];
    return self;
}

- (id)returnValueFromInvocation:(NSInvocation *)invocation
{
    short value;
    [invocation getReturnValue:&value];
    return @(value);
}

@end
