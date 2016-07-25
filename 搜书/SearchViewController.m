//
//  ViewController.m
//  搜书
//
//  Created by 麻炜怡 on 4/3/15.
//  Copyright (c) 2015 CodeMonkey. All rights reserved.
//

#import "SearchViewController.h"
#import "BookTableViewCell.h"
#import "BookTableViewCell.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"
#import "FMDB.h"
#import "FMResultSet.h"
#import "MJRefresh.h"
#import "CollentViewController.h"
#import "LCProgressHUD.h"
#import "DetailViewTableViewController.h"

static NSString *identifier = @"maweiyi";



@interface SearchViewController ()<NSURLConnectionDelegate>

@property (nonatomic, copy) NSString *praString;

@property (nonatomic, strong) NSData *theData;



    
@property (nonatomic, strong) BookData *data;


@property (nonatomic, assign) NSInteger refreshTimes;   //纪录刷新的次数

@property (nonatomic, strong) DetailViewTableViewController *detailview;


@property (nonatomic, strong) NSString *dbpath;

@property (nonatomic,assign) NSInteger flag;

@property (nonatomic, strong) FMDatabase *db;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"CollectView"] ];    // Do any additional setup after loading the view, typically from a nib.
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpaths = [docsdir stringByAppendingPathComponent:@"Search.sqlite"];
    _dbpath = dbpaths;
    
    FMDatabase *dbs = [FMDatabase databaseWithPath:_dbpath];
    if ([dbs open]) {
    [dbs executeUpdate:@"CREATE TABLE IF NOT EXISTS searchbook (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, publish text NOT NULL, data text NOT NULL, people text NOT NULL)"];
    }
   // NSLog(@"我创建了数据库");
    _db = dbs;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    
    [self setUpForDismissKeyboard];
    
    [self setupRefresh];
    
    self.refreshTimes = 1;
    
    
    self.tableView.hidden = YES;
       
    _newTudtorials = [[NSMutableArray alloc] init];
    
    //_detailview = [[DetailViewTableViewController alloc] init];
    //CollentViewController *collView = [[CollentViewController alloc] initWithValue:_dbpath];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //[self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //#warning 自动刷新(一进入程序就下拉刷新)
    //[self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    /*self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"麻子正在帮你刷新中,bulalala.....";*/
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"麻子正在帮你加载中,bulalala.....";
}

- (void)footerRereshing
{
    self.refreshTimes++;
     //NSLog(@"_refreshTimes---------%ld",self.refreshTimes);
    if (self.refreshTimes <= [_tableNumber integerValue]) {
        
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSURL *URL = [NSURL URLWithString:@"http://202.196.33.227:8080/opac_two/search2/searchout.jsp"];
        CFStringRef encodedString = CFURLCreateStringByAddingPercentEscapes
        (NULL, (CFStringRef)self.searchBar.text, NULL,
         (CFStringRef)@"!*’();:@&=+$,/?%#[]",kCFStringEncodingGB_18030_2000);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        
        request.timeoutInterval = 5.0;
        
        request.HTTPMethod = @"POST";
        
        NSString *param = [NSString stringWithFormat:@"library_id=all&recordtype=all&kind=simple&suchen_word=%@&suchen_type=1&suchen_match=mh&kind=simple&show_type=wenzi&snumber_type=N&search_no_type=N&searchtimes=1&size=20&curpage=%ld&orderby=pubdate_date&ordersc=desc&page=2&pagesize=20",encodedString,self.refreshTimes];
        request.HTTPBody = [param dataUsingEncoding:enc allowLossyConversion:YES];
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSString *string = [[NSString alloc] initWithData:data encoding:enc];
        //NSLog(@"%@",string);
        
        NSData *predata = [string dataUsingEncoding:NSUTF8StringEncoding];
        
        _theData = predata;
        
        CFRelease(encodedString);
        
        [self loadSearchData];
        
        
    }
    
    //NSLog(@"我正在刷新中,bulalala......");
    // 2.2秒后刷新表格UI
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"文本改变了");
}*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _bookArray.count;
    //
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 100;
}


//当表中的某一行被选中以后
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _flag = 1;
    
    _detailview = [[DetailViewTableViewController alloc] init];
    
    _detailview.getData = self.newTudtorials;
    
    _detailview.everyIndex = indexPath.row;
    _detailview.flagState = _flag;
    
    BookData *data = [[BookData alloc] init];
    data = _detailview.getData[_detailview.everyIndex];
    //NSLog(@"data----%@",data.bookName);
    
    
    //在此处把数据库打开，先检索所要查找的书籍是否存在传递一个标志进去
    
    _detailview.dbxpath = _dbpath;
    
    //FMDatabase *db = [FMDatabase databaseWithPath:_dbpath];
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM searchbook"];
        FMResultSet *resultSet = [_db executeQuery:sql];
        while ([resultSet next]) {
            NSString *name = [resultSet stringForColumn:@"name"];
            //NSLog(@"name-----%@",name);
            if ([data.bookName isEqualToString:name]) {
                _flag = 0;
                _detailview.flagState = _flag;
            }
        }
    }
    [_db close];
    [_detailview sendGetRequire];
    
    
    
    
    
    
    [LCProgressHUD showStatus:LCProgressHUDStatusWaitting text:@"正在加载"];
    
    [NSTimer scheduledTimerWithTimeInterval:1.50f
                                     target:self
                                   selector:@selector(hideHUD)
                                   userInfo:nil
                                    repeats:NO];
    
    //[self.navigationController pushViewController:_detailview animated:YES];
    //NSLog(@"Hello 我被选中了");
    
}

- (void)hideHUD {
    
    [LCProgressHUD hide:YES keep:NO];
    
[self.navigationController pushViewController:_detailview animated:YES];
}

- (void) collectionClicked{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"cell" owner:nil options:nil] firstObject];
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sheet"]];
        //cell.backgroundColor = [UIColor co]
        //UIColor *bgcolour = [BackgroundLayer colorWithHexString:@"F13982"];
        //cell.backgroundColor = [UIColor lightGrayColor];
    }
    BookData *data = _bookArray[indexPath.row];
    //NSLog(@"%ld",indexPath.row);
    
    cell.publishLabel.text = data.bookPublish;
    
    cell.dateLabel.text = data.bookData;
    cell.nameLabel.text = data.bookAuther;
    
    cell.bookDisplay.text = data.bookName;
    //NSLog(@",%@",data.bookName);
    
    return cell;
    
    //cell.textLabel.text = data.bookPublish;
    
    
    //NSLog(@"我要显示数据啦");
    //return cell;
    
    
    
}

/*- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"我开始编辑了");
    return true;
}*/


- (BOOL)searchBarDidBeginEditing:(UISearchBar *)searchBar {
    
    
    
    return YES;
}

- (BOOL)searchBarDidEndEditing:(UISearchBar *)searchBar {
   // NSLog(@"我完成编辑了");
    return true;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
   // NSLog(@"我被点击了");
   // NSLog(@"%@",searchBar.text);
}


/*- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    if (selectedScope == 0) {
        NSLog(@"第一个按钮被点击了");
    }
    else {
        NSLog(@"第二个按钮被点击了");
        NSLog(@"%@",self.searchBar.text);
    }
}*/

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    //NSLog(@"我被点击了");
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    self.refreshTimes = 1;
    [self.newTudtorials removeAllObjects];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSURL *URL = [NSURL URLWithString:@"http://202.196.33.227:8080/opac_two/search2/searchout.jsp"];
    
    CFStringRef encodedString = CFURLCreateStringByAddingPercentEscapes
    (NULL, (CFStringRef)searchBar.text, NULL,
     (CFStringRef)@"!*’();:@&=+$,/?%#[]",kCFStringEncodingGB_18030_2000);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    request.timeoutInterval = 5.0;
    
    request.HTTPMethod = @"POST";
    
    NSString *param = [NSString stringWithFormat:@"search_no_type=N&snumber_type=N&suchen_type=1&suchen_word=%@&suchen_match=mh&recordtype=all&x=47&y=5",encodedString];
    
    
    request.HTTPBody = [param dataUsingEncoding:enc allowLossyConversion:YES];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *string = [[NSString alloc] initWithData:data encoding:enc];
    
    NSData *predata = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    _theData = predata;
    
    CFRelease(encodedString);
    
    [self loadSearchData];
    [self loadNumber];
    
    self.tableView.hidden = NO;
    
   /*NSString *string = [NSString stringWithFormat:@"http://www.salttiger.com/?s=%@",searchBar.text];
    
    NSURL *URL = [NSURL URLWithString:string];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *string1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    _praString = string1;
    
    NSLog(@"%@",_praString);
    _theData = data;
    [self loadSearchData];*/
    
    
}


- (void)loadSearchData {
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:_theData];
    NSString *tuXpathQueryString = @"//div/table/tr/td";
    NSArray *tuNodes = [parser searchWithXPathQuery:tuXpathQueryString];
    
    //NSLog(@"%@",tuNodes);
    //NSMutableArray *nodes = [[NSMutableArray alloc] initWithArray:tuNodes];
    
    //NSMutableArray *newTutorials = [[NSMutableArray alloc] initWithCapacity:0];
    NSInteger i = 0;
    
    for (TFHppleElement *element in tuNodes) {
        if (i > 10) {
            if (i % 6 == 5) {
        
        BookData *bookdata = [[BookData alloc] init];
                _data = bookdata;
        [self.newTudtorials addObject:_data];
            }
        
        for (TFHppleElement *child in element.children) {
            if ([child.tagName isEqualToString:@"a"]) {
                _data.bookUrlArray = [child objectForKey:@"href"];
                //NSLog(@"%@",bookdata.bookUrlArray);
                _data.bookName = [child content];
                //NSLog(@"%@",bookdata.bookName);
            }
        }
            //NSLog(@"%ld---%@",i,[element content]);
        
           switch (i % 6) {
                case 1:
                   _data.bookAuther = [element content];
                   //NSLog(@"%@",element.content);
                   break;
                case 2:
                   _data.bookPublish = [element content];
                    break;
                case 4:
                   _data.bookData = [element content];
                   break;
                default:
                    break;
           }
        }
        i++;

    }
    
    _bookArray = self.newTudtorials;
    [self.searchBar resignFirstResponder];
    [self.tableView reloadData];
    
    
    
    
}


- (void)loadNumber {
    TFHpple *parser = [TFHpple hppleWithHTMLData:_theData];
    
    NSString *tuXpathQueryString = @"//table/tr/td/span/strong";
    NSInteger i = 0;
    
    NSArray *tuNodes = [parser searchWithXPathQuery:tuXpathQueryString];
    
    for (TFHppleElement *element in tuNodes) {
        i++;
        if (i == 1) {
            _recordNumber = [element content];
            //NSLog(@"%@",_recordNumber);
        }
        
        if (i == 4) {
            _tableNumber = [element content];
           // NSLog(@"%@",_tableNumber);
        }
        //NSLog(@"%ld-----%@",i,[element content]);
    }
}


- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}





// 实现下拉刷新

//实现SendData协议中的两个方法



@end
