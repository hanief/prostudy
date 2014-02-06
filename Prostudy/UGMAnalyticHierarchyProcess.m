//
//  UGMAnalyticHierarchyProcess.m
//  Prostudy
//
//  Created by Hanief Cahya on 14/01/14.
//  Copyright (c) 2014 Universitas Gadjah Mada. All rights reserved.
//

//#import <Accelerate/Accelerate.h>
#import "UGMAnalyticHierarchyProcess.h"

@implementation UGMAnalyticHierarchyProcess


#pragma mark - Public Methods 

- (void)AHPFromMatrix:(NSArray *)matrix completion:(void (^)(NSArray *, NSArray *, float, NSError *))block{
    //[self printMatrix:matrix];
    NSArray *squaredMatrix = [self powerSquareMatrix:matrix];
    NSArray *eigenVector = [self eigenvectorFromMatrix:matrix];
    float consistencyRatio = [self consistencyRatioOfMatrix:matrix andEigenvector:eigenVector];
    
    block(squaredMatrix, eigenVector, consistencyRatio, nil);
}

#pragma mark - Private Methods

// Get eigenvector

- (NSArray *)eigenvectorFromMatrix:(NSArray *)matrix {
    BOOL iterateAgain = YES;
    
    NSArray *powerSquaredMatrix = [self powerSquareMatrix:matrix];
    NSArray *sumRowArray = [self sumRowArrayFromMatrix:powerSquaredMatrix];
    NSArray *normalizedArray = [self normalizedArray:sumRowArray];
    
    NSArray *prevPSM = [powerSquaredMatrix copy];
    NSArray *prevSRA = [sumRowArray copy];
    NSArray *prevNA = [normalizedArray copy];
    
    while (iterateAgain) {
        powerSquaredMatrix = [self powerSquareMatrix:powerSquaredMatrix];
        sumRowArray = [self sumRowArrayFromMatrix:powerSquaredMatrix];
        normalizedArray = [self normalizedArray:sumRowArray];
        
        if ([self differenceSmallEnoughBetweenMatrixOne:normalizedArray andMatrixTwo:prevNA]) {
            iterateAgain = NO;
        } else {
            prevPSM = [powerSquaredMatrix copy];
            prevSRA = [sumRowArray copy];
            prevNA = [normalizedArray copy];
        }
    }
    
    return normalizedArray;
}

// Get Consistency Ratio of Matrix

- (float)consistencyRatioOfMatrix:(NSArray *)matrix andEigenvector:(NSArray *)eigenvector{
    
    float consistencyRatio = 0.0;
    
    NSArray *multipliedMatrix = [self multiplyMatrixOne:matrix andMatrixTwo:eigenvector];
    int n = multipliedMatrix.count;
    
    float lambdaMax = 0.0;
    
    for (int index = 0; index < n; index++) {
        float divideAndConquer = [multipliedMatrix[index] floatValue] / [eigenvector[index] floatValue];
        lambdaMax += divideAndConquer;
    }
    
    lambdaMax = lambdaMax/n;
    
    float consistencyIndex = (lambdaMax - n)/(n-1);
    
    consistencyRatio = consistencyIndex/[self randomConsistencyIndexOfMatrixSize:n];
    
    return consistencyRatio;
}

- (NSArray *)multiplyMatrixOne:(NSArray *)matrixOne andMatrixTwo:(NSArray *)matrixTwo{
    NSArray *rowOne = [matrixOne firstObject];
    if (rowOne.count != matrixTwo.count) {
        return nil;
    }
    NSMutableArray *multipliedMatrix = [NSMutableArray array];
    
    for (NSArray *row in matrixOne) {
        float sum = 0.0;
        for (int index = 0; index < row.count; index++) {
            sum += [row[index] floatValue] * [matrixTwo[index] floatValue];
        }
        [multipliedMatrix addObject:[NSNumber numberWithFloat:sum]];
    }
    
    return multipliedMatrix;
}

// Tell if difference between two array is small enough to stop iterating

- (BOOL)differenceSmallEnoughBetweenMatrixOne:(NSArray *)arrayOne andMatrixTwo:(NSArray *)arrayTwo{
    for (int index = 0; index < arrayOne.count; index++) {
        float diff = fabsf([arrayOne[index] floatValue] - [arrayTwo[index] floatValue]);
        
        if (diff > 0.0001) {
            return NO;
        }
    }
    
    return YES;
}

// Get Random Consistency Index (RI) Value according to matrix size

- (float)randomConsistencyIndexOfMatrixSize:(int)size{
    float randomConsistencyIndex = 0.0;
    
    switch (size) {
        case 1:
            randomConsistencyIndex = 0.0;
            break;
        case 2:
            randomConsistencyIndex = 0.0;
            break;
        case 3:
            randomConsistencyIndex = 0.58;
            break;
        case 4:
            randomConsistencyIndex = 0.9;
            break;
        case 5:
            randomConsistencyIndex = 1.12;
            break;
        case 6:
            randomConsistencyIndex = 1.24;
            break;
        case 7:
            randomConsistencyIndex = 1.32;
            break;
        case 8:
            randomConsistencyIndex = 1.41;
            break;
        case 9:
            randomConsistencyIndex = 1.45;
            break;
        default:
            break;
    }
    
    return randomConsistencyIndex;
}

// Get square power of a matrix

- (NSArray *)powerSquareMatrix:(NSArray *)matrix{
    NSMutableArray *tempMatrix = [[NSMutableArray alloc] init];
    
    for (int rowIndex = 0; rowIndex < matrix.count; rowIndex++) {
        NSMutableArray *tempRow = [[NSMutableArray alloc] init];
        
        NSArray *rowArray = [NSArray arrayWithArray:[matrix objectAtIndex:rowIndex]];
        
        for (int columnIndex = 0; columnIndex < matrix.count; columnIndex++) {
            float tempFloat = 0.0;
            
            NSMutableArray *columnArray = [[NSMutableArray alloc] init];
            
            for (NSArray *array in matrix) {
                [columnArray addObject:[array objectAtIndex:columnIndex]];
            }
            
            for (int arrayIndex = 0; arrayIndex < rowArray.count; arrayIndex++) {
                tempFloat += ([[rowArray objectAtIndex:arrayIndex] floatValue] * [[columnArray objectAtIndex:arrayIndex] floatValue]);
            }
            
            [tempRow addObject:[NSNumber numberWithFloat:tempFloat]];
        }
        [tempMatrix addObject:tempRow];
    }
    
    return [NSArray arrayWithArray:tempMatrix];
}

// Get sum row array from matrix

- (NSArray *)sumRowArrayFromMatrix:(NSArray *)matrix{
    NSMutableArray *sumArray = [[NSMutableArray alloc] init];
    
    for (int rowIndex = 0; rowIndex < matrix.count; rowIndex++) {
        if ([[matrix objectAtIndex:rowIndex] isKindOfClass:[NSArray class]]) {
            NSArray *rowArray = [matrix objectAtIndex:rowIndex];
            float rowSum = 0.0;
            
            for (NSNumber *value in rowArray) {
                rowSum += [value floatValue];
            }
            
            [sumArray addObject:[NSNumber numberWithFloat:rowSum]];
        } else {
            return nil;
        }
    }
    
    return sumArray;
}

// Get Normalized Array

- (NSArray *)normalizedArray:(NSArray *)array{
    NSNumber *totalSum = [self sumOfArray:array];
    
    NSMutableArray *normalized = [NSMutableArray array];
    
    for (NSNumber *number in array) {
        float normalizedFloat = [number floatValue]/[totalSum floatValue];
        [normalized addObject:[NSNumber numberWithFloat:normalizedFloat]];
    }
    
    return normalized;
}

// Get sum row matrix from matrix

- (NSArray *)sumRowMatrixFromMatrix:(NSArray *)matrix{
    NSMutableArray *sumArray = [[NSMutableArray alloc] init];
    
    for (int rowIndex = 0; rowIndex < matrix.count; rowIndex++) {
        if ([[matrix objectAtIndex:rowIndex] isKindOfClass:[NSArray class]]) {
            NSArray *rowArray = [matrix objectAtIndex:rowIndex];
            float rowSum = 0.0;
            
            for (NSNumber *value in rowArray) {
                rowSum += [value floatValue];
            }
            
            [sumArray addObject:@[[NSNumber numberWithFloat:rowSum]]];
        } else {
            return nil;
        }
    }
    
    return sumArray;
}

// Get sum of array

- (NSNumber *)sumOfArray:(NSArray *)array{
    float theSum = 0.0;
    for (NSNumber *number in array) {
        theSum += [number floatValue];
    }
    return [NSNumber numberWithFloat:theSum];
}

// Get sum column matrix from matrix

- (NSArray *)sumColumnMatrixFromMatrix:(NSArray *)matrix{
    NSMutableArray *columnArray = [[NSMutableArray alloc] initWithCapacity:matrix.count];
    
    return columnArray;
}

#pragma mark - print helper

- (void)printMatrix:(NSArray *)matrix{
    //TestMatrix
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:4];
    [formatter setMinimumFractionDigits:4];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    
    NSMutableString *matrixString = [NSMutableString string];
    for (NSArray *rowArray in matrix) {
        [matrixString appendString:@"|"];
        for (NSNumber *rowValue in rowArray) {
            [matrixString appendFormat:@" %@ ", [formatter stringFromNumber:rowValue]];
        }
        [matrixString appendString:@"|\n"];
    }
    NSLog(@"Matrix :\n%@",matrixString);
}

- (void)printArray:(NSArray *)array{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:4];
    [formatter setMinimumFractionDigits:4];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    
    NSMutableString *arrayString = [NSMutableString string];
    for (NSNumber *number in array) {
        [arrayString appendFormat:@"%@ ",[formatter stringFromNumber:number]];
    }
    
    NSLog(@"Array : %@",arrayString);
}

@end
