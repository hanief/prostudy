//
//  UGMComparisonDetailCell.h
//  Prostudy
//
//  Created by hanief on 1/20/13.
//  Copyright (c) 2013 Universitas Gadjah Mada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UGMComparisonDetailCell : UIView

@property NSString *title;
@property NSArray *items;
@property NSArray *comparisonMatrix;
@property NSArray *comparisonSquaredMatrix;
@property NSArray *eigenVectorMatrix;
@property float consistencyRatio;

@property UILabel *titleLabel;
@property UILabel *matrixTitleLabel;
@property UILabel *matrixLabel;
@property UILabel *squaredMatrixTitleLabel;
@property UILabel *squaredMatrixLabel;
@property UILabel *eigenVectorTitleLabel;
@property UILabel *eigenVectorLabel;
@property UILabel *consistencyRatioLabel;

- (void)reloadView;

@end
