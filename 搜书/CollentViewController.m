//
//  CollentViewController.m
//  搜书
//
//  Created by 麻炜怡 on 4/3/15.
//  Copyright (c) 2015 CodeMonkey. All rights reserved.
//

#import "CollentViewController.h"
#import "BookTableViewCell.h"

@interface CollentViewController ()


@property (nonatomic, strong) FMDatabase *db;

@end

@implementation CollentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"CollectView"] ];     //打开数据库读取数据
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpaths = [docsdir stringByAppendingPathComponent:@"Search.sqlite"];
    FMDatabase *dbs = [FMDatabase databaseWithPath:dbpaths];
    //NSLog(@"_dbpathcoll-----%@",dbs);
    _db = dbs;
    //_dataArray = [[NSMutableArray alloc] init];
    //NSLog(@"self----------%@",self);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventListenerDidReceiveNotification:)
                                                 name:@"MyNotification"
                                               object:nil];    [self getdataFromSqlite];
    [self setupRefresh];
    

     self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //#warning 自动刷新(一进入程序就下拉刷新)
    //[self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    //[self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
     self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
     self.tableView.headerRefreshingText = @"麻子正在帮你刷新中,bulalala.....";
    
    /*self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"麻子正在帮你加载中,bulalala.....";*/
}

- (void)headerRereshing
{
    // 1.添加假数据
    /*for (int i = 0; i<5; i++) {
        [self.fakeData insertObject:MJRandomData atIndex:0];
    }*/
    
    [self getdataFromSqlite];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getdataFromSqlite {
    _dataArray = [[NSMutableArray alloc] init];
    
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM searchbook"];
        FMResultSet *resultSet = [_db executeQuery:sql];
        while ([resultSet next]) {
            
            BookData *data = [[BookData alloc] init];
            
            data.bookName = [resultSet stringForColumn:@"name"];
            data.bookAuther = [resultSet stringForColumn:@"people"];
            data.bookData = [resultSet stringForColumn:@"data"];
            data.bookPublish = [resultSet stringForColumn:@"publish"];
            
            [_dataArray addObject:data];
        //NSLog(@"我成功打开了数据库");
        }
        
    }
    if (_dataArray.count == 0) {
        self.tableView.hidden = YES;
    }else{
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"maweiyi"];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"cell" owner:nil options:nil] firstObject];
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sheet"]];
    }
    BookData *data = _dataArray[indexPath.row];
    //NSLog(@"%ld",indexPath.row);
    
    cell.publishLabel.text = data.bookPublish;
    
    cell.dateLabel.text = data.bookData;
    cell.nameLabel.text = data.bookAuther;
    
    cell.bookDisplay.text = data.bookName;
    //NSLog(@",%@",data.bookName);
    
    return cell;
}


- (void)eventListenerDidReceiveNotification:(NSNotification *)notification
{
    //NSLog(@"我接到了一个通知。。。。。。嘻嘻");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MyNotification" object:nil];
    [self viewDidLoad];
    
    [self.tableView reloadData];
    
    
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"MyNotification" object:nil];
}


//返回YES，表示支持单元格的移动
/*-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}*/
//单元格返回的编辑风格，包括删除 添加 和 默认  和不可编辑三种风格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //        获取选中删除行索引值
        NSInteger row = [indexPath row];
        //        通过获取的索引值删除数组中的值
        //[_dataArray removeObjectsAtIndexe:row];
        
        BookData *data = [[BookData alloc] init];
        data = _dataArray[row];        [_dataArray removeObjectAtIndex:row];         //        删除单元格的某一行时，在用动画效果实现删除过程
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        NSString *stringName = data.bookName;
        
        if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from searchbook where name = '%@'",stringName];
        
            [_db executeUpdate:sql];
           // NSLog(@"我被删除了");
            [_db close];
        
    }
    }
    
    if (!_dataArray.count) {
        self.tableView.hidden = YES;
    }
    //[self.tableView reloadData];
}

@end
