//
//  UGMProjectViewController.m
//  Prostudy
//
//  Created by hanief on 1/9/13.
//  Copyright (c) 2013 Universitas Gadjah Mada. All rights reserved.
//

#import "UGMProjectViewController.h"
#import "UGMProjectDetailViewController.h"
#import "UGMCompareViewController.h"
#import "Project.h"
#import "ProjectComparison.h"
#import "Criteria.h"
#import "UGMTripleTextCell.h"

@interface UGMProjectViewController ()
@property UISegmentedControl *detailViewControl;
@property NSMutableArray *comparisons;
@end

@implementation UGMProjectViewController
@synthesize detailViewControl;
@synthesize comparisons;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"params"] style:UIBarButtonItemStylePlain target:self action:@selector(compareButtonPressed)]];
    
    NSArray *segmentedControls = [NSArray arrayWithObjects:@"Summary",@"Detail", nil];
    self.detailViewControl = [[UISegmentedControl alloc] initWithItems:segmentedControls];
    [self.detailViewControl addTarget:self action:@selector(detailControlChanged:) forControlEvents:UIControlEventValueChanged];
    [self.detailViewControl setSelectedSegmentIndex:0];
    [self.navigationItem setTitleView:self.detailViewControl];
    
    self.comparisons = [[NSMutableArray alloc] initWithArray:[self getComparisons]];
    
    if (self.fetchedResultsController.fetchedObjects.count > 1 && self.comparisons.count < 1) {
        [self loadComparisons];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.detailViewControl setSelectedSegmentIndex:0];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Project"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"priority"
                                                              ascending:YES
                                                               selector:@selector(compare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

#pragma mark - Private Methods

- (void)addButtonPressed{
    UGMProjectDetailViewController *addProjectVC = [[UGMProjectDetailViewController alloc] initByAddingNewProject:YES];
    addProjectVC.managedObjectContext = self.managedObjectContext;
    addProjectVC.presentingVC = self;
    
    UINavigationController *addProjectNavC = [[UINavigationController alloc] initWithRootViewController:addProjectVC];
    addProjectNavC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self.navigationController presentViewController:addProjectNavC animated:YES completion:nil];
}

- (void)compareButtonPressed{
    if (self.fetchedResultsController.fetchedObjects.count > 1) {
        for (ProjectComparison *comparison in self.comparisons) {
            NSLog(@"comparisons : %@",comparison.criteria.name);
        }
        UGMCompareViewController *compareVC = [[UGMCompareViewController alloc] initWithProjects:self.fetchedResultsController.fetchedObjects andComparisons:comparisons];
        UINavigationController *compareNC = [[UINavigationController alloc] initWithRootViewController:compareVC];
        compareNC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [self.navigationController presentViewController:compareNC animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add more project" message:@"Please insert minimum two projects." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
    }
}

- (NSArray *)getComparisons{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ProjectComparison"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"criteria" ascending:YES selector:@selector(compare:)]];
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (ProjectComparison *comparison in results) {
        NSLog(@"criteria.name %@", comparison.criteria.name);
    }
    return results;
}

- (NSArray *)getCriteriasWithParentCriteria:(Criteria *)parent{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Criteria"];
    request.predicate = [NSPredicate predicateWithFormat:@"parent == %@", parent];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(compare:)]];
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (Criteria *criteria in results) {
        //NSLog(@"parent : criteria = %@ : %@", parent.name, criteria.name);
    }
    return results;
}

- (void)loadComparisons{
    if (self.fetchedResultsController.fetchedObjects.count > 1) {
        NSArray *projects = self.fetchedResultsController.fetchedObjects;
        NSArray *mainCriterias = [self getCriteriasWithParentCriteria:nil];
        
        for (Criteria *aCriteria in mainCriterias) {
            for (Criteria *aSubCriteria in [self getCriteriasWithParentCriteria:aCriteria]) {
                for (int rowIndex = 0; rowIndex < projects.count; rowIndex++) {
                    for (int columnIndex = 0; columnIndex < projects.count; columnIndex++) {
                        ProjectComparison *comparison = [ProjectComparison insertNewObjectInManagedObjectContext:self.managedObjectContext];
                        comparison.value = [NSNumber numberWithFloat:1.0];
                        comparison.criteria = aSubCriteria;
                        //NSLog(@"aSubCriteria.name %@",aSubCriteria.name);
                        [comparison addProjectsObject:projects[rowIndex]];
                        [comparison addProjectsObject:projects[columnIndex]];
                        [self.comparisons addObject:comparison];
                    }
                }
            }
        }
    }
    NSLog(@"load comparisons : %d", self.comparisons.count);
}

- (void)reloadComparisonsForProject:(Project *)project{
    if (self.fetchedResultsController.fetchedObjects.count > 1) {
        if (self.comparisons.count > 0) {
            NSArray *projects = self.fetchedResultsController.fetchedObjects;
            NSArray *mainCriterias = [self getCriteriasWithParentCriteria:nil];
            
            for (Criteria *aCriteria in mainCriterias) {
                for (Criteria *aSubCriteria in [self getCriteriasWithParentCriteria:aCriteria]) {
                    for (int rowIndex = 0; rowIndex < projects.count; rowIndex++) {
                        for (int columnIndex = 0; columnIndex < projects.count; columnIndex++) {
                            if (projects[rowIndex] == project || projects[columnIndex] == project) {
                                ProjectComparison *comparison = [ProjectComparison insertNewObjectInManagedObjectContext:self.managedObjectContext];
                                comparison.value = [NSNumber numberWithFloat:1.0];
                                comparison.criteria = aSubCriteria;
                                //NSLog(@"aSubCriteria.name %@",aSubCriteria.name);
                                [comparison addProjectsObject:projects[rowIndex]];
                                [comparison addProjectsObject:projects[columnIndex]];
                                [self.comparisons addObject:comparison];
                            }
                        }
                    }
                }
            }
        } else {
            [self loadComparisons];
        }
    }
    NSLog(@"reload comparisons : %d", self.comparisons.count);
}

- (NSMutableArray *)purgeNilComparisons:(NSMutableArray *)array{
    NSMutableArray *discardedItems = [NSMutableArray array];
    ProjectComparison *comparison;
    
    for (comparison in array) {
        if (comparison == nil)
            [discardedItems addObject:comparison];
    }
    
    [array removeObjectsInArray:discardedItems];
    
    return array;
}

#pragma mark - UI Table View Data Source Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"CellIdentifier";
    UGMTripleTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UGMTripleTextCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:4];
    [formatter setMinimumFractionDigits:4];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    
    Project *project = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = project.name;
    cell.detailTextLabel.text = project.location;
    cell.rightTextLabel.text = [formatter stringFromNumber:project.priority];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UI Table View Delegate Methods

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        NSMutableArray *purgedComparisons = [self purgeNilComparisons:self.comparisons];
        self.comparisons = purgedComparisons;
        NSLog(@"comparisons : %d", self.comparisons.count);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UGMProjectDetailViewController *projectDetailViewController = [[UGMProjectDetailViewController alloc] initByAddingNewProject:NO];
    projectDetailViewController.project = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UINavigationController *projectDetailNav = [[UINavigationController alloc] initWithRootViewController:projectDetailViewController];
    projectDetailNav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self.navigationController presentViewController:projectDetailNav animated:YES completion:nil];
}

#pragma mark - UISegmentedControl Methods

- (void)detailControlChanged:(UISegmentedControl *)sender{
    if (self.fetchedResultsController.fetchedObjects.count > 1) {
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add more project" message:@"Please insert minimum two projects." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
        [sender setSelectedSegmentIndex:0];
    }
}

@end
