//
//  UGMCriteriaComparisonCell.m
//  Janus
//
//  Created by hanief on 1/12/13.
//  Copyright (c) 2013 Universitas Gadjah Mada. All rights reserved.
//

#import "UGMCriteriaComparisonCell.h"
#import "UIView+Positioning.h"
#import "UIView+Size.h"
#import "UGMPrioritySlider.h"

@implementation UGMCriteriaComparisonCell
@synthesize firstItemLabel, secondItemLabel, prioritySlider, cellIndex;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        firstItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, (self.width-20)/2-10, 44)];
        firstItemLabel.text = @"First Item";
        firstItemLabel.backgroundColor = [UIColor clearColor];
        firstItemLabel.textColor = [UIColor blackColor];
        firstItemLabel.font = [UIFont boldSystemFontOfSize:18];
        firstItemLabel.textAlignment = NSTextAlignmentCenter;
        firstItemLabel.adjustsFontSizeToFitWidth = YES;
        firstItemLabel.minimumScaleFactor = 0.5;
        [self addSubview:firstItemLabel];
        
        secondItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(((self.width-20)/2)+15, 75, (self.width-20)/2-10, 44)];
        secondItemLabel.text = @"Second Item";
        secondItemLabel.backgroundColor = [UIColor clearColor];
        secondItemLabel.textColor = [UIColor blackColor];
        secondItemLabel.font = [UIFont boldSystemFontOfSize:18];
        secondItemLabel.textAlignment = NSTextAlignmentCenter;
        secondItemLabel.adjustsFontSizeToFitWidth = YES;
        secondItemLabel.minimumScaleFactor = 0.5;
        [self addSubview:secondItemLabel];
        
        prioritySlider = [[UGMPrioritySlider alloc] initWithFrame:CGRectMake(10, firstItemLabel.top-30, self.width-20, 44)];
        [self addSubview:prioritySlider];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

@end
