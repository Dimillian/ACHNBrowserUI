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

#import <UIKit/UIKit.h>

// Class that controls FTRScrollViewController.xib view. The view contains various scroll views used
// for testing which are listed as properties below.
@interface FTRScrollViewController : UIViewController <UIScrollViewDelegate,
                                                       UITextFieldDelegate>

@property(unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollview;
@property(retain, nonatomic) IBOutlet UIScrollView *bottomScrollView;
// The current scroll algorithm ends up in a infinite scroll loop when trying to scroll to a label
// inside this view.
@property(weak, nonatomic) IBOutlet UIScrollView *infiniteScrollView;
@property(retain, nonatomic) IBOutlet UIView *blockView;
@property(retain, nonatomic) IBOutlet UITextField *topTextbox;
@property(retain, nonatomic) UIAccessibilityElement *accessibilityElement;

@end
