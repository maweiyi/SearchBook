//
//  CollentViewController.h
//  搜书
//
//  Created by 麻炜怡 on 4/3/15.
//  Copyright (c) 2015 CodeMonkey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookData.h"

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"
#import "FMDB.h"
#import "FMResultSet.h"
#import "MJRefresh.h"
@interface CollentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) NSString *dbpathcoll;//数据库所在的路径


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) BookData *data;


@property (nonatomic, strong) NSMutableArray *dataArray;


@property (nonatomic, assign) NSInteger i;

//@property (nonatomic, copy) NSString *sendValue;

- (void)getdataFromSqlite;



- (void) UpdateView;

@end
