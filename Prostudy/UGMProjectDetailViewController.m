//
//  UGMProjectDetailViewController.m
//  Prostudy
//
//  Created by hanief on 1/10/13.
//  Copyright (c) 2013 Universitas Gadjah Mada. All rights reserved.
//

#import "UGMProjectDetailViewController.h"
#import "FormKit.h"
#import "Project.h"
#import "BWLongTextViewController.h"

#define kParameter @"parameter"
#define kName @"name"
#define kTitle @"title"
#define kValue @"value"

@interface UGMProjectDetailViewController ()
@property (strong, nonatomic) NSMutableArray *entries;
@property (nonatomic) BOOL addNew;
@property (nonatomic, strong) FKFormModel *formModel;
@end

@implementation UGMProjectDetailViewController
@synthesize project = _project;
@synthesize entries;
@synthesize managedObjectContext;
@synthesize formModel;
@synthesize presentingVC;

- (instancetype)initByAddingNewProject:(BOOL)addNew{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        _addNew = addNew;
        self.title = self.addNew ? @"Add Project" : @"Project Detail";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed)]];
    
    if (self.addNew) {
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)]];
        self.project = [Project insertNewObjectInManagedObjectContext:managedObjectContext];
    }

    self.formModel = [FKFormModel formTableModelForTableView:self.tableView
                                        navigationController:self.navigationController];
    
    [FKFormMapping mappingForClass:[Project class] block:^(FKFormMapping *formMapping) {
        [formMapping sectionWithTitle:@"Project Identification" footer:@"Make sure all entry filled" identifier:@"info"];
        [formMapping mapAttribute:@"name" title:@"Name" type:FKFormAttributeMappingTypeText];
        [formMapping mapAttribute:@"location" title:@"Location" type:FKFormAttributeMappingTypeText];
        
        [formMapping sectionWithTitle:@"Law Parameters" identifier:@"lawParameter"];
        [formMapping mapAttribute:@"lawCompanyEstPaper" title:@"Company Est. Paper" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"lawTaxIDNumber" title:@"Tax ID Number (NPWP)" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"lawRegistrationLetter" title:@"Registration Letter" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"lawWorkplacePermit" title:@"Workplace permit" type:FKFormAttributeMappingTypeBoolean];
        
        [formMapping mapAttribute:@"lawChamberRecommendation" title:@"Trade Chamber Recom" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"lawLandCertificate" title:@"Land Certificate" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"lawLandBuildingTax" title:@"Land & Building Tax" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"lawNeighbourhoodRecommendation" title:@"Neighbourhood Recom" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"lawInitiatorsID" title:@"Initiator's ID" type:FKFormAttributeMappingTypeBoolean];
        
        [formMapping sectionWithTitle:@"Social, Economy, Culture Parameters" identifier:@"secParameter"];
        [formMapping mapAttribute:@"secMinRegionalSalary" title:@"Min Regional Salary" type:FKFormAttributeMappingTypeInteger keyboardType:UIKeyboardTypeNumberPad];
        [formMapping mapAttribute:@"secAvgSalary" title:@"Avg Local Salary" type:FKFormAttributeMappingTypeInteger keyboardType:UIKeyboardTypeNumberPad];
        [formMapping mapAttribute:@"secIncomePerCapita" title:@"Income Per Capita" type:FKFormAttributeMappingTypeInteger keyboardType:UIKeyboardTypeNumberPad];
        [formMapping mapAttribute:@"secNationalIncome" title:@"National Income" type:FKFormAttributeMappingTypeInteger keyboardType:UIKeyboardTypeNumberPad];
        [formMapping mapAttribute:@"secLocalCulture" title:@"Local Culture" type:FKFormAttributeMappingTypeBigText];
        
        [formMapping sectionWithTitle:@"Market Parameters" identifier:@"marketParameter"];
        [formMapping mapAttribute:@"marketConsumerBehaviour" title:@"Consumer Behaviour" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"marketConsumerHabit" title:@"Consumer Habit" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"marketConsumerPreference" title:@"Consumer Preference" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"marketPastDemandTrend" title:@"Past Demand Trend" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"marketPopulationGrowth" title:@"Population Growth" type:FKFormAttributeMappingTypeInteger keyboardType:UIKeyboardTypeNumberPad];
        [formMapping mapAttribute:@"marketCompetitionStructure" title:@"Competition Structure" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"marketCompetitionStrategy" title:@"Competition Strategy" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"marketExpansionPossibility" title:@"Expansion Possibility" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"marketSupplyTrend" title:@"Supply Trend" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"marketThreatNewEntrants" title:@"New Entrants Threat" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"marketThreatSubsProduct" title:@"Substitution Product Threat" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"marketBuyerBargaining" title:@"Buyer Bargaining" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"marketSupplierBargaining" title:@"Supplier Bargaining" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"marketFirmsRivalry" title:@"Firms Rivalry" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"marketLeadershipCost" title:@"Leadership Cost" type:FKFormAttributeMappingTypeInteger keyboardType:UIKeyboardTypeNumberPad];
        [formMapping mapAttribute:@"marketDifferentiation" title:@"Marketing Differentiation" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"marketFocus" title:@"Marketing Focus" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"marketProductLifecycle" title:@"Product Lifecycle" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"marketMarketingMix" title:@"Marketing Mix" type:FKFormAttributeMappingTypeBigText];
        
        [formMapping sectionWithTitle:@"Technical Parameters" identifier:@"techParameter"];
        [formMapping mapAttribute:@"techWorkforceAvail" title:@"Workforce Available" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"techTransportAvail" title:@"Transport Available" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"techTelecomAvail" title:@"Telecom Available" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"techWaterAvail" title:@"Water Available" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"techElectricityAvail" title:@"Electricity Available" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"techMaterialAvail" title:@"Material Available" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"techTargetMarketDistance" title:@"Target Market Distance" type:FKFormAttributeMappingTypeInteger keyboardType:UIKeyboardTypeNumberPad];
        [formMapping mapAttribute:@"techClimateLandCondition" title:@"Climate and Land Condition" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"techFutureDevPossibility" title:@"Future Dev Able" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"techGovtPolicy" title:@"Government Policy" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"techBuildingCost" title:@"Building Cost" type:FKFormAttributeMappingTypeInteger keyboardType:UIKeyboardTypeNumberPad];
        [formMapping mapAttribute:@"techBuildingSecurity" title:@"Building Security" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"techBuildingComfort" title:@"Building Comfort" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"techBuildingRoom" title:@"Building Room" type:FKFormAttributeMappingTypeInteger keyboardType:UIKeyboardTypeNumberPad];
        [formMapping mapAttribute:@"techBuildingComm" title:@"Building Comm" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"techSupplierAvail" title:@"Supplier Availability " type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"techSparepartAvail" title:@"Spare-part Availability" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"techMachineCapacity" title:@"Machine Capacity" type:FKFormAttributeMappingTypeInteger keyboardType:UIKeyboardTypeNumberPad];
        [formMapping mapAttribute:@"techMachineQuality" title:@"Machine Quality" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"techMachineUsageTime" title:@"Machine Usage Time" type:FKFormAttributeMappingTypeInteger keyboardType:UIKeyboardTypeNumberPad];
        [formMapping mapAttribute:@"techWorkforceKnowledge" title:@"Workforce knowledge" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"techMaterialProductionMatch" title:@"Matching Material" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"techApplicationSuccess" title:@"Application Success Story" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"techNextGenAnticipation" title:@"Next Gen Tech Anticipation" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"techLayoutCompatible" title:@"Layout Compatible" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"techLayoutOptimalRoom" title:@"Layout Room Optimal" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"techLayoutExpansionEase" title:@"Layout Ease Expansion" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"techLayoutProductionCostMin" title:@"Min Prod Cost" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"techLayoutWorkforceSafe" title:@"Workforce Safe" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"techLayoutProcessTransition" title:@"Process Transition" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"techScaleMarketShareDev" title:@"Market Share Dev" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"techScaleHRQuantity" title:@"Human Resource Quantity" type:FKFormAttributeMappingTypeInteger keyboardType:UIKeyboardTypeNumberPad];
        [formMapping mapAttribute:@"techScaleHRQuality" title:@"Human Resource Quality" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"techScaleFinancialStrength" title:@"Financial Strength" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"techScaleTechChange" title:@"Technology Change" type:FKFormAttributeMappingTypeBoolean];
        
        [formMapping sectionWithTitle:@"Management Parameters" identifier:@"managementParameter"];
        [formMapping mapAttribute:@"managementWorkType" title:@"Work Type" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"managementWorkSequence" title:@"Work Sequence" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"managementTimeAndCost" title:@"Time and Cost" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"managementContractorQuality" title:@"Contractor Quality" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"managementDeveloperQuality" title:@"Developer Quality" type:FKFormAttributeMappingTypeBigText];
        [formMapping mapAttribute:@"managementExecutorQuality" title:@"Executor Quality" type:FKFormAttributeMappingTypeBigText];
        
        [formMapping validationForAttribute:@"name" validBlock:^BOOL(NSString *value, id object) {
            return value.length > 0;
            
        } errorMessageBlock:^NSString *(id value, id object) {
            return @"Please enter a project name.";
        }];
        
        [formMapping validationForAttribute:@"location" validBlock:^BOOL(NSString *value, id object) {
            return value.length > 0;
            
        } errorMessageBlock:^NSString *(id value, id object) {
            return @"Please enter a project location.";
        }];
        
        [self.formModel registerMapping:formMapping];
    }];
    
    
    [self.formModel setDidChangeValueWithBlock:^(id object, id value, NSString *keyPath) {

    }];
    
    [self.formModel loadFieldsWithObject:self.project];
    
}

#pragma mark - Private Methods

- (void)cancelButtonPressed{
    if (self.addNew) {
        [self.managedObjectContext deleteObject:self.project];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonPressed{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.addNew) {
            [self.presentingVC reloadComparisonsForProject:self.project];
        }
    }];
}
@end
