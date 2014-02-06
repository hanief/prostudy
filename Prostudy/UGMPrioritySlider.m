//
//  UGMPrioritySlider.m
//  Prostudy
//
//  Created by hanief on 1/12/13.
//  Copyright (c) 2013 Universitas Gadjah Mada. All rights reserved.
//

#import "UGMPrioritySlider.h"
#import "UIView+Positioning.h"
#import "UIView+Size.h"

@interface UGMPrioritySlider ()
@property UILabel *indicatorLabel;
@property NSArray *indicatorTextArray;

@end

@implementation UGMPrioritySlider
@synthesize indicatorLabel, indicatorTextArray;
@synthesize delegate;
@synthesize firstItemLabel, secondItemLabel, titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.minimumValue = -8;
        self.maximumValue = 8;
        self.continuous = NO;
        [self setValue:0];
        [self setMinimumTrackTintColor:[UIColor blueColor]];
        [self setMaximumTrackTintColor:[UIColor blueColor]];
        indicatorTextArray = [NSArray arrayWithObjects:@"",@"Equal Importance",@"Slightly Moderate Importance",@"Moderate Importance",@"Slightly Strong Importance",@"Strong Importance",@"Slightly Very Strong Importance",@"Very Strong Importance",@"Slightly Extreme Importance",@"Extreme Importance", nil];
        
        indicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width/2)-14, 30, 30, 30)];
        indicatorLabel.text = [NSString stringWithFormat:@"%d - %@",abs(self.value)+1, [indicatorTextArray objectAtIndex:abs(self.value)+1]];
        indicatorLabel.backgroundColor = [UIColor clearColor];
        indicatorLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
        indicatorLabel.font = [UIFont boldSystemFontOfSize:16];
        indicatorLabel.textAlignment = NSTextAlignmentCenter;
        [indicatorLabel sizeToFit];
        indicatorLabel.centerX = self.centerX;
        [self addSubview:indicatorLabel];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, -35, 200, 30)];
        titleLabel.text = @"Title";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.minimumScaleFactor = 0.5;
        titleLabel.centerX = self.centerX;
        [self addSubview:titleLabel];
        
        firstItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, -10, (frame.size.width-20)/2-10, 30)];
        firstItemLabel.text = @"First Item";
        firstItemLabel.backgroundColor = [UIColor clearColor];
        firstItemLabel.textColor = [UIColor brownColor];
        firstItemLabel.font = [UIFont boldSystemFontOfSize:18];
        firstItemLabel.textAlignment = NSTextAlignmentLeft;
        firstItemLabel.adjustsFontSizeToFitWidth = YES;
        firstItemLabel.minimumScaleFactor = 0.5;
        [self addSubview:firstItemLabel];
        
        secondItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(((frame.size.width-20)/2)+20, -10, (frame.size.width-20)/2-10, 30)];
        secondItemLabel.text = @"Second Item";
        secondItemLabel.backgroundColor = [UIColor clearColor];
        secondItemLabel.textColor = [UIColor brownColor];
        secondItemLabel.font = [UIFont boldSystemFontOfSize:18];
        secondItemLabel.textAlignment = NSTextAlignmentRight;
        secondItemLabel.adjustsFontSizeToFitWidth = YES;
        secondItemLabel.minimumScaleFactor = 0.5;
        [self addSubview:secondItemLabel];

    }
    return self;
}

- (void)setValue:(float)value animated:(BOOL)animated{
    int intValue = roundl(value);
    [super setValue:(float)intValue animated:animated];
    
    [self setMinimumTrackTintColor:[UIColor colorWithRed:0.1*abs(intValue) green:0.0 blue:1.0/abs(intValue) alpha:1.0]];
    [self setMaximumTrackTintColor:[UIColor colorWithRed:0.1*abs(intValue) green:0.0 blue:1.0/abs(intValue) alpha:1.0]];
    indicatorLabel.text = [NSString stringWithFormat:@"%d - %@",abs(intValue)+1, [indicatorTextArray objectAtIndex:abs(self.value)+1]];
    indicatorLabel.textColor = [UIColor colorWithRed:0.1*abs(intValue) green:0.0 blue:1.0/abs(intValue) alpha:1.0];
    [indicatorLabel sizeToFit];
    indicatorLabel.centerX = self.centerX;
    
    [titleLabel sizeToFit];
    titleLabel.centerX = self.centerX;
    
    [[self delegate] sliderViewID:self.tag sliderValueChanged:intValue];
}

@end
