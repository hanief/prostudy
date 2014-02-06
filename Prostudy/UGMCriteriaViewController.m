//
//  UGMCriteriaViewController.m
//  Prostudy
//
//  Created by hanief on 1/9/13.
//  Copyright (c) 2013 Universitas Gadjah Mada. All rights reserved.
//

#import "UGMCriteriaViewController.h"
#import "Criteria.h"
#import "CriteriaComparison.h"
#import "UGMCriteriaDetailView.h"
#import "UGMAnalyticHierarchyProcess.h"
#import "UGMSubCriteriaViewController.h"
#import "UGMCriteriaComparisonViewController.h"

@interface UGMCriteriaViewController ()
@property UGMCriteriaDetailView *detailView;
@property UISegmentedControl *detailViewControl;
@property UGMAnalyticHierarchyProcess *AHP;

@end

@implementation UGMCriteriaViewController
@synthesize detailView, detailViewControl;
@synthesize AHP;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Criteria";
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"params"] style:UIBarButtonItemStylePlain target:self action:@selector(compareButtonPressed)]];
    
    NSArray *segmentedControls = [NSArray arrayWithObjects:@"Summary",@"Detail", nil];
    self.detailViewControl = [[UISegmentedControl alloc] initWithItems:segmentedControls];
    [self.detailViewControl addTarget:self action:@selector(detailControlChanged:) forControlEvents:UIControlEventValueChanged];
    [self.detailViewControl setSelectedSegmentIndex:0];
    [self.navigationItem setTitleView:self.detailViewControl];
    
    if (self.fetchedResultsController.fetchedObjects.count < 1) {
        [self loadDefaultCriteria];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (self.fetchedResultsController.fetchedObjects.count > 0) {
        NSArray *matrix = [self matrixOfCriterias:self.fetchedResultsController.fetchedObjects];
        
        if (!AHP) {
            AHP = [[UGMAnalyticHierarchyProcess alloc] init];
        }
        
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
    
    [detailViewControl setSelectedSegmentIndex:0];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Criteria"];
    request.predicate = [NSPredicate predicateWithFormat:@"parent == %@", nil];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"priority"
                                                              ascending:YES
                                                               selector:@selector(compare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

#pragma mark - Private Methods

- (void)loadDefaultCriteria{
    NSLog(@"No criterias found. Loading Default Criterias.");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"defaultCriteria" ofType:@"plist"];
    NSArray *contents = [[NSArray alloc] initWithContentsOfFile:path];
    NSMutableArray *criterias = [NSMutableArray array];
    
    for (NSDictionary *criteriaDic in contents) {
        Criteria *aCriteria = [NSEntityDescription insertNewObjectForEntityForName:@"Criteria" inManagedObjectContext:self.managedObjectContext];
        aCriteria.name = [criteriaDic valueForKey:@"title"];
        [criterias addObject:aCriteria];
        
        NSMutableArray *subCriterias = [NSMutableArray array];
        for (NSDictionary *subcriteriaDic in [criteriaDic valueForKey:@"childs"]) {
            Criteria *aSubCriteria = [NSEntityDescription insertNewObjectForEntityForName:@"Criteria" inManagedObjectContext:self.managedObjectContext];
            aSubCriteria.name = [subcriteriaDic valueForKey:@"title"];
            aSubCriteria.parent = aCriteria;
            [subCriterias addObject:aSubCriteria];
        }
        
        [self addComparisonsFromCriterias:subCriterias];
    }
    
    [self addComparisonsFromCriterias:criterias];
    
}

- (void)addComparisonsFromCriterias:(NSArray *)criterias{
    for (int rowIndex = 0; rowIndex < criterias.count; rowIndex++) {
        for (int columnIndex = 0; columnIndex < criterias.count; columnIndex++) {
            CriteriaComparison *comparison = [CriteriaComparison insertNewObjectInManagedObjectContext:self.managedObjectContext];
            comparison.value = [NSNumber numberWithFloat:1.0];
            [comparison addCriteriasObject:criterias[rowIndex]];
            [comparison addCriteriasObject:criterias[columnIndex]];
        }
    }
}

- (NSArray *)criteriasWithParentCriteria:(Criteria *)criteria{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Criteria"];
    request.predicate = [NSPredicate predicateWithFormat:@"parent == %@", criteria];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    NSError *error;
    return [self.managedObjectContext executeFetchRequest:request error:&error];
}

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

- (void)detailControlChanged:(UISegmentedControl*)sender{
    
    if (sender.selectedSegmentIndex == 0) {
        [UIView transitionFromView:self.detailView toView:self.tableView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
    } else {
        NSMutableArray *criteriaTitles = [[NSMutableArray alloc] init];
        NSMutableArray *criteriaNames = [[NSMutableArray alloc] init];
        NSMutableArray *criteriaComparisonMatrices = [[NSMutableArray alloc] init];
        NSMutableArray *criteriaComparisonSquaredMatrices = [[NSMutableArray alloc] init];
        NSMutableArray *criteriaEigenVectorMatrices = [[NSMutableArray alloc] init];
        NSMutableArray *criteriaConsistencyRatios = [[NSMutableArray alloc] init];
        
        NSArray *mainCriterias = self.fetchedResultsController.fetchedObjects;
        [criteriaTitles addObject:@"Main"];
        
        NSMutableArray *tempNames = [[NSMutableArray alloc] init];
        for (Criteria *criteria in mainCriterias) {
            [tempNames addObject:criteria.nameInitial];
        }
        
        [criteriaNames addObject:tempNames];
        
        NSArray *criteriaComparisonMatrix = [self matrixOfCriterias:mainCriterias];
        [criteriaComparisonMatrices addObject:criteriaComparisonMatrix];
        
        if (!AHP) AHP = [[UGMAnalyticHierarchyProcess alloc] init];
        
        [AHP AHPFromMatrix:criteriaComparisonMatrix completion:^(NSArray *squaredMatrix, NSArray *eigenvector, float consistencyRatio, NSError *error) {
            [criteriaComparisonSquaredMatrices addObject:squaredMatrix];
            [criteriaEigenVectorMatrices addObject:eigenvector];
            [criteriaConsistencyRatios addObject:[NSNumber numberWithFloat:consistencyRatio]];
        }];
        
        for (Criteria *aCriteria in mainCriterias) {
            
            NSArray *subCriterias = [self criteriasWithParentCriteria:aCriteria];
            [criteriaTitles addObject:aCriteria.name];
            
            NSMutableArray *tempNames = [[NSMutableArray alloc] init];
            for (Criteria *criteria in subCriterias){
                [tempNames addObject:criteria.nameInitial];
            }
                                       
            [criteriaNames addObject:tempNames];
            
            NSArray *subCriteriaComparisonMatrix = [self matrixOfCriterias:subCriterias];
            [criteriaComparisonMatrices addObject:subCriteriaComparisonMatrix];
            
            [AHP AHPFromMatrix:subCriteriaComparisonMatrix completion:^(NSArray *squaredMatrix, NSArray *eigenvector, float consistencyRatio, NSError *error) {
                [criteriaComparisonSquaredMatrices addObject:squaredMatrix];
                [criteriaEigenVectorMatrices addObject:eigenvector];
                [criteriaConsistencyRatios addObject:[NSNumber numberWithFloat:consistencyRatio]];
            }];
        }
        
        if (!self.detailView) {
            CGRect frame = CGRectMake(0, 0, self.view.width, self.view.height);
            self.detailView = [[UGMCriteriaDetailView alloc] initWithFrame:frame andCriterias:mainCriterias];
        }
        
        self.detailView.criteriaTitles = [NSArray arrayWithArray:criteriaTitles];
        self.detailView.criteriaNames = [NSArray arrayWithArray:criteriaNames];
        self.detailView.criteriaComparisonMatrices = [NSArray arrayWithArray:criteriaComparisonMatrices];
        self.detailView.criteriaComparisonSquaredMatrices = [NSArray arrayWithArray:criteriaComparisonSquaredMatrices];
        self.detailView.criteriaEigenVectorMatrices = [NSArray arrayWithArray:criteriaEigenVectorMatrices];
        self.detailView.criteriaConsistencyRatios = [NSArray arrayWithArray:criteriaConsistencyRatios];

        [self.detailView reloadView];
        
        [UIView transitionFromView:self.tableView toView:self.detailView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight completion:nil];
    }
    
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
    
    return comparisons;
}

#pragma mark - UI Table View Data Source Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:4];
    [formatter setMinimumFractionDigits:4];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];

    Criteria *criteria = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = criteria.name;
    cell.detailTextLabel.text = [formatter stringFromNumber:criteria.priority];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UGMSubCriteriaViewController *subCriteriaVC = [[UGMSubCriteriaViewController alloc] initWithParentCriteria:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    subCriteriaVC.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:subCriteriaVC animated:YES];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if ([alertView.message isEqualToString:@"Your comparison is not consistent."]) {
        if (buttonIndex == 1) {
            [self compareButtonPressed];
        }
    }
}
 
@end
