//
// Copyright 2016 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "FTRBaseAnalyticsTest.h"

#import <EarlGrey/EarlGrey.h>

@interface FTRAnalyticsTestMethodOptOutTest : FTRBaseAnalyticsTest
@end

@implementation FTRAnalyticsTestMethodOptOutTest

- (void)testMethodThatOptsOutOfAnalytics {
  [FTRBaseAnalyticsTest setExpectedAnalyticsRequestsCount:1];

  // Verify that analytics is enabled.
  GREYAssertTrue(GREY_CONFIG_BOOL(kGREYConfigKeyAnalyticsEnabled), @"should be true");

  // Invoke trivial EarlGrey statement to trigger analytics.
  [[EarlGrey selectElementWithMatcher:grey_keyWindow()] assertWithMatcher:grey_notNil()];

  // OptOut of analytics.
  [[GREYConfiguration sharedInstance] setValue:@(NO)
                                  forConfigKey:kGREYConfigKeyAnalyticsEnabled];
  [FTRBaseAnalyticsTest setExpectedAnalyticsRequestsCount:0];
}

@end
