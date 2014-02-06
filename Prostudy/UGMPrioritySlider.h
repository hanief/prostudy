//
//  UGMPrioritySlider.h
//  Prostudy
//
//  Created by hanief on 1/12/13.
//  Copyright (c) 2013 Universitas Gadjah Mada. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UGMPrioritySliderDelegate 
- (void)sliderViewID:(int)sliderID sliderValueChanged:(int)value;

@end

@interface UGMPrioritySlider : UISlider {
    id <UGMPrioritySliderDelegate> delegate;
}

@property UILabel *titleLabel;
@property UILabel *firstItemLabel;
@property UILabel *secondItemLabel;
@property (nonatomic, retain) id <UGMPrioritySliderDelegate> delegate;

@end
