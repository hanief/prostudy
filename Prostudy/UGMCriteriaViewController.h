//
//  UGMCriteriaViewController.h
//  Prostudy
//
//  Created by hanief on 1/9/13.
//  Copyright (c) 2013 Universitas Gadjah Mada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface UGMCriteriaViewController : CoreDataTableViewController <UIAlertViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
