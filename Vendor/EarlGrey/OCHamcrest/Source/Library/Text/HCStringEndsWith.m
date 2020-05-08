//  OCHamcrest by Jon Reid, https://qualitycoding.org/
//  Copyright 2019 hamcrest.org. See LICENSE.txt

#import "HCStringEndsWith.h"


@implementation HCStringEndsWith

- (BOOL)matches:(nullable id)item
{
    if (![item respondsToSelector:@selector(hasSuffix:)])
        return NO;

    return [item hasSuffix:self.substring];
}

- (NSString *)relationship
{
    return @"ending with";
}

@end


id HC_endsWith(NSString *suffix)
{
    return [[HCStringEndsWith alloc] initWithSubstring:suffix];
}
