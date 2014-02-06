//
//  UGMCriteriaComparisonViewController.h
//  Prostudy
//
//  Created by hanief on 1/11/13.
//  Copyright (c) 2013 Universitas Gadjah Mada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGMPrioritySlider.h"
#import "Criteria.h"

@interface UGMCriteriaComparisonViewController : UITableViewController <UGMPrioritySliderDelegate>

- (instancetype)initWithCriterias:(NSArray *)criterias andComparisons:(NSArray *)comparisons;

@end
