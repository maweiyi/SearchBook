//
//  OneBookViewCell.h
//  搜书
//
//  Created by 麻炜怡 on 4/7/15.
//  Copyright (c) 2015 CodeMonkey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneBookViewCell : UITableViewCell


- (instancetype)initWithCellPostitio:(NSInteger) number;

@property (nonatomic, strong) UILabel *labelIndexnum;

@property (nonatomic, strong) NSMutableArray *imageArray;//用来存放图片的一个数组

@property (nonatomic, strong) NSMutableArray *lableArray;//用来存放图书状态的一个数组


@property (nonatomic, strong) UIImageView *imagePlace;//书的位置

@property (nonatomic, strong) UILabel *labelplaceAndState;



@end
