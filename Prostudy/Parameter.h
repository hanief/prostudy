//
//  Parameter.h
//  Prostudy
//
//  Created by Hanief Cahya on 02/02/14.
//  Copyright (c) 2014 Universitas Gadjah Mada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface Parameter : NSManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) Project *project;

@end
