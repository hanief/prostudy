//
//  UGMProjectDetailViewController.h
//  Prostudy
//
//  Created by hanief on 1/10/13.
//  Copyright (c) 2013 Universitas Gadjah Mada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGMProjectViewController.h"

@class Project;

@interface UGMProjectDetailViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) Project *project;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UGMProjectViewController *presentingVC;

- (instancetype)initByAddingNewProject:(BOOL)addNew;

@end
