//
//  UGMComparisonView.m
//  Prostudy
//
//  Created by hanief on 1/18/13.
//  Copyright (c) 2013 Universitas Gadjah Mada. All rights reserved.
//

#import "UGMComparisonView.h"

@implementation UGMComparisonView
@synthesize prioritySlider;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        prioritySlider = [[UGMPrioritySlider alloc] initWithFrame:CGRectMake(10, 35, self.width-20, 44)];
        [self addSubview:prioritySlider];
    }
    return self;
}

@end
