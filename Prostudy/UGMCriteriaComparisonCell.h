//
//  UGMCriteriaComparisonCell.h
//  Janus
//
//  Created by hanief on 1/12/13.
//  Copyright (c) 2013 Universitas Gadjah Mada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CriteriaComparison.h"
#import "UGMPrioritySlider.h"

@interface UGMCriteriaComparisonCell : UITableViewCell

@property UILabel *firstItemLabel;
@property UILabel *secondItemLabel;
@property UGMPrioritySlider *prioritySlider;
@property NSUInteger cellIndex;
@end
