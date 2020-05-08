//  OCHamcrest by Jon Reid, https://qualitycoding.org/
//  Copyright 2019 hamcrest.org. See LICENSE.txt

#import "HCCharReturnGetter.h"


@implementation HCCharReturnGetter

- (instancetype)initWithSuccessor:(nullable HCReturnValueGetter *)successor
{
    self = [super initWithType:@encode(char) successor:successor];
    return self;
}

- (id)returnValueFromInvocation:(NSInvocation *)invocation
{
    char value;
    [invocation getReturnValue:&value];
    return @(value);
}

@end
