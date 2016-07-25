//
//  BookData.h
//  搜书
//
//  Created by 麻炜怡 on 4/6/15.
//  Copyright (c) 2015 CodeMonkey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookData : NSObject


@property (nonatomic, copy) NSString *bookUrlArray;//存放从网站上解析出来的书的详细信息的url

@property (nonatomic, copy) NSString *bookName;//存放书的名字

@property (nonatomic, copy) NSString *bookPublish;//存放书的出版社

@property (nonatomic, copy) NSString *bookData;//存放书的出版日期

@property (nonatomic, copy) NSString *bookAuther;//书的作者


@property (nonatomic, assign) NSInteger flag;//标志书是否被收藏过



@end
