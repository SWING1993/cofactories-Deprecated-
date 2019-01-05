
//
//  OrderDetailTableViewCell.m
//  cofactory-1.1
//
//  Created by GTF on 15/10/16.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "OrderDetailTableViewCell.h"

@implementation OrderDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _bidAmountLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenW-160, 50)];
        _bidAmountLB.font = kFont;
        [self addSubview:_bidAmountLB];
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-80, 0, 70, 50)];
        lb.text = @"投标管理";
        lb.font = kLargeFont;
        lb.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        [self addSubview:lb];
        
        _bidManagerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bidManagerButton.frame = CGRectMake(kScreenW-80-40, 10, 30, 30);
        [_bidManagerButton setBackgroundImage:[UIImage imageNamed:@"投标1"] forState:UIControlStateNormal];
        [self addSubview:_bidManagerButton];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-80-50, 8, 0.8, 34)];
        line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
        [self addSubview:line];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
