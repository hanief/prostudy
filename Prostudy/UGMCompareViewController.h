//
//  UGMCompareViewController.h
//  Prostudy
//
//  Created by hanief on 1/9/13.
//  Copyright (c) 2013 Universitas Gadjah Mada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGMPrioritySlider.h"

@interface UGMCompareViewController : UITableViewController <UGMPrioritySliderDelegate>

- (instancetype)initWithProjects:(NSArray *)projects andComparisons:(NSArray *)comparisons;

@end
