//  OCHamcrest by Jon Reid, https://qualitycoding.org/
//  Copyright 2019 hamcrest.org. See LICENSE.txt

#import "HCRequireNonNilObject.h"


void HCRequireNonNilObject(id obj)
{
    if (obj == nil)
    {
        @throw [NSException exceptionWithName:@"NilObject"
                                       reason:@"Must be non-nil object"
                                     userInfo:nil];
    }
}
