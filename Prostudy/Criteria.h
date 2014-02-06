//
//  Criteria.h
//  Prostudy
//
//  Created by Hanief Cahya on 02/02/14.
//  Copyright (c) 2014 Universitas Gadjah Mada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Criteria, CriteriaComparison, ProjectComparison;

@interface Criteria : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSSet *childs;
@property (nonatomic, retain) NSSet *criteriaComparisons;
@property (nonatomic, retain) Criteria *parent;
@property (nonatomic, retain) ProjectComparison *projectComparison;

@end

@interface Criteria (CoreDataGeneratedAccessors)

- (void)addChildsObject:(Criteria *)value;
- (void)removeChildsObject:(Criteria *)value;
- (void)addChilds:(NSSet *)values;
- (void)removeChilds:(NSSet *)values;

- (void)addCriteriaComparisonsObject:(CriteriaComparison *)value;
- (void)removeCriteriaComparisonsObject:(CriteriaComparison *)value;
- (void)addCriteriaComparisons:(NSSet *)values;
- (void)removeCriteriaComparisons:(NSSet *)values;

+ (instancetype)insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)moc;
- (NSString *)nameInitial;

- (NSComparisonResult)compare:(Criteria *)criteria;

@end
