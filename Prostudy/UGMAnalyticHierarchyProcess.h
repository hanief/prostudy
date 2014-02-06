//
//  UGMAnalyticHierarchyProcess.h
//  Prostudy
//
//  Created by Hanief Cahya on 14/01/14.
//  Copyright (c) 2014 Universitas Gadjah Mada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UGMAnalyticHierarchyProcess : NSObject

@property (nonatomic) BOOL useLapack;

- (void)AHPFromMatrix:(NSArray *)matrix completion:(void (^)(NSArray *squaredMatrix, NSArray *eigenvector, float consistencyRatio, NSError *error))block;

@end
