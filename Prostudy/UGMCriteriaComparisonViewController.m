//
//  UGMCriteriaComparisonViewController.m
//  Prostudy
//
//  Created by hanief on 1/11/13.
//  Copyright (c) 2013 Universitas Gadjah Mada. All rights reserved.
//

#import "UGMCriteriaComparisonViewController.h"
#import "UIView+Positioning.h"
#import "UIView+Size.h"
#import "UGMPrioritySlider.h"
#import "CriteriaComparison.h"
#import "Criteria.h"
#import "UGMComparisonCell.h"
#import "UGMAnalyticHierarchyProcess.h"

@interface UGMCriteriaComparisonViewController ()
@property NSArray *comparisons;
@property NSArray *filteredComparisons;
@property NSArray *criterias;
@property UILabel *consistencyRatioLabel;
@property UGMAnalyticHierarchyProcess *AHP;
@end

@implementation UGMCriteriaComparisonViewController
@synthesize comparisons = _comparisons;
@synthesize filteredComparisons = _filteredComparisons;
@synthesize criterias = _criterias;
@synthesize consistencyRatioLabel, AHP;

- (instancetype)initWithCriterias:(NSArray *)criterias andComparisons:(NSArray *)comparisons{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        _criterias = criterias;
        _comparisons = comparisons;
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (CriteriaComparison *aComparison in comparisons) {
            if (([criterias indexOfObject:aComparison.firstCriteria] < [criterias indexOfObject:aComparison.secondCriteria])) {
                [tempArray addObject:aComparison];
            }
        }
        
        _filteredComparisons = [NSArray arrayWithArray:tempArray];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonPressed)]];
    
    
    
    consistencyRatioLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 50)];
    [self.navigationItem setTitleView:consistencyRatioLabel];
    
    if (!AHP) AHP = [[UGMAnalyticHierarchyProcess alloc] init];
    
    [AHP AHPFromMatrix:[self matrixOfCriterias:self.criterias] completion:^(NSArray *squaredMatrix, NSArray *eigenvector, float consistencyRatio, NSError *error) {
        if (consistencyRatio != consistencyRatio) {
            //Exception for NaN value of CI/RI division by zero
            [consistencyRatioLabel setText:@"CR Undefined"];
            [consistencyRatioLabel setTextColor:[UIColor greenColor]];
        } else {
            [consistencyRatioLabel setText:[NSString stringWithFormat:@"CR %.4f",consistencyRatio]];
            if (consistencyRatio < 0.1) {
                [consistencyRatioLabel setTextColor:[UIColor greenColor]];
            } else {
                [consistencyRatioLabel setTextColor:[UIColor redColor]];
            }
        }
    }];
}

#pragma mark - Private Methods

- (void)cancelButtonPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UI Table View Data Source Methods

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredComparisons.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ComparisonCellIdentifier = @"ComparisonCellIdentifier";
    UGMComparisonCell *cell = [tableView dequeueReusableCellWithIdentifier:ComparisonCellIdentifier];
    
    //if (!cell) {
        cell = [[UGMComparisonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ComparisonCellIdentifier];
    //}
    
    CriteriaComparison *theComparison = (CriteriaComparison *)[self.filteredComparisons objectAtIndex:indexPath.row];
    
    cell.prioritySlider.titleLabel.text = @"";
    cell.prioritySlider.firstItemLabel.text = theComparison.firstCriteria.name;
    cell.prioritySlider.secondItemLabel.text = theComparison.secondCriteria.name;
    
    
    float comparisonValue = [[theComparison value] floatValue];
    comparisonValue = comparisonValue >= 1 ? comparisonValue-1.0 : -1*([[[self reverseComparison:theComparison] value] floatValue]-1);
    //NSLog(@"comparisonValue %f",comparisonValue);
    cell.prioritySlider.value = comparisonValue;
    cell.prioritySlider.delegate = self;
    cell.prioritySlider.tag = indexPath.row;
    
    return cell;
}

#pragma mark - UGMPrioritySlider Delegate Methods

- (void)sliderViewID:(int)sliderID sliderValueChanged:(int)value{
    
    float normalFloatValue = 0.0;
    float reverseFloatValue = 0.0;
    
    if (value >= 0) {
        normalFloatValue = 1/(float)(value+1);
        reverseFloatValue = (float)(value+1);
    } else {
        normalFloatValue = (float)(abs(value)+1);
        reverseFloatValue = 1/(float)(abs(value)+1);
    }
    
    CriteriaComparison *theComparison = (CriteriaComparison *)[self.filteredComparisons objectAtIndex:sliderID];
    CriteriaComparison *reverseComparison = [self reverseComparison:theComparison];
    
    [theComparison setValue:[NSNumber numberWithFloat:normalFloatValue]];
    [reverseComparison setValue:[NSNumber numberWithFloat:reverseFloatValue]];
    
    [AHP AHPFromMatrix:[self matrixOfCriterias:self.criterias] completion:^(NSArray *squaredMatrix, NSArray *eigenvector, float consistencyRatio, NSError *error) {
        if (consistencyRatio != consistencyRatio) {
            //Exception for NaN value of CI/RI division by zero
            [consistencyRatioLabel setText:@"CR Undefined"];
            [consistencyRatioLabel setTextColor:[UIColor greenColor]];
        } else {
            [consistencyRatioLabel setText:[NSString stringWithFormat:@"CR %.4f",consistencyRatio]];
            if (consistencyRatio < 0.1) {
                [consistencyRatioLabel setTextColor:[UIColor greenColor]];
            } else {
                [consistencyRatioLabel setTextColor:[UIColor redColor]];
            }
        }
    }];
}

- (UGMPrioritySlider *)sliderWithSliderID:(int)sliderID{
    UGMComparisonCell *cell = (UGMComparisonCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sliderID inSection:0]];
    
    return (UGMPrioritySlider *)[cell viewWithTag:sliderID];
}

#pragma mark - matrix operations

- (NSArray *)matrixOfCriterias:(NSArray *)criterias{
    NSMutableArray *theMatrix = [[NSMutableArray alloc] init];
    
    for (Criteria *rowCriteria in criterias) {
        NSMutableArray *rowArray = [[NSMutableArray alloc] init];
        for (Criteria *columnCriteria in criterias) {
            CriteriaComparison *comparison = [self comparisonOfCriterias:@[rowCriteria,columnCriteria]];
            if (!comparison) {
                [rowArray addObject:[NSNumber numberWithFloat:1.0]];
            } else {
                [rowArray addObject:comparison.value];
            }
        }
        [theMatrix addObject:rowArray];
    }
    
    return [NSArray arrayWithArray:theMatrix];
}

- (CriteriaComparison *)comparisonOfCriterias:(NSArray *)criterias{
    Criteria *firstCriteria = [criterias firstObject];
    Criteria *lastCriteria = [criterias lastObject];
    NSPredicate *thePredicate;
    
    if (firstCriteria != lastCriteria) {
        thePredicate = [NSPredicate predicateWithFormat:@"(%@ IN criterias) AND (%@ IN criterias)",firstCriteria,lastCriteria];
    } else {
        thePredicate = [NSPredicate predicateWithFormat:@"ALL criterias == %@",firstCriteria];
    }
    
    NSArray *filteredArray = [self.comparisons filteredArrayUsingPredicate:thePredicate];
    for (CriteriaComparison *comparison in filteredArray) {
        if (comparison.firstCriteria == firstCriteria) {
            return comparison;
        }
    }
    
    return nil;
}

- (CriteriaComparison *)reverseComparison:(CriteriaComparison *)comparison{
    return [self comparisonOfCriterias:@[comparison.secondCriteria,comparison.firstCriteria]];
}

@end
