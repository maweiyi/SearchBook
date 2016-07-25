//
//  BookTableViewCell.h
//  搜书
//
//  Created by 麻炜怡 on 4/3/15.
//  Copyright (c) 2015 CodeMonkey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bookDisplay;

@property (weak, nonatomic) IBOutlet UIImageView *publishImage;
@property (weak, nonatomic) IBOutlet UILabel *publishLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dateImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nameImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;



@end
