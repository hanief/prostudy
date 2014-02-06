//
//  UGMCriteriaDetailView.h
//  Prostudy
//
//  Created by hanief on 1/19/13.
//  Copyright (c) 2013 Universitas Gadjah Mada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UGMCriteriaDetailView : UIView

@property NSArray *criterias;
@property NSArray *criteriaComparisonMatrix;
@property NSArray *criteriaComparisonSquaredMatrix;
@property NSArray *criteriaEigenVectorMatrix;
@property float consistencyRatio;

@property NSArray *criteriaTitles;
@property NSArray *criteriaNames;
@property NSArray *criteriaComparisonMatrices;
@property NSArray *criteriaComparisonSquaredMatrices;
@property NSArray *criteriaEigenVectorMatrices;
@property NSArray *criteriaConsistencyRatios;

- (id)initWithFrame:(CGRect)frame andCriterias:(NSArray *)criterias;

- (void)reloadView;

@end
