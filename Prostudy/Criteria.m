//
//  Criteria.m
//  Prostudy
//
//  Created by Hanief Cahya on 02/02/14.
//  Copyright (c) 2014 Universitas Gadjah Mada. All rights reserved.
//

#import "Criteria.h"
#import "Criteria.h"
#import "CriteriaComparison.h"
#import "ProjectComparison.h"


@implementation Criteria

@dynamic name;
@dynamic priority;
@dynamic childs;
@dynamic criteriaComparisons;
@dynamic parent;
@dynamic projectComparison;

+ (NSString *)entityName
{
    return @"Criteria";
}

+ (instancetype)insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)moc{
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
}

- (NSString *)nameInitial{
    return [self.name substringToIndex:3];
}

- (NSComparisonResult)compare:(Criteria *)criteria {
    if(![criteria isKindOfClass:[Criteria class]]) return NSOrderedSame;
    
    return [self.name compare:criteria.name];
}

@end
