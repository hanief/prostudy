//
//  CriteriaComparison.h
//  Prostudy
//
//  Created by Hanief Cahya on 03/02/14.
//  Copyright (c) 2014 Universitas Gadjah Mada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Criteria;

@interface CriteriaComparison : NSManagedObject

@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSOrderedSet *criterias;
@end

@interface CriteriaComparison (CoreDataGeneratedAccessors)

- (void)insertObject:(Criteria *)value inCriteriasAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCriteriasAtIndex:(NSUInteger)idx;
- (void)insertCriterias:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCriteriasAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCriteriasAtIndex:(NSUInteger)idx withObject:(Criteria *)value;
- (void)replaceCriteriasAtIndexes:(NSIndexSet *)indexes withCriterias:(NSArray *)values;
- (void)addCriteriasObject:(Criteria *)value;
- (void)removeCriteriasObject:(Criteria *)value;
- (void)addCriterias:(NSOrderedSet *)values;
- (void)removeCriterias:(NSOrderedSet *)values;

+ (instancetype)insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)moc;
- (BOOL)twinComparison;
- (Criteria *)firstCriteria;
- (Criteria *)secondCriteria;

@end
