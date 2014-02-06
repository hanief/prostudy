//
//  UGMCompareViewController.m
//  Prostudy
//
//  Created by hanief on 1/9/13.
//  Copyright (c) 2013 Universitas Gadjah Mada. All rights reserved.
//

#import "UGMCompareViewController.h"
#import "Project.h"
#import "Parameter.h"
#import "Criteria.h"
#import "ProjectComparison.h"
#import "UGMComparisonView.h"
#import "UGMPrioritySlider.h"
#import "UGMComparisonCell.h"
#import "UGMProjectExplanationCell.h"
#import "UIView+Size.h"
#import "UIView+Positioning.h"

@interface UGMCompareViewController ()
@property NSMutableArray *titleArray;
@property NSMutableArray *leftExplanationArray;
@property NSMutableArray *rightExplanationArray;
@property NSInteger comparisonIndex;
@property NSArray *projects;
@property NSArray *comparisons;
@property NSArray *filteredComparisons;

@end

@implementation UGMCompareViewController
@synthesize titleArray, leftExplanationArray, rightExplanationArray, comparisonIndex;
@synthesize projects = _projects;
@synthesize comparisons = _comparisons;
@synthesize filteredComparisons = _filteredComparisons;

- (instancetype)initWithProjects:(NSArray *)projects andComparisons:(NSArray *)comparisons{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _projects = projects;
        _comparisons = comparisons;
        
        NSMutableArray *tempArray = [NSMutableArray array];
        int index = 0;
        for (ProjectComparison *aComparison in comparisons) {
            
            if (([projects indexOfObject:aComparison.firstProject] < [projects indexOfObject:aComparison.secondProject])) {
                NSLog(@"%d %@\n",index, aComparison.criteria.name);
                index++;
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
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed)]];
    //[self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)]];
    
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNextComparison)];
    [swipeLeftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPreviousComparison)];
    [swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.tableView addGestureRecognizer:swipeRightGesture];
    [self.tableView addGestureRecognizer:swipeLeftGesture];
    
    NSArray *segmentedControls = [NSArray arrayWithObjects:@"First",@"Prev",@"Next",@"Last", nil];
    UISegmentedControl *detailControl = [[UISegmentedControl alloc] initWithItems:segmentedControls];
    [detailControl addTarget:self action:@selector(detailControlChanged:) forControlEvents:UIControlEventValueChanged];
    [detailControl setMomentary:YES];
    
    [self.navigationController setToolbarHidden:NO];
    UIBarButtonItem *flexibleLeftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *previousBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStylePlain target:self action:@selector(gotoPreviousComparison)];
    UIBarButtonItem *nextBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(gotoNextComparison)];
    UIBarButtonItem *flexibleRightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self setToolbarItems:@[flexibleLeftBarButton,previousBarButton,nextBarButton,flexibleRightBarButton]];
    
    //[self.navigationItem setTitleView:detailControl];
    
    comparisonIndex = 0;
    [self processExplanationForComparison:[self.filteredComparisons objectAtIndex:comparisonIndex]];
}

#pragma mark - Private Methods

- (void)gotoPreviousComparison{
    if (comparisonIndex > 0) {
        comparisonIndex--;
    }
    
    [self processExplanationForComparison:[self.filteredComparisons objectAtIndex:comparisonIndex]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    
}

- (void)gotoNextComparison{
    if (comparisonIndex < self.filteredComparisons.count-1) {
        comparisonIndex++;
    }
    
    [self processExplanationForComparison:[self.filteredComparisons objectAtIndex:comparisonIndex]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)cancelButtonPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)detailControlChanged:(UISegmentedControl*)sender{
    UITableViewRowAnimation rowAnimation = UITableViewRowAnimationNone;
    
    if (sender.selectedSegmentIndex == 0) {
        if (comparisonIndex != 0) {
            comparisonIndex = 0;
            rowAnimation = UITableViewRowAnimationRight;
        }
    } else if (sender.selectedSegmentIndex == 1){
        if (comparisonIndex > 0) {
            comparisonIndex--;
            rowAnimation = UITableViewRowAnimationRight;
        }
    } else if (sender.selectedSegmentIndex == 2) {
        if (comparisonIndex < self.filteredComparisons.count-1) {
            comparisonIndex++;
            rowAnimation = UITableViewRowAnimationLeft;
        }
    } else {
        if (comparisonIndex != self.filteredComparisons.count-1) {
            comparisonIndex = self.filteredComparisons.count-1;
            rowAnimation = UITableViewRowAnimationLeft;
        }
    }
    
    [self processExplanationForComparison:[self.filteredComparisons objectAtIndex:comparisonIndex]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:rowAnimation];
}


#pragma mark - Data Processing Methods

- (void)processExplanationForComparison:(ProjectComparison *)comparison{
    titleArray = [[NSMutableArray alloc] init];
    leftExplanationArray = [[NSMutableArray alloc] init];
    rightExplanationArray = [[NSMutableArray alloc] init];

    NSArray *nameArray;
    NSArray *leftArray;
    NSArray *rightArray;
    /*
    Project *leftProject = comparison.firstProject;
    Project *rightProject = comparison.secondProject;
    
    if ([comparison.criteria.name isEqualToString:@"Location Permit"]) {
        nameArray = [NSArray arrayWithObjects:@"Land Cert",@"LandBuilding Tax",@"Neighbour Rec",@"Initiator ID", nil];
        leftArray = [NSArray arrayWithObjects:[NSNumber numberWithBool:leftProject.lawLandCertificate],leftProject.lawLandBuildingTax,leftProject.lawNeighbourhoodRecommendation,leftProject.lawInitiatorsID, nil];
        rightArray = [NSArray arrayWithObjects:rightProject.lawLandCertificate,rightProject.lawLandBuildingTax,rightProject.lawNeighbourhoodRecommendation,rightProject.lawInitiatorsID, nil];
    } else if ([comparison.criteria.name isEqualToString:@"Company Permit"]) {
        nameArray = [NSArray arrayWithObjects:@"Company Est Paper",@"Tax ID Number",@"Reg Letter",@"Workplace permit",@"Chamber Rec", nil];
        leftArray = [NSArray arrayWithObjects:leftProject.lawCompanyEstPaper,leftProject.lawTaxIDNumber,leftProject.lawRegistrationLetter,leftProject.lawWorkplacePermit,leftProject.lawChamberRecommendation, nil];
        rightArray = [NSArray arrayWithObjects:rightProject.lawCompanyEstPaper,rightProject.lawTaxIDNumber,rightProject.lawRegistrationLetter,rightProject.lawWorkplacePermit,rightProject.lawChamberRecommendation, nil];
    }
    
    switch (comparison.criteria.name) {
        case 2:
            nameArray = [NSArray arrayWithObjects:@"Company Est Paper",@"Tax ID Number",@"Reg Letter",@"Workplace permit",@"Chamber Rec", nil];
            leftArray = [NSArray arrayWithObjects:leftProject.lawCompanyEstPaper,leftProject.lawTaxIDNumber,leftProject.lawRegistrationLetter,leftProject.lawWorkplacePermit,leftProject.lawChamberRecommendation, nil];
            rightArray = [NSArray arrayWithObjects:rightProject.lawCompanyEstPaper,rightProject.lawTaxIDNumber,rightProject.lawRegistrationLetter,rightProject.lawWorkplacePermit,rightProject.lawChamberRecommendation, nil];
            break;
        case 3:
            nameArray = [NSArray arrayWithObjects:@"Land Cert",@"LandBuilding Tax",@"Neighbour Rec",@"Initiator ID", nil];
            leftArray = [NSArray arrayWithObjects:leftProject.lawLandCertificate,leftProject.lawLandBuildingTax,leftProject.lawNeighbourhoodRecommendation,leftProject.lawInitiatorsID, nil];
            rightArray = [NSArray arrayWithObjects:rightProject.lawLandCertificate,rightProject.lawLandBuildingTax,rightProject.lawNeighbourhoodRecommendation,rightProject.lawInitiatorsID, nil];
            break;
        case 5:
            nameArray = [NSArray arrayWithObjects:@"Min Salary",@"Avg Salary", nil];
            leftArray = [NSArray arrayWithObjects:leftProject.secMinRegionalSalary,leftProject.secAvgSalary, nil];
            rightArray = [NSArray arrayWithObjects:rightProject.secMinRegionalSalary,rightProject.secAvgSalary, nil];
            break;
        case 6:
            nameArray = [NSArray arrayWithObjects:@"Inc/Capita",@"Natl Inc", nil];
            leftArray = [NSArray arrayWithObjects:leftProject.secIncomePerCapita,leftProject.secNationalIncome, nil];
            rightArray = [NSArray arrayWithObjects:rightProject.secIncomePerCapita,rightProject.secNationalIncome, nil];
            break;
        case 7:
            nameArray = [NSArray arrayWithObjects:@"Local Culture", nil];
            leftArray = [NSArray arrayWithObjects:leftProject.secLocalCulture, nil];
            rightArray = [NSArray arrayWithObjects:rightProject.secLocalCulture, nil];
            break;
        case 9:
            nameArray = [NSArray arrayWithObjects:@"Cons Behav",@"Cons Habit",@"Cons Pref",@"Demand Trend",@"Pop Growth", nil];
            leftArray = [NSArray arrayWithObjects:leftProject.marketConsumerBehaviour,leftProject.marketConsumerHabit,leftProject.marketConsumerPreference,leftProject.marketPastDemandTrend,leftProject.marketPopulationGrowth, nil];
            rightArray = [NSArray arrayWithObjects:rightProject.marketConsumerBehaviour,rightProject.marketConsumerHabit,rightProject.marketConsumerPreference,rightProject.marketPastDemandTrend,rightProject.marketPopulationGrowth, nil];
            break;
        case 10:
            nameArray = [NSArray arrayWithObjects:@"Comp Struc",@"Comp Strat",@"Exp Possible",@"Supply Trend", nil];
            leftArray = [NSArray arrayWithObjects:leftProject.marketCompetitionStructure,leftProject.marketCompetitionStrategy,leftProject.marketExpansionPossibility,leftProject.marketSupplyTrend, nil];
            rightArray = [NSArray arrayWithObjects:rightProject.marketCompetitionStructure,rightProject.marketCompetitionStrategy,rightProject.marketExpansionPossibility,rightProject.marketSupplyTrend, nil];
            break;
        case 11:
            nameArray = [NSArray arrayWithObjects:@"New Entrants",@"Subs Product",@"Buyer Bargain",@"Supplier Bargain",@"Firms Rival",@"Lead Cost", nil];
            leftArray = [NSArray arrayWithObjects:leftProject.marketThreatNewEntrants,leftProject.marketThreatSubsProduct,leftProject.marketBuyerBargaining,leftProject.marketSupplierBargaining,leftProject.marketFirmsRivalry,leftProject.marketLeadershipCost, nil];
            rightArray = [NSArray arrayWithObjects:rightProject.marketThreatNewEntrants,rightProject.marketThreatSubsProduct,rightProject.marketBuyerBargaining,rightProject.marketSupplierBargaining,rightProject.marketFirmsRivalry,rightProject.marketLeadershipCost, nil];
            break;
        case 12:
            nameArray = [NSArray arrayWithObjects:@"Diff",@"Focus",@"Prod Lifecycle",@"Marketing Mix", nil];
            leftArray = [NSArray arrayWithObjects:leftProject.marketDifferentiation,leftProject.marketFocus,leftProject.marketProductLifecycle,leftProject.marketMarketingMix, nil];
            rightArray = [NSArray arrayWithObjects:rightProject.marketDifferentiation,rightProject.marketFocus,rightProject.marketProductLifecycle,rightProject.marketMarketingMix, nil];
            break;
        case 14:
            nameArray = [NSArray arrayWithObjects:@"Workforce Avail",@"Trans Avail",@"Telecom Avail",@"Water Avail",@"Electric Avail",@"Material Avail",@"Target Dist",@"Climate Land",@"Future Dev",@"Gov Policy", nil];
            leftArray = [NSArray arrayWithObjects:leftProject.techWorkforceAvail,leftProject.techTransportAvail,leftProject.techTelecomAvail,leftProject.techWaterAvail,leftProject.techElectricityAvail,leftProject.techMaterialAvail,leftProject.techTargetMarketDistance,leftProject.techClimateLandCondition,leftProject.techFutureDevPossibility,leftProject.techGovtPolicy, nil];
            rightArray = [NSArray arrayWithObjects:rightProject.techWorkforceAvail,rightProject.techTransportAvail,rightProject.techTelecomAvail,rightProject.techWaterAvail,rightProject.techElectricityAvail,rightProject.techMaterialAvail,rightProject.techTargetMarketDistance,rightProject.techClimateLandCondition,rightProject.techFutureDevPossibility,rightProject.techGovtPolicy, nil];
            break;
        case 15:
            nameArray = [NSArray arrayWithObjects:@"Building Cost",@"Building Secure",@"Building Comf",@"Building Room",@"Building Comm",@"Supplier Avail",@"Sparepart Avail", nil];
            leftArray = [NSArray arrayWithObjects:leftProject.techBuildingCost,leftProject.techBuildingSecurity,leftProject.techBuildingComfort,leftProject.techBuildingRoom,leftProject.techBuildingComm,leftProject.techSupplierAvail,leftProject.techSparepartAvail, nil];
            rightArray = [NSArray arrayWithObjects:rightProject.techBuildingCost,rightProject.techBuildingSecurity,rightProject.techBuildingComfort,rightProject.techBuildingRoom,rightProject.techBuildingComm,rightProject.techSupplierAvail,rightProject.techSparepartAvail,  nil];
            break;
        case 16:
            nameArray = [NSArray arrayWithObjects:@"Machine Cap",@"Machine Qual",@"Machine Use",@"Worker Know",@"Material Match",@"App Success",@"NextGen Anticipate", nil];
            leftArray = [NSArray arrayWithObjects:leftProject.techMachineCapacity,leftProject.techMachineQuality,leftProject.techMachineUsageTime,leftProject.techWorkforceKnowledge,leftProject.techMaterialProductionmatch,leftProject.techApplicationSuccess,leftProject.techNextGenAnticipation, nil];
            rightArray = [NSArray arrayWithObjects:rightProject.techMachineCapacity,rightProject.techMachineQuality,rightProject.techMachineUsageTime,rightProject.techWorkforceKnowledge,rightProject.techMaterialProductionmatch,rightProject.techApplicationSuccess,rightProject.techNextGenAnticipation, nil];
            break;
        case 17:
            nameArray = [NSArray arrayWithObjects:@"Layout Comp",@"Optimal Room",@"Expand Ease",@"Min Prod Cost",@"Worker Safe",@"Proc Trans", nil];
            leftArray = [NSArray arrayWithObjects:leftProject.techLayoutCompatible,leftProject.techLayoutOptimalRoom,leftProject.techLayoutExpansionEase,leftProject.techLayoutProductionCostMin,leftProject.techLayoutWorkforceSafe,leftProject.techLayoutProcessTransition, nil];
            rightArray = [NSArray arrayWithObjects:rightProject.techLayoutCompatible,rightProject.techLayoutOptimalRoom,rightProject.techLayoutExpansionEase,rightProject.techLayoutProductionCostMin,rightProject.techLayoutWorkforceSafe,rightProject.techLayoutProcessTransition, nil];
            break;
        case 18:
            nameArray = [NSArray arrayWithObjects:@"Market Share Dev",@"HR Quant",@"HR Qual",@"Fin Strength",@"Tech Change", nil];
            leftArray = [NSArray arrayWithObjects:leftProject.techScaleMarketShareDev,leftProject.techScaleHRQuantity,leftProject.techScaleHRQuality,leftProject.techScaleFinancialStrength,leftProject.techScaleTechChange, nil];
            rightArray = [NSArray arrayWithObjects:rightProject.techScaleMarketShareDev,rightProject.techScaleHRQuantity,rightProject.techScaleHRQuality,rightProject.techScaleFinancialStrength,rightProject.techScaleTechChange, nil];
            break;
        case 20:
            nameArray = [NSArray arrayWithObjects:@"Work Type",@"Work Seq",@"Time Cost", nil];
            leftArray = [NSArray arrayWithObjects:leftProject.managementWorkType,leftProject.managementWorkSequence,leftProject.managementTimeAndCost, nil];
            rightArray = [NSArray arrayWithObjects:rightProject.managementWorkType,rightProject.managementWorkSequence,rightProject.managementTimeAndCost, nil];
            break;
        case 21:
            nameArray = [NSArray arrayWithObjects:@"Contractor Qual",@"Developer Qual", nil];
            leftArray = [NSArray arrayWithObjects:leftProject.managementContractorQuality,leftProject.managementDeveloperQuality, nil];
            rightArray = [NSArray arrayWithObjects:rightProject.managementContractorQuality,rightProject.managementDeveloperQuality, nil];
            break;
        case 22:
            nameArray = [NSArray arrayWithObjects:@"Ops Management", nil];
            leftArray = [NSArray arrayWithObjects:leftProject.managementExecutorQuality, nil];
            rightArray = [NSArray arrayWithObjects:rightProject.managementExecutorQuality, nil];
            break;
        default:
            nameArray = [NSArray arrayWithObject:@"Default Value"];
            leftArray = [NSArray arrayWithObject:@"Default Value"];
            rightArray = [NSArray arrayWithObject:@"Default Value"];
            break;
    }
    */
    
    nameArray = [NSArray arrayWithObject:@"Default Value"];
    leftArray = [NSArray arrayWithObject:@"Default Value"];
    rightArray = [NSArray arrayWithObject:@"Default Value"];
    
    [titleArray addObjectsFromArray:nameArray];
    [leftExplanationArray addObjectsFromArray:leftArray];
    [rightExplanationArray addObjectsFromArray:rightArray];
}

#pragma mark - UITableView Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100.0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UGMComparisonView *comparisonView = [[UGMComparisonView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    ProjectComparison *comparison = (ProjectComparison *)[self.filteredComparisons objectAtIndex:comparisonIndex];
    
    comparisonView.prioritySlider.titleLabel.text = comparison.criteria.name;
    comparisonView.prioritySlider.firstItemLabel.text = comparison.firstProject.name;
    comparisonView.prioritySlider.secondItemLabel.text = comparison.secondProject.name;
    
    float comparisonValue = [[comparison value] floatValue];
    comparisonValue = comparisonValue >= 1 ? comparisonValue-1.0 : -1*([[[self reverseComparison:comparison] value] floatValue]-1);
    comparisonView.prioritySlider.value = comparisonValue;
    comparisonView.prioritySlider.delegate = self;
    comparisonView.prioritySlider.tag = comparisonIndex;
    
    return comparisonView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellIdentifier";
    UGMProjectExplanationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell) {
        cell = [[UGMProjectExplanationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *leftString;
    NSString *rightString;
    
    if (leftExplanationArray.count > indexPath.row) {
        if ([[leftExplanationArray objectAtIndex:indexPath.row] isKindOfClass:[NSNumber class]])
            leftString = [[leftExplanationArray objectAtIndex:indexPath.row] stringValue];
        else leftString = [leftExplanationArray objectAtIndex:indexPath.row];
    }
    
    if (rightExplanationArray.count > indexPath.row) {
        if ([[rightExplanationArray objectAtIndex:indexPath.row] isKindOfClass:[NSNumber class]])
            rightString = [[rightExplanationArray objectAtIndex:indexPath.row] stringValue];
        else rightString = [rightExplanationArray objectAtIndex:indexPath.row];
    }
    
    cell.nameLabel.text = [titleArray objectAtIndex:indexPath.row];
    cell.leftTextView.text = leftString;
    cell.rightTextView.text = rightString;

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
    
    ProjectComparison *theComparison = (ProjectComparison *)[self.filteredComparisons objectAtIndex:sliderID];
    ProjectComparison *reverseComparison = [self reverseComparison:theComparison];
    
    [theComparison setValue:[NSNumber numberWithFloat:normalFloatValue]];
    [reverseComparison setValue:[NSNumber numberWithFloat:reverseFloatValue]];
    
    [(ProjectComparison *)[self.comparisons objectAtIndex:sliderID] setValue:[NSNumber numberWithInt:value]];
}

#pragma mark - matrix operations


- (ProjectComparison *)comparisonOfProjects:(NSArray *)projects{
    Project *firstProject = [projects firstObject];
    Project *lastProject = [projects lastObject];
    NSPredicate *thePredicate;
    
    if (firstProject != lastProject) {
        thePredicate = [NSPredicate predicateWithFormat:@"(%@ IN projects) AND (%@ IN projects)",firstProject,lastProject];
    } else {
        thePredicate = [NSPredicate predicateWithFormat:@"ALL projects == %@",firstProject];
    }
    
    NSArray *filteredArray = [self.comparisons filteredArrayUsingPredicate:thePredicate];
    for (ProjectComparison *comparison in filteredArray) {
        if (comparison.firstProject == firstProject) {
            return comparison;
        }
    }
    
    return nil;
}

- (ProjectComparison *)reverseComparison:(ProjectComparison *)comparison{
    return [self comparisonOfProjects:@[comparison.secondProject,comparison.firstProject]];
}

@end
