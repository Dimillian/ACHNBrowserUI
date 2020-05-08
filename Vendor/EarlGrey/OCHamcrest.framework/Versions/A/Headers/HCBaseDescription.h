//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 hamcrest.org. See LICENSE.txt

#import <Foundation/Foundation.h>
#import <OCHamcrest/HCDescription.h>


/*!
 * @abstract Base class for all @ref HCDescription implementations.
 */
@interface HCBaseDescription : NSObject <HCDescription>
@end


/*!
 * @abstract Methods that must be provided by subclasses of HCBaseDescription.
 */
@interface HCBaseDescription (SubclassResponsibility)

/*!
 * @abstract Appends the specified string to the description.
 */
- (void)append:(NSString *)str;

@end
