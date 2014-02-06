//
//  UGMCriteriaDetailView.m
//  Prostudy
//
//  Created by hanief on 1/19/13.
//  Copyright (c) 2013 Universitas Gadjah Mada. All rights reserved.
//

#import "UGMCriteriaDetailView.h"
#import "Criteria.h"
#import "CriteriaComparison.h"
#import "UGMComparisonDetailCell.h"

@interface UGMCriteriaDetailView ()
@property UIScrollView *scrollView;
@property UILabel *criteriaTitleLabel;
@property UILabel *criteriaListLabel;
@property NSArray *detailCells;

@end

@implementation UGMCriteriaDetailView
@synthesize criterias = _criterias;
@synthesize criteriaComparisonMatrix, criteriaComparisonSquaredMatrix, criteriaEigenVectorMatrix, consistencyRatio;
@synthesize criteriaTitles, criteriaNames, criteriaComparisonMatrices, criteriaComparisonSquaredMatrices, criteriaEigenVectorMatrices, criteriaConsistencyRatios;
@synthesize scrollView, criteriaTitleLabel, criteriaListLabel;
@synthesize detailCells;

- (id)initWithFrame:(CGRect)frame andCriterias:(NSArray *)criterias{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _criterias = criterias;
        
        consistencyRatio = 0.0;
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, frame.size.width, frame.size.height)];
        scrollView.contentSize = frame.size;
        
        criteriaTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.width-20, 30)];
        criteriaTitleLabel.text = @"Criteria Comparison Detail";
        criteriaTitleLabel.backgroundColor = [UIColor clearColor];
        criteriaTitleLabel.textColor = [UIColor blackColor];
        criteriaTitleLabel.font = [UIFont boldSystemFontOfSize:18];
        criteriaTitleLabel.textAlignment = NSTextAlignmentCenter;
        criteriaTitleLabel.adjustsFontSizeToFitWidth = YES;
        criteriaTitleLabel.minimumScaleFactor = 0.5;
        criteriaTitleLabel.centerX = self.centerX;
        [scrollView addSubview:criteriaTitleLabel];
        
        CGFloat lastHeight = criteriaTitleLabel.bottom;
        
        /*
        NSMutableString *criteriaList = [[NSMutableString alloc] init];
        
        for (Criteria *criteria in self.criteriaDataModel.items) {
            [criteriaList appendFormat:@"%@ - ", criteria.criteriaID];
            [criteriaList appendFormat:@"%@\n", criteria.name];
        }
        
        criteriaListLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, criteriaTitleLabel.bottom+5, self.width-20, 30)];
        criteriaListLabel.numberOfLines = self.criteriaDataModel.items.count;
        criteriaListLabel.text = criteriaList;
        criteriaListLabel.backgroundColor = [UIColor clearColor];
        criteriaListLabel.textColor = [UIColor blackColor];
        criteriaListLabel.font = [UIFont systemFontOfSize:12];
        criteriaListLabel.textAlignment = NSTextAlignmentLeft;
        [criteriaListLabel sizeToFit];
        [scrollView addSubview:criteriaListLabel];
        CGFloat lastHeight = criteriaListLabel.bottom;
        */
        
        NSMutableArray *tempCells = [[NSMutableArray alloc] init];
        
        for (int cellIndex = 0; cellIndex < self.criterias.count+1; cellIndex++) {
            UGMComparisonDetailCell *detailCell = [[UGMComparisonDetailCell alloc] initWithFrame:CGRectMake(10, lastHeight+10, self.width-20, 300)];
            detailCell.title = [criteriaTitles objectAtIndex:cellIndex];
            detailCell.items = [criteriaNames objectAtIndex:cellIndex];
            detailCell.comparisonMatrix = [criteriaComparisonMatrices objectAtIndex:cellIndex];
            detailCell.comparisonSquaredMatrix = [criteriaComparisonSquaredMatrices objectAtIndex:cellIndex];
            detailCell.eigenVectorMatrix = [criteriaEigenVectorMatrices objectAtIndex:cellIndex];
            detailCell.consistencyRatio = [[criteriaConsistencyRatios objectAtIndex:cellIndex] floatValue];
            detailCell.tag = cellIndex;
            [scrollView addSubview:detailCell];
            scrollView.contentSize = CGSizeMake(self.width, lastHeight+detailCell.height+5);
            
            [tempCells addObject:detailCell];
            lastHeight = detailCell.bottom;
        }
        
        detailCells = [NSArray arrayWithArray:tempCells];
        
        [self addSubview:scrollView];
    }
    
    return self;
}

- (void)reloadView{
    //[super layoutSubviews];
    
    criteriaTitleLabel.frame = CGRectMake(10, 5, self.width-20, 30);
    criteriaTitleLabel.centerX = self.centerX;
    CGFloat lastHeight = criteriaTitleLabel.bottom;
    
    /*
    NSMutableString *criteriaList = [[NSMutableString alloc] init];
    
    for (Criteria *criteria in self.criteriaDataModel.items) {
        [criteriaList appendFormat:@"%@ - ", criteria.criteriaID];
        [criteriaList appendFormat:@"%@\n", criteria.name];
    }
    
    criteriaListLabel.frame = CGRectMake(10, criteriaTitleLabel.bottom+5, self.width-20, 30);
    criteriaListLabel.numberOfLines = self.criteriaDataModel.items.count;
    criteriaListLabel.text = criteriaList;
    [criteriaListLabel sizeToFit];
    
    CGFloat lastHeight = criteriaListLabel.bottom;
    */
    for (int cellIndex = 0; cellIndex < detailCells.count; cellIndex++) {
        UGMComparisonDetailCell *detailCell = [detailCells objectAtIndex:cellIndex];
        detailCell.title = [criteriaTitles objectAtIndex:cellIndex];
        detailCell.items = [criteriaNames objectAtIndex:cellIndex];
        detailCell.comparisonMatrix = [criteriaComparisonMatrices objectAtIndex:cellIndex];
        detailCell.comparisonSquaredMatrix = [criteriaComparisonSquaredMatrices objectAtIndex:cellIndex];
        detailCell.eigenVectorMatrix = [criteriaEigenVectorMatrices objectAtIndex:cellIndex];
        detailCell.consistencyRatio = [[criteriaConsistencyRatios objectAtIndex:cellIndex] floatValue];
        [detailCell reloadView];
        
        detailCell.frame = CGRectMake(5, lastHeight+10, self.width-20, detailCell.height);
        scrollView.contentSize = CGSizeMake(self.width, lastHeight+detailCell.height+120);
        
        lastHeight = detailCell.bottom;
    }
}

@end
