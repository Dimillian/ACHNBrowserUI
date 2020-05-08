//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 hamcrest.org. See LICENSE.txt

#import <Foundation/Foundation.h>
#import <OCHamcrest/HCMatcher.h>

#define HC_ABSTRACT_METHOD [self subclassResponsibility:_cmd]


/*!
 * @abstract Base class for all @ref HCMatcher implementations.
 * @discussion Simple matchers can just subclass HCBaseMatcher and implement <code>-matches:</code>
 * and <code>-describeTo:</code>. But if the matching algorithm has several "no match" paths,
 * consider subclassing @ref HCDiagnosingMatcher instead.
 */
@interface HCBaseMatcher : NSObject <HCMatcher, NSCopying>

/*! @abstract Raises exception that command (a pseudo-abstract method) is not implemented. */
- (void)subclassResponsibility:(SEL)command;

@end
