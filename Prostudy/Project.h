//
//  Project.h
//  Prostudy
//
//  Created by Hanief Cahya on 30/01/14.
//  Copyright (c) 2014 Universitas Gadjah Mada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Parameter, ProjectComparison;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSSet *parameters;
@property (nonatomic, retain) NSSet *projectComparisons;

@property (nonatomic) BOOL lawCompanyEstPaper;
@property (nonatomic) BOOL lawTaxIDNumber;
@property (nonatomic) BOOL lawRegistrationLetter;
@property (nonatomic) BOOL lawWorkplacePermit;
@property (nonatomic) BOOL lawChamberRecommendation;
@property (nonatomic) BOOL lawLandCertificate;
@property (nonatomic) BOOL lawLandBuildingTax;
@property (nonatomic) BOOL lawNeighbourhoodRecommendation;
@property (nonatomic) BOOL lawInitiatorsID;

@property (nonatomic) NSInteger secMinRegionalSalary;
@property (nonatomic) NSInteger secAvgSalary;
@property (nonatomic) NSInteger secIncomePerCapita;
@property (nonatomic) NSInteger secNationalIncome;
@property (nonatomic, retain) NSString *secLocalCulture;

@property (nonatomic, retain) NSString * marketConsumerBehaviour;
@property (nonatomic, retain) NSString * marketConsumerHabit;
@property (nonatomic, retain) NSString * marketConsumerPreference;
@property (nonatomic, retain) NSString * marketPastDemandTrend;
@property (nonatomic) NSInteger  marketPopulationGrowth;
@property (nonatomic, retain) NSString * marketCompetitionStructure;
@property (nonatomic, retain) NSString * marketCompetitionStrategy;
@property (nonatomic, retain) NSString * marketExpansionPossibility;
@property (nonatomic, retain) NSString * marketSupplyTrend;
@property (nonatomic, retain) NSString * marketThreatNewEntrants;
@property (nonatomic, retain) NSString * marketThreatSubsProduct;
@property (nonatomic, retain) NSString * marketBuyerBargaining;
@property (nonatomic, retain) NSString * marketSupplierBargaining;
@property (nonatomic, retain) NSString * marketFirmsRivalry;
@property (nonatomic) NSInteger marketLeadershipCost;
@property (nonatomic, retain) NSString * marketDifferentiation;
@property (nonatomic, retain) NSString * marketFocus;
@property (nonatomic, retain) NSString * marketProductLifecycle;
@property (nonatomic, retain) NSString * marketMarketingMix;

@property (nonatomic) BOOL techWorkforceAvail;
@property (nonatomic) BOOL techTransportAvail;
@property (nonatomic) BOOL techTelecomAvail;
@property (nonatomic) BOOL techWaterAvail;
@property (nonatomic) BOOL techElectricityAvail;
@property (nonatomic) BOOL techMaterialAvail;
@property (nonatomic) NSInteger techTargetMarketDistance;
@property (nonatomic, retain) NSString * techClimateLandCondition;
@property (nonatomic) BOOL techFutureDevPossibility;
@property (nonatomic, retain) NSString * techGovtPolicy;
@property (nonatomic) NSInteger techBuildingCost;
@property (nonatomic, retain) NSString * techBuildingSecurity;
@property (nonatomic, retain) NSString * techBuildingComfort;
@property (nonatomic) NSInteger techBuildingRoom;
@property (nonatomic) BOOL techBuildingComm;
@property (nonatomic) BOOL techSupplierAvail;
@property (nonatomic) BOOL techSparepartAvail;
@property (nonatomic) NSInteger techMachineCapacity;
@property (nonatomic, retain) NSString * techMachineQuality;
@property (nonatomic) NSInteger techMachineUsageTime;
@property (nonatomic, retain) NSString * techWorkforceKnowledge;
@property (nonatomic) BOOL techMaterialProductionMatch;
@property (nonatomic, retain) NSString * techApplicationSuccess;
@property (nonatomic, retain) NSString * techNextGenAnticipation;
@property (nonatomic, retain) NSString * techLayoutCompatible;
@property (nonatomic) BOOL techLayoutOptimalRoom;
@property (nonatomic) BOOL techLayoutExpansionEase;
@property (nonatomic) BOOL techLayoutProductionCostMin;
@property (nonatomic) BOOL techLayoutWorkforceSafe;
@property (nonatomic, retain) NSString * techLayoutProcessTransition;
@property (nonatomic) BOOL techScaleMarketShareDev;
@property (nonatomic) NSInteger techScaleHRQuantity;
@property (nonatomic, retain) NSString * techScaleHRQuality;
@property (nonatomic, retain) NSString * techScaleFinancialStrength;
@property (nonatomic) BOOL techScaleTechChange;

@property (nonatomic, retain) NSString * managementWorkType;
@property (nonatomic, retain) NSString * managementWorkSequence;
@property (nonatomic, retain) NSString * managementTimeAndCost;
@property (nonatomic, retain) NSString * managementContractorQuality;
@property (nonatomic, retain) NSString * managementDeveloperQuality;
@property (nonatomic, retain) NSString * managementExecutorQuality;

@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addParametersObject:(Parameter *)value;
- (void)removeParametersObject:(Parameter *)value;
- (void)addParameters:(NSSet *)values;
- (void)removeParameters:(NSSet *)values;

- (void)addProjectComparisonsObject:(ProjectComparison *)value;
- (void)removeProjectComparisonsObject:(ProjectComparison *)value;
- (void)addProjectComparisons:(NSSet *)values;
- (void)removeProjectComparisons:(NSSet *)values;

+ (instancetype)insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)moc;

@end
