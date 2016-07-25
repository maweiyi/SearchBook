//
//  DetailViewTableViewController.m
//  搜书
//
//  Created by 麻炜怡 on 4/7/15.
//  Copyright (c) 2015 CodeMonkey. All rights reserved.
//

#import "DetailViewTableViewController.h"
#import "BookData.h"
#import "OneBookDetail.h"
#import "OneBookViewCell.h"
#import "OneBookDescriptionCell.h"
#import "BookTableViewCell.h"
#import "BookDeciptTableViewCell.h"
#import "CollentViewController.h"

@interface DetailViewTableViewController () {
    
    }


@property (nonatomic, strong) NSData *pregetData;


@property (nonatomic ,copy) NSString *bookDetail;//书的详细描述

@property (nonatomic, copy) NSString *IndexBook;//索书号



@property (nonatomic, strong) NSMutableArray *oneBookArray;


@property (nonatomic, strong) OneBookDetail *data;

@property (nonatomic, strong) CollentViewController *collViewController;


@property (nonatomic, strong) UIBarButtonItem *btn;


@property (nonatomic, assign) NSInteger flag2;





@end

@implementation DetailViewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"deep"] ];    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //NSLog(@"我来到DetailViewTableViewController了");
    //[self sendGetRequire];
    if (_flagState == 1) {
    UIBarButtonItem *btnTouch = [[UIBarButtonItem alloc] initWithTitle:@"Collect" style:UIBarButtonItemStylePlain target:self action:@selector(collectionClicked)];
       self.navigationItem.rightBarButtonItem = btnTouch;
    
    _btn = btnTouch;
    }else {
        UIBarButtonItem *btnTouch = [[UIBarButtonItem alloc] initWithTitle:@"Collected" style:UIBarButtonItemStylePlain target:self action:@selector(collect)];
        self.navigationItem.rightBarButtonItem = btnTouch;
    }
    
    /*UIStoryboard * storyBoard = [UIStoryboard
                                 storyboardWithName:@"Main" bundle:nil];
    
    _collViewController = [storyBoard instantiateViewControllerWithIdentifier:@"maweiyiID"];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 40, 40)];
    
    btn.backgroundColor = [UIColor redColor];
    
    [_collViewController.view addSubview:btn];*/
    /*NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpaths = [docsdir stringByAppendingPathComponent:@"Search.sqlite"];
    _dbpath = dbpaths;*/
    
    _flag2 = 0;
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventListenerDidReceiveNotification:)
                                                name:@"MyNotification"
                                               object:nil];*/
    self.tableView.tableFooterView = [[UIView alloc] init];
}


- (void) collect {
    
}


- (void)collectionClicked {
    
    //[self presentViewController:_collViewController animated:YES completion:^{}];
    //[self.navigationController addChildViewController:_collViewController];

     /*[self.navigationController pushViewController:_collViewController animated:YES];*/
    
    BookData *data = [[BookData alloc] init];
    data = self.getData[_everyIndex];
     _btn.title = @"Collected";
    FMDatabase *db = [FMDatabase databaseWithPath:_dbxpath];
    if ([db open]) {
        /*BOOL result1 = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS searchbook (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, publish text NOT NULL, data text NOT NULL, people text NOT NULL)"];*/
        if (_flag2 == 0) {
        
        NSString *cell = [NSString stringWithFormat:@"INSERT INTO searchbook ('name', 'publish', 'data', 'people')VALUES ('%@', '%@', '%@', '%@')",data.bookName,data.bookPublish,data.bookData,data.bookAuther];
        
        [db executeUpdate:cell];
            _flag2 = 1;
        }
        
        [db close];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyNotification" object:nil];
    }
    
    
   //[[NSNotificationCenter defaultCenter] postNotificationName:@"notificationName" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 3;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        return 100;
    }
    
    if (indexPath.row == 1) {
        int a = _oneBookArray.count +1;
        //NSLog(@"a---------%d",a);
        return 28 * a + 8;
    }
    
    if (indexPath.row == 2) {
        return 200;

    }
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BookTableViewCell *cell_0 = [[[NSBundle mainBundle] loadNibNamed:@"cell" owner:nil options:nil] firstObject];
        //cell_0.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sheet"]];
        BookData *data = [[BookData alloc] init];
        
        data = self.getData[_everyIndex];
        cell_0.publishLabel.text = data.bookPublish;
        
        cell_0.dateLabel.text = data.bookData;
        cell_0.nameLabel.text = data.bookAuther;
        
        cell_0.bookDisplay.text = data.bookName;
        return cell_0;
        
    }
    
    if (indexPath.row == 1) {
        OneBookViewCell *cell_1 = [[OneBookViewCell alloc] initWithCellPostitio:self.oneBookArray.count];
        //cell_1.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.5];
        //cell_1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sheet_0"]];        //cell_1.textLabel
        //索书号
        if (_IndexBook != nil) {
            NSString *string =[NSString stringWithFormat:@"索书号: %@",_IndexBook];
            
            cell_1.labelIndexnum.textColor = [UIColor redColor];
            cell_1.labelIndexnum.text = string;
        }
        
        
        //cell_1.imagePlace.image = [UIImage imageNamed:@"place"];
        //定义两个变量分别取出对应的数据和图片
        UIImageView *imageView = [[UIImageView alloc] init];
        
        UILabel *labelView = [[UILabel alloc] init];
        //UIImageView *image = [[UIImageView alloc] init];
        OneBookDetail *oneDetail = [[OneBookDetail alloc] init];
        
        for (int i = 0; i < _oneBookArray.count; i++) {
            imageView = cell_1.imageArray[i];
            imageView.image = [UIImage imageNamed:@"place"];
            //NSLog(@"%@",imageView.image);
            labelView = cell_1.lableArray[i];
            oneDetail = _oneBookArray[i];
            if (oneDetail.bookPosition == nil) {
                NSString *labelString = [NSString stringWithFormat:@"%@",oneDetail.bookState];
                labelView.text = labelString;
            }else{
            
            NSString *labelString = [NSString stringWithFormat:@"%@ %@",oneDetail.bookPosition,oneDetail.bookState];
            labelView.text = labelString;
                
            }
            //NSLog(@"labelString------%@",labelString);
            //labelView.text = labelString;
            
        }
        return cell_1;
    }
    
    if (indexPath.row == 2) {
    
        //BookDeciptTableViewCell *cell_2 = [[BookDeciptTableViewCell alloc] initWithTextView];
        //cell_2.textView.text = _bookDetail;
        
        BookDeciptTableViewCell *cell_2 = [[[NSBundle mainBundle] loadNibNamed:@"BookDe" owner:nil options:nil] firstObject];
        
        cell_2.textView.sizeToFit;
        
        cell_2.textView.text = _bookDetail;
        
        return cell_2;
    }
    return [[UITableViewCell alloc] init];
}

//用来解析每一本书的具体的HTML
- (void) loadDetail {
    TFHpple *parser = [TFHpple hppleWithHTMLData:_pregetData];
    
    NSString *tuXpathQueryString = @"//center/div/table/tr/td/table/tr/td/center/table/tr/td";
   // NSString *tuXpathQueryString = @"//head/title";
    NSArray *tuNodes = [parser searchWithXPathQuery:tuXpathQueryString];
    
    int i = 0;
    
    for (TFHppleElement *element in tuNodes) {
        i++;
        if (i == 13) {
            _bookDetail = [element content];
        }
        
    }
    
    
    //NSLog(@"%@",_bookDetail);
    
    
}


- (void) sendGetRequire {
    BookData *data = [[BookData alloc] init];
    
    data = _getData[_everyIndex];
    //NSLog(@"%ld",_everyIndex);
    
    NSString *urlStr = [NSString stringWithFormat:@"http://202.196.33.227:8080/opac_two/search2/%@",data.bookUrlArray];
    //NSLog(@"%@",urlStr);
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        
        NSData *getData = data;
        
        NSString *string = [[NSString alloc] initWithData:getData encoding:enc];
        //NSLog(@"%@",string);
        
        NSData *predata = [string dataUsingEncoding:NSUTF8StringEncoding];
        
        _pregetData = predata;
        //NSLog(@"%@",_pregetData);
        [self loadDetail];
        [self bookPosition];
    }];
    
}

- (void)bookPosition {
    TFHpple *parser = [TFHpple hppleWithHTMLData:_pregetData];
    
    int i = -8;
    
    NSString *tuXpathQueryString = @"//table/tr/td/div/table/tr/td/ul/li/ul/li/table/tr/td";
    //NSString *tuXpathQueryString = @"//head/title";
    NSArray *tuNodes = [parser searchWithXPathQuery:tuXpathQueryString];
    NSMutableArray *newTutorials = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in tuNodes) {
        i++;
        if (i > 0) {
            if (i == 3) {
                _IndexBook = [element content];
                //NSLog(@"%@",_IndexBook);
            }
            else {
                if (i % 9 == 1) {
                    OneBookDetail *oneBook = [[OneBookDetail alloc] init];
                    _data = oneBook;
                    [newTutorials addObject:_data];
                }
        
                switch (i % 9) {
                    case 5:
                        _data.bookPosition = [element content];
                      // NSLog(@"%@",_data.bookPosition);
                        break;
                    case 6:
                        _data.bookState = [element content];
                        //NSLog(@"%@",_data.bookState);
                        break;
                        
                    default:
                        break;
                
                }
            }
        }
            }
    
    _oneBookArray = newTutorials;
    OneBookDetail *detail = [[OneBookDetail alloc] init];
    detail = _oneBookArray[0];
    //NSLog(@"%@",detail.bookPosition);
    //NSLog(@"_oneBookArray------%ld",_oneBookArray.count);
    [self.tableView reloadData];
    
}




@end
