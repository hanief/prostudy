//
//  ProjectComparison.h
//  Prostudy
//
//  Created by Hanief Cahya on 04/02/14.
//  Copyright (c) 2014 Universitas Gadjah Mada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Criteria, Project;

@interface ProjectComparison : NSManagedObject

@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) Criteria *criteria;
@property (nonatomic, retain) NSOrderedSet *projects;
@end

@interface ProjectComparison (CoreDataGeneratedAccessors)

- (void)insertObject:(Project *)value inProjectsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromProjectsAtIndex:(NSUInteger)idx;
- (void)insertProjects:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeProjectsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInProjectsAtIndex:(NSUInteger)idx withObject:(Project *)value;
- (void)replaceProjectsAtIndexes:(NSIndexSet *)indexes withProjects:(NSArray *)values;
- (void)addProjectsObject:(Project *)value;
- (void)removeProjectsObject:(Project *)value;
- (void)addProjects:(NSOrderedSet *)values;
- (void)removeProjects:(NSOrderedSet *)values;

+ (instancetype)insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)moc;
- (BOOL)twinComparison;
- (Project *)firstProject;
- (Project *)secondProject;

@end
