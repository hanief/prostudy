//
//  UGMSubCriteriaViewController.m
//  Prostudy
//
//  Created by Hanief Cahya on 14/01/14.
//  Copyright (c) 2014 Universitas Gadjah Mada. All rights reserved.
//

#import "UGMSubCriteriaViewController.h"
#import "Criteria.h"
#import "CriteriaComparison.h"
#import "UGMCriteriaComparisonViewController.h"
#import "UGMAnalyticHierarchyProcess.h"

@interface UGMSubCriteriaViewController ()
@property UGMAnalyticHierarchyProcess *AHP;
@property (nonatomic, retain) Criteria *parentCriteria;
@end

@implementation UGMSubCriteriaViewController
@synthesize AHP;

- (instancetype)initWithParentCriteria:(Criteria *)criteria{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        _parentCriteria = criteria;
    }
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"params"] style:UIBarButtonItemStylePlain target:self action:@selector(compareButtonPressed)]];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Criteria"];
    request.predicate = [NSPredicate predicateWithFormat:@"parent == %@", self.parentCriteria];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"priority"
                                                              ascending:YES
                                                               selector:@selector(compare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = self.parentCriteria.name;
    
    NSArray *matrix = [self matrixOfCriterias:self.fetchedResultsController.fetchedObjects];
    
    if (!AHP) AHP = [[UGMAnalyticHierarchyProcess alloc] init];
    
    [AHP AHPFromMatrix:matrix completion:^(NSArray *squaredMatrix, NSArray *eigenvector, float consistencyRatio, NSError *error) {
        for (int i = 0; i < self.fetchedResultsController.fetchedObjects.count; i++) {
            Criteria *criteria = [self.fetchedResultsController.fetchedObjects objectAtIndex:i];
            criteria.priority = [eigenvector objectAtIndex:i];
        }
        
        if (!(consistencyRatio < 0.1 || consistencyRatio != consistencyRatio)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Consistency Ratio = %.4f",consistencyRatio] message:@"Your comparison is not consistent." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try again", nil];
            [alert show];
        }
    }];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:4];
    [formatter setMinimumFractionDigits:4];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    
    Criteria *currentCriteria = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = currentCriteria.name;
    cell.detailTextLabel.text = [formatter stringFromNumber:currentCriteria.priority];
    
    return cell;
}

#pragma mark - Private Methods

- (void)compareButtonPressed{
    NSArray *resortedCriterias = [self.fetchedResultsController.fetchedObjects
                                  sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                                              ascending:YES
                                                                                               selector:@selector(localizedStandardCompare:)]]];
    
    UGMCriteriaComparisonViewController *criteriaComparisonViewController = [[UGMCriteriaComparisonViewController alloc] initWithCriterias:self.fetchedResultsController.fetchedObjects andComparisons:[self comparisonArrayFromCriterias:resortedCriterias]];
    
    UINavigationController *criteriaComparisonNav = [[UINavigationController alloc] initWithRootViewController:criteriaComparisonViewController];
    criteriaComparisonNav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self.navigationController presentViewController:criteriaComparisonNav animated:YES completion:nil];
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
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CriteriaComparison"];
    NSPredicate *thePredicate;
    
    if (firstCriteria != lastCriteria) {
        thePredicate = [NSPredicate predicateWithFormat:@"(%@ IN criterias) AND (%@ IN criterias)",firstCriteria,lastCriteria];
    } else {
        thePredicate = [NSPredicate predicateWithFormat:@"ALL criterias == %@",firstCriteria];
    }
    
    request.predicate = thePredicate;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"value" ascending:YES]];
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    for (CriteriaComparison *comparison in fetchedObjects) {
        if (comparison.criterias.firstObject == firstCriteria) {
            return comparison;
        }
    }
    
    return nil;
}

- (NSArray *)comparisonArrayFromCriterias:(NSArray *)criterias{
    NSMutableArray *comparisons = [NSMutableArray array];
    
    for (Criteria *rowCriteria in criterias) {
        for (Criteria *columnCriteria in criterias) {
            CriteriaComparison *aComparison = [self comparisonOfCriterias:@[rowCriteria,columnCriteria]];
            if (aComparison) {
                [comparisons addObject:aComparison];
            }
        }
    }
    NSLog(@"criterias.count : comparisons.count = %d : %d", criterias.count, comparisons.count);
    return comparisons;
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self compareButtonPressed];
    }
}

@end
