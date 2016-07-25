//
//  ViewController.h
//  搜书
//
//  Created by 麻炜怡 on 4/3/15.
//  Copyright (c) 2015 CodeMonkey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "XPathQuery.h"
#import "BookData.h"
#import "MJRefresh.h"

#import "DetailViewTableViewController.h"



//定义了搜索栏的委托协议和搜索栏的显示控制协议
//定义了TableView的委托协议以及数据源协议




@interface SearchViewController : UIViewController<UISearchBarDelegate, UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *bookArray;

@property (nonatomic, copy) NSString *recordNumber;


@property (nonatomic, copy) NSString *tableNumber;


@property (nonatomic, strong, getter=thenewTitle) NSMutableArray *newTudtorials;


@property (nonatomic, assign) NSInteger sendIndex;




//- (instancetype)initWithNewTudtorials;


@end

