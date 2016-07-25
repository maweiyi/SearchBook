//
//  BookDeciptTableViewCell.h
//  搜书
//
//  Created by 麻炜怡 on 4/8/15.
//  Copyright (c) 2015 CodeMonkey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookDeciptTableViewCell : UITableViewCell


- (instancetype) initWithTextView;


//@property (nonatomic, strong) UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *textView;

@end
