//
//  UGMTripleTextCell.m
//  Prostudy
//
//  Created by Hanief Cahya on 02/02/14.
//  Copyright (c) 2014 Universitas Gadjah Mada. All rights reserved.
//

#import "UGMTripleTextCell.h"
#import "UIView+Positioning.h"
#import "UIView+Size.h"

@implementation UGMTripleTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.rightTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.rightTextLabel.textAlignment = NSTextAlignmentRight;
        self.rightTextLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.rightTextLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.rightTextLabel.frame = CGRectMake(self.textLabel.right+20, self.textLabel.top, self.contentView.width-self.textLabel.width-30, self.contentView.height);\
    self.rightTextLabel.centerY = self.contentView.centerY;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    
    self.rightTextLabel.text = nil;
}

@end
