//
//  UGMSubCriteriaViewController.h
//  Prostudy
//
//  Created by Hanief Cahya on 14/01/14.
//  Copyright (c) 2014 Universitas Gadjah Mada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@class Criteria;

@interface UGMSubCriteriaViewController : CoreDataTableViewController <UIAlertViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithParentCriteria:(Criteria *)criteria;

@end
