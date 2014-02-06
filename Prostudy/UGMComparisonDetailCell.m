//
//  UGMComparisonDetailCell.m
//  Prostudy
//
//  Created by hanief on 1/20/13.
//  Copyright (c) 2013 Universitas Gadjah Mada. All rights reserved.
//

#import "UGMComparisonDetailCell.h"

@implementation UGMComparisonDetailCell
@synthesize title, items, comparisonMatrix, comparisonSquaredMatrix, eigenVectorMatrix, consistencyRatio;
@synthesize titleLabel, matrixLabel, matrixTitleLabel, squaredMatrixLabel, squaredMatrixTitleLabel, eigenVectorLabel, eigenVectorTitleLabel, consistencyRatioLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.width, 20)];
        titleLabel.text = [NSString stringWithFormat:@"----------- %@ -----------", self.title];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor brownColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.minimumScaleFactor = 0.5;
        titleLabel.centerX = self.centerX;
        [self addSubview:titleLabel];
        
        matrixTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.bottom+5, self.width, 20)];
        matrixTitleLabel.text = @"Comparison Matrix";
        matrixTitleLabel.backgroundColor = [UIColor clearColor];
        matrixTitleLabel.textColor = [UIColor blackColor];
        matrixTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        matrixTitleLabel.textAlignment = NSTextAlignmentCenter;
        matrixTitleLabel.adjustsFontSizeToFitWidth = YES;
        matrixTitleLabel.minimumScaleFactor = 0.5;
        matrixTitleLabel.centerX = self.centerX;
        [self addSubview:matrixTitleLabel];
        
        matrixLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, matrixTitleLabel.bottom+5, self.width, 20*(comparisonMatrix.count+1))];
        matrixLabel.numberOfLines = comparisonMatrix.count+1;
        matrixLabel.text = [self stringFromMatrix:comparisonMatrix withTitles:self.items];
        matrixLabel.backgroundColor = [UIColor clearColor];
        matrixLabel.textColor = [UIColor blackColor];
        matrixLabel.font = [UIFont systemFontOfSize:11];
        matrixLabel.textAlignment = NSTextAlignmentLeft;
        [matrixLabel sizeToFit];
        [self addSubview:matrixLabel];
        
        squaredMatrixTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, matrixLabel.bottom+10, self.width, 20)];
        squaredMatrixTitleLabel.text = @"Comparison Squared Matrix";
        squaredMatrixTitleLabel.backgroundColor = [UIColor clearColor];
        squaredMatrixTitleLabel.textColor = [UIColor blackColor];
        squaredMatrixTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        squaredMatrixTitleLabel.textAlignment = NSTextAlignmentCenter;
        squaredMatrixTitleLabel.adjustsFontSizeToFitWidth = YES;
        squaredMatrixTitleLabel.minimumScaleFactor = 0.5;
        squaredMatrixTitleLabel.centerX = self.centerX;
        [self addSubview:squaredMatrixTitleLabel];
        
        squaredMatrixLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, squaredMatrixTitleLabel.bottom+5, self.width, 20*comparisonSquaredMatrix.count)];
        squaredMatrixLabel.numberOfLines = comparisonSquaredMatrix.count;
        squaredMatrixLabel.text = [self stringFromMatrix:comparisonSquaredMatrix withTitles:self.items];
        squaredMatrixLabel.backgroundColor = [UIColor clearColor];
        squaredMatrixLabel.textColor = [UIColor blackColor];
        squaredMatrixLabel.font = [UIFont systemFontOfSize:11];
        squaredMatrixLabel.textAlignment = NSTextAlignmentLeft;
        [squaredMatrixLabel sizeToFit];
        [self addSubview:squaredMatrixLabel];
        
        eigenVectorTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, squaredMatrixLabel.bottom+10, self.width, 20)];
        eigenVectorTitleLabel.text = @"Comparison Eigenvector";
        eigenVectorTitleLabel.backgroundColor = [UIColor clearColor];
        eigenVectorTitleLabel.textColor = [UIColor blackColor];
        eigenVectorTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        eigenVectorTitleLabel.textAlignment = NSTextAlignmentCenter;
        eigenVectorTitleLabel.adjustsFontSizeToFitWidth = YES;
        eigenVectorTitleLabel.minimumScaleFactor = 0.5;
        eigenVectorTitleLabel.centerX = self.centerX;
        [self addSubview:eigenVectorTitleLabel];
        
        eigenVectorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, eigenVectorTitleLabel.bottom+5, self.width, 20*eigenVectorMatrix.count)];
        eigenVectorLabel.numberOfLines = eigenVectorMatrix.count;
        eigenVectorLabel.text = [self stringFromMatrix:eigenVectorMatrix withTitles:self.items];
        eigenVectorLabel.backgroundColor = [UIColor clearColor];
        eigenVectorLabel.textColor = [UIColor blackColor];
        eigenVectorLabel.font = [UIFont systemFontOfSize:11];
        eigenVectorLabel.textAlignment = NSTextAlignmentLeft;
        [eigenVectorLabel sizeToFit];
        eigenVectorLabel.centerX = self.centerX;
        [self addSubview:eigenVectorLabel];
        
        consistencyRatioLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, eigenVectorLabel.bottom+10, self.width, 20)];
        consistencyRatioLabel.text = [NSString stringWithFormat:@"Consistency Ratio : %.2f", self.consistencyRatio];
        consistencyRatioLabel.backgroundColor = [UIColor clearColor];
        consistencyRatioLabel.textColor = [UIColor blackColor];
        consistencyRatioLabel.font = [UIFont boldSystemFontOfSize:14];
        consistencyRatioLabel.textAlignment = NSTextAlignmentCenter;
        consistencyRatioLabel.adjustsFontSizeToFitWidth = YES;
        consistencyRatioLabel.minimumScaleFactor = 0.5;
        consistencyRatioLabel.centerX = self.centerX;
        [self addSubview:consistencyRatioLabel];
        
        self.frame = CGRectMake(0, 0, self.width, consistencyRatioLabel.bottom);
    }
    return self;
}

- (void)reloadView{
    titleLabel.frame = CGRectMake(0, 5, self.width, 30);
    titleLabel.text = [NSString stringWithFormat:@"----------- %@ -----------", self.title];
    titleLabel.centerX = self.centerX;
    
    matrixTitleLabel.frame = CGRectMake(0, titleLabel.bottom+10, self.width, 20);
    matrixTitleLabel.text = @"Comparison Matrix";
    matrixTitleLabel.centerX = self.centerX;
    
    matrixLabel.frame = CGRectMake(0, matrixTitleLabel.bottom, self.width, 20*(comparisonMatrix.count+1));
    matrixLabel.numberOfLines = comparisonMatrix.count+1;
    matrixLabel.text = [self stringFromMatrix:comparisonMatrix withTitles:self.items];
    [matrixLabel sizeToFit];
    matrixLabel.centerX = self.centerX;
    
    squaredMatrixTitleLabel.frame = CGRectMake(0, matrixLabel.bottom+10, self.width, 20);
    squaredMatrixTitleLabel.text = @"Comparison Squared Matrix";
    squaredMatrixTitleLabel.centerX = self.centerX;
    
    squaredMatrixLabel.frame = CGRectMake(0, squaredMatrixTitleLabel.bottom, self.width, 20*(comparisonSquaredMatrix.count+1));
    squaredMatrixLabel.numberOfLines = comparisonSquaredMatrix.count+1;
    squaredMatrixLabel.text = [self stringFromMatrix:comparisonSquaredMatrix withTitles:self.items];
    [squaredMatrixLabel sizeToFit];
    squaredMatrixLabel.centerX = self.centerX;
    
    eigenVectorTitleLabel.frame = CGRectMake(0, squaredMatrixLabel.bottom+10, self.width, 20);
    eigenVectorTitleLabel.text = @"Comparison Eigenvector";
    eigenVectorTitleLabel.centerX = self.centerX;
    
    eigenVectorLabel.frame = CGRectMake(0, eigenVectorTitleLabel.bottom, self.width, 20*(eigenVectorMatrix.count+1));
    eigenVectorLabel.numberOfLines = eigenVectorMatrix.count+1;
    eigenVectorLabel.text = [self stringFromMatrix:eigenVectorMatrix withTitles:self.items];
    [eigenVectorLabel sizeToFit];
    eigenVectorLabel.centerX = self.centerX;
    
    consistencyRatioLabel.frame = CGRectMake(0, eigenVectorLabel.bottom+10, self.width, 20);
    consistencyRatioLabel.text = [NSString stringWithFormat:@"Consistency Ratio : %.2f", self.consistencyRatio];
    consistencyRatioLabel.centerX = self.centerX;
    
    self.frame = CGRectMake(0, 0, self.width, consistencyRatioLabel.bottom);
}

- (NSString *)stringFromMatrix:(NSArray*)matrix withTitles:(NSArray*)titles{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    
    NSMutableString *matrixString = [NSMutableString string];
    
    if ([[matrix objectAtIndex:0] isKindOfClass:[NSArray class]]) {
        for (int rowIndex = 0; rowIndex < matrix.count+1; rowIndex++) {
            
            if (rowIndex == 0) {

                [matrixString appendString:@"\n"];
                
            } else {
                NSArray *rowArray = [matrix objectAtIndex:rowIndex-1];
                NSString *rowTitle = [titles objectAtIndex:rowIndex-1];
                
                [matrixString appendFormat:@"%@%C|",rowTitle,(unichar)0x0009];
                
                for (NSNumber *rowValue in rowArray) {
                    [matrixString appendFormat:@" %@", [formatter stringFromNumber:rowValue]];
                }
                [matrixString appendString:@" |\n"];
            }
        }
    } else if ([[matrix objectAtIndex:0] isKindOfClass:[NSNumber class]]) {
        
        for (int rowIndex = 0; rowIndex < matrix.count+1; rowIndex++) {
            
            if (rowIndex == 0) {
                
                [matrixString appendString:@"\n"];
                
            } else {
                NSNumber *rowValue = [matrix objectAtIndex:rowIndex-1];
                NSString *rowTitle = [titles objectAtIndex:rowIndex-1];
                
                [matrixString appendFormat:@"%@%C|",rowTitle,(unichar)0x0009];
                
                [matrixString appendFormat:@" %@ |\n", [formatter stringFromNumber:rowValue]];
            }
        }
    }
    
    return matrixString;
}

@end
