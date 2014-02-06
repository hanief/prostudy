//
//  Project.m
//  Prostudy
//
//  Created by Hanief Cahya on 30/01/14.
//  Copyright (c) 2014 Universitas Gadjah Mada. All rights reserved.
//

#import "Project.h"
#import "Parameter.h"
#import "ProjectComparison.h"

@implementation Project

@dynamic location;
@dynamic name;
@dynamic priority;
@dynamic parameters;
@dynamic projectComparisons;

+ (NSString *)entityName
{
    return @"Project";
}

+ (instancetype)insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)moc;
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                         inManagedObjectContext:moc];
}

- (Parameter *)getParameter:(NSString *)parameter{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type contains %@",parameter];
    NSSet *filteredSet = [self.parameters filteredSetUsingPredicate:predicate];
    return (Parameter *)[filteredSet anyObject];
}

#pragma mark - Boolean Value

- (BOOL)getBooleanValue:(NSString *)parameter{
    return [[self getParameter:parameter].value isEqualToString:@"YES"];
}
- (void)setBooleanValue:(BOOL)value toProperty:(NSString *)propertyName{
    if (![self getParameter:propertyName]) {
        Parameter *aParameter = [NSEntityDescription insertNewObjectForEntityForName:@"Parameter"
                                                              inManagedObjectContext:self.managedObjectContext];
        aParameter.type = propertyName;
        aParameter.value = value ? @"YES" : @"NO";
        
        [self addParametersObject:aParameter];
    } else {
        [self getParameter:propertyName].value = value ? @"YES" : @"NO";
    }
}

#pragma mark - Integer Value

- (NSInteger)getIntegerValueOfParameter:(NSString *)parameter{
    return [[self getParameter:parameter].value integerValue];
}

- (void)setIntegerValue:(NSInteger)value toProperty:(NSString *)propertyName{
    if (![self getParameter:propertyName]) {
        Parameter *aParameter = [NSEntityDescription insertNewObjectForEntityForName:@"Parameter"
                                                              inManagedObjectContext:self.managedObjectContext];
        aParameter.type = propertyName;
        aParameter.value = [NSString stringWithFormat:@"%d",value];
        
        [self addParametersObject:aParameter];
    } else {
        [self getParameter:propertyName].value = [NSString stringWithFormat:@"%d",value];
    }
}

#pragma mark - String Value

- (NSString *)getStringValueOfParameter:(NSString *)parameter{
    return [self getParameter:parameter].value;
}

- (void)setStringValue:(NSString *)value toProperty:(NSString *)propertyName{
    if (![self getParameter:propertyName]) {
        Parameter *aParameter = [NSEntityDescription insertNewObjectForEntityForName:@"Parameter"
                                                              inManagedObjectContext:self.managedObjectContext];
        aParameter.type = propertyName;
        aParameter.value = value;
        
        [self addParametersObject:aParameter];
    } else {
        [self getParameter:propertyName].value = value;
    }
}

#pragma mark - Law Parameter

- (BOOL)lawCompanyEstPaper{
    return [self getBooleanValue:@"lawCompanyEstPaper"];
}

- (void)setLawCompanyEstPaper:(BOOL)lawCompanyEstPaper{
    [self setBooleanValue:lawCompanyEstPaper toProperty:@"lawCompanyEstPaper"];
}

- (BOOL)lawTaxIDNumber{
    return [self getBooleanValue:@"lawTaxIDNumber"];
}

- (void)setLawTaxIDNumber:(BOOL)lawTaxIDNumber{
    [self setBooleanValue:lawTaxIDNumber toProperty:@"lawTaxIDNumber"];
}

- (BOOL)lawRegistrationLetter{
    return [self getBooleanValue:@"lawRegistrationLetter"];
}

- (void)setLawRegistrationLetter:(BOOL)lawRegistrationLetter{
    [self setBooleanValue:lawRegistrationLetter toProperty:@"lawRegistrationLetter"];
}

- (BOOL)lawWorkplacePermit{
    return [self getBooleanValue:@"lawWorkplacePermit"];
}

- (void)setLawWorkplacePermit:(BOOL)lawWorkplacePermit{
    [self setBooleanValue:lawWorkplacePermit toProperty:@"lawWorkplacePermit"];
}

- (BOOL)lawChamberRecommendation{
    return [self getBooleanValue:@"lawChamberRecommendation"];
}

- (void)setLawChamberRecommendation:(BOOL)lawChamberRecommendation{
    [self setBooleanValue:lawChamberRecommendation toProperty:@"lawChamberRecommendation"];
}

- (BOOL)lawLandCertificate{
    return [self getBooleanValue:@"lawLandCertificate"];
}

- (void)setLawLandCertificate:(BOOL)lawLandCertificate{
    [self setBooleanValue:lawLandCertificate toProperty:@"lawLandCertificate"];
}

- (BOOL)lawLandBuildingTax{
    return [self getBooleanValue:@"lawLandBuildingTax"];
}

- (void)setLawLandBuildingTax:(BOOL)lawLandBuildingTax{
    [self setBooleanValue:lawLandBuildingTax toProperty:@"lawLandBuildingTax"];
}

- (BOOL)lawNeighbourhoodRecommendation{
    return [self getBooleanValue:@"lawNeighbourhoodRecommendation"];
}

- (void)setLawNeighbourhoodRecommendation:(BOOL)lawNeighbourhoodRecommendation{
    [self setBooleanValue:lawNeighbourhoodRecommendation toProperty:@"lawNeighbourhoodRecommendation"];
}

- (BOOL)lawInitiatorsID{
    return [self getBooleanValue:@"lawInitiatorsID"];
}

- (void)setLawInitiatorsID:(BOOL)lawInitiatorsID{
    [self setBooleanValue:lawInitiatorsID toProperty:@"lawInitiatorsID"];
}

#pragma mark - SEC Parameter

- (NSInteger)secMinRegionalSalary{
    return [self getIntegerValueOfParameter:@"secMinRegionalSalary"];
}

- (void)setSecMinRegionalSalary:(NSInteger)secMinRegionalSalary{
    [self setIntegerValue:secMinRegionalSalary toProperty:@"secMinRegionalSalary"];
}

- (NSInteger)secAvgSalary{
    return [self getIntegerValueOfParameter:@"secAvgSalary"];
}

- (void)setSecAvgSalary:(NSInteger)secAvgSalary{
    [self setIntegerValue:secAvgSalary toProperty:@"secAvgSalary"];
}

- (NSInteger)secIncomePerCapita{
    return [self getIntegerValueOfParameter:@"secIncomePerCapita"];
}

- (void)setSecIncomePerCapita:(NSInteger)secIncomePerCapita{
    [self setIntegerValue:secIncomePerCapita toProperty:@"secIncomePerCapita"];
}

- (NSInteger)secNationalIncome{
    return [self getIntegerValueOfParameter:@"secNationalIncome"];
}

- (void)setSecNationalIncome:(NSInteger)secNationalIncome{
    [self setIntegerValue:secNationalIncome toProperty:@"secNationalIncome"];
}

- (NSString *)secLocalCulture{
    return [self getStringValueOfParameter:@"secLocalCulture"];
}

- (void)setSecLocalCulture:(NSString *)secLocalCulture{
    [self setStringValue:secLocalCulture toProperty:@"secLocalCulture"];
}

#pragma mark - Market Parameter

- (NSString *)marketConsumerBehaviour{
    return [self getStringValueOfParameter:@"marketConsumerBehaviour"];
}

- (void)setMarketConsumerBehaviour:(NSString *)marketConsumerBehaviour{
    [self setStringValue:marketConsumerBehaviour toProperty:@"marketConsumerBehaviour"];
}

- (NSString *)marketConsumerHabit{
    return [self getStringValueOfParameter:@"marketConsumerHabit"];
}

- (void)setMarketConsumerHabit:(NSString *)marketConsumerHabit{
    [self setStringValue:marketConsumerHabit toProperty:@"marketConsumerHabit"];
}

- (NSString *)marketConsumerPreference{
    return [self getStringValueOfParameter:@"marketConsumerPreference"];
}

- (void)setMarketConsumerPreference:(NSString *)marketConsumerPreference{
    [self setStringValue:marketConsumerPreference toProperty:@"marketConsumerPreference"];
}

- (NSString *)marketPastDemandTrend{
    return [self getStringValueOfParameter:@"marketPastDemandTrend"];
}

- (void)setMarketPastDemandTrend:(NSString *)marketPastDemandTrend{
    [self setStringValue:marketPastDemandTrend toProperty:@"marketPastDemandTrend"];
}

- (NSInteger)marketPopulationGrowth{
    return [self getIntegerValueOfParameter:@"marketPopulationGrowth"];
}

- (void)setMarketPopulationGrowth:(NSInteger)marketPopulationGrowth{
    [self setIntegerValue:marketPopulationGrowth toProperty:@"marketPopulationGrowth"];
}

- (NSString *)marketCompetitionStructure{
    return [self getStringValueOfParameter:@"marketCompetitionStructure"];
}

- (void)setMarketCompetitionStructure:(NSString *)marketCompetitionStructure{
    [self setStringValue:marketCompetitionStructure toProperty:@"marketCompetitionStructure"];
}

- (NSString *)marketCompetitionStrategy{
    return [self getStringValueOfParameter:@"marketCompetitionStrategy"];
}

- (void)setMarketCompetitionStrategy:(NSString *)marketCompetitionStrategy{
    [self setStringValue:marketCompetitionStrategy toProperty:@"marketCompetitionStrategy"];
}

- (NSString *)marketExpansionPossibility{
    return [self getStringValueOfParameter:@"marketExpansionPossibility"];
}

- (void)setMarketExpansionPossibility:(NSString *)marketExpansionPossibility{
    [self setStringValue:marketExpansionPossibility toProperty:@"marketExpansionPossibility"];
}

- (NSString *)marketSupplyTrend{
    return [self getStringValueOfParameter:@"marketSupplyTrend"];
}

- (void)setMarketSupplyTrend:(NSString *)marketSupplyTrend{
    [self setStringValue:marketSupplyTrend toProperty:@"marketSupplyTrend"];
}

- (NSString *)marketThreatNewEntrants{
    return [self getStringValueOfParameter:@"marketThreatNewEntrants"];
}

- (void)setMarketThreatNewEntrants:(NSString *)marketThreatNewEntrants{
    [self setStringValue:marketThreatNewEntrants toProperty:@"marketThreatNewEntrants"];
}

- (NSString *)marketThreatSubsProduct{
    return [self getStringValueOfParameter:@"marketThreatSubsProduct"];
}

- (void)setMarketThreatSubsProduct:(NSString *)marketThreatSubsProduct{
    [self setStringValue:marketThreatSubsProduct toProperty:@"marketThreatSubsProduct"];
}

- (NSString *)marketBuyerBargaining{
    return [self getStringValueOfParameter:@"marketBuyerBargaining"];
}

- (void)setMarketBuyerBargaining:(NSString *)marketBuyerBargaining{
    [self setStringValue:marketBuyerBargaining toProperty:@"marketBuyerBargaining"];
}

- (NSString *)marketSupplierBargaining{
    return [self getStringValueOfParameter:@"marketSupplierBargaining"];
}

- (void)setMarketSupplierBargaining:(NSString *)marketSupplierBargaining{
    [self setStringValue:marketSupplierBargaining toProperty:@"marketSupplierBargaining"];
}

- (NSString *)marketFirmsRivalry{
    return [self getStringValueOfParameter:@"marketFirmsRivalry"];
}

- (void)setMarketFirmsRivalry:(NSString *)marketFirmsRivalry{
    [self setStringValue:marketFirmsRivalry toProperty:@"marketFirmsRivalry"];
}

- (NSInteger)marketLeadershipCost{
    return [self getIntegerValueOfParameter:@"marketLeadershipCost"];
}

- (void)setMarketLeadershipCost:(NSInteger)marketLeadershipCost{
    [self setIntegerValue:marketLeadershipCost toProperty:@"marketLeadershipCost"];
}

- (NSString *)marketDifferentiation{
    return [self getStringValueOfParameter:@"marketDifferentiation"];
}

- (void)setMarketDifferentiation:(NSString *)marketDifferentiation{
    [self setStringValue:marketDifferentiation toProperty:@"marketDifferentiation"];
}

- (NSString *)marketFocus{
    return [self getStringValueOfParameter:@"marketFocus"];
}

- (void)setMarketFocus:(NSString *)marketFocus{
    [self setStringValue:marketFocus toProperty:@"marketFocus"];
}

- (NSString *)marketProductLifecycle{
    return [self getStringValueOfParameter:@"marketProductLifecycle"];
}

- (void)setMarketProductLifecycle:(NSString *)marketProductLifecycle{
    [self setStringValue:marketProductLifecycle toProperty:@"marketProductLifecycle"];
}

- (NSString *)marketMarketingMix{
    return [self getStringValueOfParameter:@"marketMarketingMix"];
}

- (void)setMarketMarketingMix:(NSString *)marketMarketingMix{
    [self setStringValue:marketMarketingMix toProperty:@"marketMarketingMix"];
}

#pragma mark - Technical Parameter

- (BOOL)techWorkforceAvail{
    return [self getBooleanValue:@"techWorkforceAvail"];
}

- (void)setTechWorkforceAvail:(BOOL)techWorkforceAvail{
    [self setBooleanValue:techWorkforceAvail toProperty:@"techWorkforceAvail"];
}

- (BOOL)techTransportAvail{
    return [self getBooleanValue:@"techTransportAvail"];
}

- (void)setTechTransportAvail:(BOOL)techTransportAvail{
    [self setBooleanValue:techTransportAvail toProperty:@"techTransportAvail"];
}

- (BOOL)techTelecomAvail{
    return [self getBooleanValue:@"techTelecomAvail"];
}

- (void)setTechTelecomAvail:(BOOL)techTelecomAvail{
    [self setBooleanValue:techTelecomAvail toProperty:@"techTelecomAvail"];
}

- (BOOL)techWaterAvail{
    return [self getBooleanValue:@"techWaterAvail"];
}

- (void)setTechWaterAvail:(BOOL)techWaterAvail{
    [self setBooleanValue:techWaterAvail toProperty:@"techWaterAvail"];
}

- (BOOL)techElectricityAvail{
    return [self getBooleanValue:@"techElectricityAvail"];
}

- (void)setTechElectricityAvail:(BOOL)techElectricityAvail{
    [self setBooleanValue:techElectricityAvail toProperty:@"techElectricityAvail"];
}

- (BOOL)techMaterialAvail{
    return [self getBooleanValue:@"techWorkforceAvail"];
}

- (void)setTechMaterialAvail:(BOOL)techMaterialAvail{
    [self setBooleanValue:techMaterialAvail toProperty:@"techMaterialAvail"];
}

- (NSInteger)techTargetMarketDistance{
    return [self getIntegerValueOfParameter:@"techTargetMarketDistance"];
}

- (void)setTechTargetMarketDistance:(NSInteger)techTargetMarketDistance{
    [self setIntegerValue:techTargetMarketDistance toProperty:@"techTargetMarketDistance"];
}

- (NSString *)techClimateLandCondition{
    return [self getStringValueOfParameter:@"techClimateLandCondition"];
}

- (void)setTechClimateLandCondition:(NSString *)techClimateLandCondition{
    [self setStringValue:techClimateLandCondition toProperty:@"techClimateLandCondition"];
}

- (BOOL)techFutureDevPossibility{
    return [self getBooleanValue:@"techFutureDevPossibility"];
}

- (void)setTechFutureDevPossibility:(BOOL)techFutureDevPossibility{
    [self setBooleanValue:techFutureDevPossibility toProperty:@"techFutureDevPossibility"];
}

- (NSString *)techGovtPolicy{
    return [self getStringValueOfParameter:@"techGovtPolicy"];
}

- (void)setTechGovtPolicy:(NSString *)techGovtPolicy{
    [self setStringValue:techGovtPolicy toProperty:@"techGovtPolicy"];
}

- (NSInteger)techBuildingCost{
    return [self getIntegerValueOfParameter:@"techBuildingCost"];
}

- (void)setTechBuildingCost:(NSInteger)techBuildingCost{
    [self setIntegerValue:techBuildingCost toProperty:@"techBuildingCost"];
}

- (NSString *)techBuildingSecurity{
    return [self getStringValueOfParameter:@"techBuildingSecurity"];
}

- (void)setTechBuildingSecurity:(NSString *)techBuildingSecurity{
    [self setStringValue:techBuildingSecurity toProperty:@"techBuildingSecurity"];
}

- (NSString *)techBuildingComfort{
    return [self getStringValueOfParameter:@"techBuildingComfort"];
}

- (void)setTechBuildingComfort:(NSString *)techBuildingComfort{
    [self setStringValue:techBuildingComfort toProperty:@"techBuildingComfort"];
}

- (NSInteger)techBuildingRoom{
    return [self getIntegerValueOfParameter:@"techBuildingRoom"];
}

- (void)setTechBuildingRoom:(NSInteger)techBuildingRoom{
    [self setIntegerValue:techBuildingRoom toProperty:@"techBuildingRoom"];
}

- (BOOL)techBuildingComm{
    return [self getBooleanValue:@"techBuildingComm"];
}

- (void)setTechBuildingComm:(BOOL)techBuildingComm{
    [self setBooleanValue:techBuildingComm toProperty:@"techBuildingComm"];
}

- (BOOL)techSupplierAvail{
    return [self getBooleanValue:@"techSupplierAvail"];
}

- (void)setTechSupplierAvail:(BOOL)techSupplierAvail{
    [self setBooleanValue:techSupplierAvail toProperty:@"techSupplierAvail"];
}

- (BOOL)techSparepartAvail{
    return [self getBooleanValue:@"techSparepartAvail"];
}

- (void)setTechSparepartAvail:(BOOL)techSparepartAvail{
    [self setBooleanValue:techSparepartAvail toProperty:@"techSparepartAvail"];
}

- (NSInteger)techMachineCapacity{
    return [self getIntegerValueOfParameter:@"techMachineCapacity"];
}

- (void)setTechMachineCapacity:(NSInteger)techMachineCapacity{
    [self setIntegerValue:techMachineCapacity toProperty:@"techMachineCapacity"];
}

- (NSString *)techMachineQuality{
    return [self getStringValueOfParameter:@"techMachineQuality"];
}

- (void)setTechMachineQuality:(NSString *)techMachineQuality{
    [self setStringValue:techMachineQuality toProperty:@"techMachineQuality"];
}

- (NSInteger)techMachineUsageTime{
    return [self getIntegerValueOfParameter:@"techMachineUsageTime"];
}

- (void)setTechMachineUsageTime:(NSInteger)techMachineUsageTime{
    [self setIntegerValue:techMachineUsageTime toProperty:@"techMachineUsageTime"];
}

- (NSString *)techWorkforceKnowledge{
    return [self getStringValueOfParameter:@"techWorkforceKnowledge"];
}

- (void)setTechWorkforceKnowledge:(NSString *)techWorkforceKnowledge{
    [self setStringValue:techWorkforceKnowledge toProperty:@"techWorkforceKnowledge"];
}

- (BOOL)techMaterialProductionMatch{
    return [self getBooleanValue:@"techMaterialProductionMatch"];
}

- (void)setTechMaterialProductionMatch:(BOOL)techMaterialProductionMatch{
    [self setBooleanValue:techMaterialProductionMatch toProperty:@"techMaterialProductionMatch"];
}

- (NSString *)techApplicationSuccess{
    return [self getStringValueOfParameter:@"techApplicationSuccess"];
}

- (void)setTechApplicationSuccess:(NSString *)techApplicationSuccess{
    [self setStringValue:techApplicationSuccess toProperty:@"techApplicationSuccess"];
}

- (NSString *)techNextGenAnticipation{
    return [self getStringValueOfParameter:@"techNextGenAnticipation"];
}

- (void)setTechNextGenAnticipation:(NSString *)techNextGenAnticipation{
    [self setStringValue:techNextGenAnticipation toProperty:@"techNextGenAnticipation"];
}

- (NSString *)techLayoutCompatible{
    return [self getStringValueOfParameter:@"techLayoutCompatible"];
}

- (void)setTechLayoutCompatible:(NSString *)techLayoutCompatible{
    [self setStringValue:techLayoutCompatible toProperty:@"techLayoutCompatible"];
}

- (BOOL)techLayoutOptimalRoom{
    return [self getBooleanValue:@"techLayoutOptimalRoom"];
}

- (void)setTechLayoutOptimalRoom:(BOOL)techLayoutOptimalRoom{
    [self setBooleanValue:techLayoutOptimalRoom toProperty:@"techLayoutOptimalRoom"];
}

- (BOOL)techLayoutExpansionEase{
    return [self getBooleanValue:@"techLayoutExpansionEase"];
}

- (void)setTechLayoutExpansionEase:(BOOL)techLayoutExpansionEase{
    [self setBooleanValue:techLayoutExpansionEase toProperty:@"techLayoutExpansionEase"];
}

- (BOOL)techLayoutProductionCostMin{
    return [self getBooleanValue:@"techLayoutProductionCostMin"];
}

- (void)setTechLayoutProductionCostMin:(BOOL)techLayoutProductionCostMin{
    [self setBooleanValue:techLayoutProductionCostMin toProperty:@"techLayoutProductionCostMin"];
}

- (BOOL)techLayoutWorkforceSafe{
    return [self getBooleanValue:@"techLayoutWorkforceSafe"];
}

- (void)setTechLayoutWorkforceSafe:(BOOL)techLayoutWorkforceSafe{
    [self setBooleanValue:techLayoutWorkforceSafe toProperty:@"techLayoutWorkforceSafe"];
}

- (NSString *)techLayoutProcessTransition{
    return [self getStringValueOfParameter:@"techLayoutProcessTransition"];
}

- (void)setTechLayoutProcessTransition:(NSString *)techLayoutProcessTransition{
    [self setStringValue:techLayoutProcessTransition toProperty:@"techLayoutProcessTransition"];
}

- (BOOL)techScaleMarketShareDev{
    return [self getBooleanValue:@"techScaleMarketShareDev"];
}

- (void)setTechScaleMarketShareDev:(BOOL)techScaleMarketShareDev{
    [self setBooleanValue:techScaleMarketShareDev toProperty:@"techScaleMarketShareDev"];
}

- (NSInteger)techScaleHRQuantity{
    return [self getIntegerValueOfParameter:@"techScaleHRQuantity"];
}

- (void)setTechScaleHRQuantity:(NSInteger)techScaleHRQuantity{
    [self setIntegerValue:techScaleHRQuantity toProperty:@"techScaleHRQuantity"];
}

- (NSString *)techScaleHRQuality{
    return [self getStringValueOfParameter:@"techScaleHRQuality"];
}

- (void)setTechScaleHRQuality:(NSString *)techScaleHRQuality{
    [self setStringValue:techScaleHRQuality toProperty:@"techScaleHRQuality"];
}

- (NSString *)techScaleFinancialStrength{
    return [self getStringValueOfParameter:@"techScaleFinancialStrength"];
}

- (void)setTechScaleFinancialStrength:(NSString *)techScaleFinancialStrength{
    [self setStringValue:techScaleFinancialStrength toProperty:@"techScaleFinancialStrength"];
}

- (BOOL)techScaleTechChange{
    return [self getBooleanValue:@"techScaleTechChange"];
}

- (void)setTechScaleTechChange:(BOOL)techScaleTechChange{
    [self setBooleanValue:techScaleTechChange toProperty:@"techScaleTechChange"];
}

#pragma mark - Management Parameter

- (NSString *)managementWorkType{
    return [self getStringValueOfParameter:@"managementWorkType"];
}

- (void)setManagementWorkType:(NSString *)managementWorkType{
    [self setStringValue:managementWorkType toProperty:@"managementWorkType"];
}

- (NSString *)managementWorkSequence{
    return [self getStringValueOfParameter:@"managementWorkSequence"];
}

- (void)setManagementWorkSequence:(NSString *)managementWorkSequence{
    [self setStringValue:managementWorkSequence toProperty:@"managementWorkSequence"];
}

- (NSString *)managementTimeAndCost{
    return [self getStringValueOfParameter:@"managementTimeAndCost"];
}

- (void)setManagementTimeAndCost:(NSString *)managementTimeAndCost{
    [self setStringValue:managementTimeAndCost toProperty:@"managementTimeAndCost"];
}

- (NSString *)managementContractorQuality{
    return [self getStringValueOfParameter:@"managementContractorQuality"];
}

- (void)setManagementContractorQuality:(NSString *)managementContractorQuality{
    [self setStringValue:managementContractorQuality toProperty:@"managementContractorQuality"];
}

- (NSString *)managementDeveloperQuality{
    return [self getStringValueOfParameter:@"managementDeveloperQuality"];
}

- (void)setManagementDeveloperQuality:(NSString *)managementDeveloperQuality{
    [self setStringValue:managementDeveloperQuality toProperty:@"managementDeveloperQuality"];
}

- (NSString *)managementExecutorQuality{
    return [self getStringValueOfParameter:@"managementExecutorQuality"];
}

- (void)setManagementExecutorQuality:(NSString *)managementExecutorQuality{
    [self setStringValue:managementExecutorQuality toProperty:@"managementExecutorQuality"];
}

@end
