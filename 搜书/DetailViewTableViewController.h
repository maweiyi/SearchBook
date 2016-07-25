//
//  DetailViewTableViewController.h
//  搜书
//
//  Created by 麻炜怡 on 4/7/15.
//  Copyright (c) 2015 CodeMonkey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"
#import "FMDB.h"
#import "FMResultSet.h"


@interface DetailViewTableViewController : UITableViewController 


@property (nonatomic, strong) NSMutableArray *getData;

@property (nonatomic, assign) NSInteger everyIndex;

@property (nonatomic,assign) NSInteger flagState;


@property (nonatomic, strong) NSString *dbxpath;
- (void) sendGetRequire;

- (void) loadDetail;
@end


