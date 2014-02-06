//
//  UGMProjectExplanationCell.m
//  Prostudy
//
//  Created by hanief on 1/18/13.
//  Copyright (c) 2013 Universitas Gadjah Mada. All rights reserved.
//

#import "UGMProjectExplanationCell.h"
#import "UIView+Positioning.h"
#import "UIView+Size.h"

@implementation UGMProjectExplanationCell
@synthesize nameLabel, leftTextView, rightTextView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        leftTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 5, (self.width/2)-10, self.height)];
        leftTextView.text = @"First Item";
        leftTextView.backgroundColor = [UIColor clearColor];
        leftTextView.textColor = [UIColor blackColor];
        leftTextView.font = [UIFont systemFontOfSize:12];
        leftTextView.textAlignment = NSTextAlignmentLeft;
        leftTextView.editable = NO;
        [self addSubview:leftTextView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2, 5, 300, 30)];
        nameLabel.text = @"Character";
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.centerX = self.centerX;
        [self addSubview:nameLabel];
        
        rightTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.width/2+10, 5, (self.width/2)-10, self.height)];
        rightTextView.text = @"Second Item";
        rightTextView.backgroundColor = [UIColor clearColor];
        rightTextView.textColor = [UIColor blackColor];
        rightTextView.font = [UIFont systemFontOfSize:12];
        rightTextView.textAlignment = NSTextAlignmentRight;
        rightTextView.editable = NO;
        [self addSubview:rightTextView];
    }
    return self;
}

@end
