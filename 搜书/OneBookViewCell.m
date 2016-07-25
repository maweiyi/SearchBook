//
//  OneBookViewCell.m
//  搜书
//
//  Created by 麻炜怡 on 4/7/15.
//  Copyright (c) 2015 CodeMonkey. All rights reserved.
//

#import "OneBookViewCell.h"

@implementation OneBookViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithCellPostitio:(NSInteger)number {
    if (self = [super init]) {
        self.imageArray = [[NSMutableArray alloc] init];
        self.lableArray =[[NSMutableArray alloc] init];
        //NSLog(@"%ld",number);
        //_imageArray = [NSMutableArray array];
        
        self.labelIndexnum = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 320, 20)];
        [self addSubview:self.labelIndexnum];
        
            for (int i = 1; i <= number; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 28*i + 8, 20, 20)];
                //NSLog(@"%@",imageView);
            [self.imageArray addObject:imageView];
            [self addSubview:imageView];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(36, 28*i + 8, 280, 20)];
                //_labelplaceAndState = label;
            //label.backgroundColor = [UIColor redColor];
            [self.lableArray addObject:label];
            [self addSubview:label];
        }
    }
    
    //NSLog(@"_imageArray--------%ld",_imageArray.count);

    return self;
}



@end
