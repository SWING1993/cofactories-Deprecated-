//
//  BidTableViewCell.m
//  cofactory-1.1
//
//  Created by gt on 15/8/13.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "BidTableViewCell.h"

@implementation BidTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.companyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 160, 44)];
        self.companyNameLabel.font = [UIFont systemFontOfSize:14.0f];
        self.companyNameLabel.textColor = [UIColor grayColor];
        [self addSubview:self.companyNameLabel];
        
        self.competeButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60-15, 7, 60, 30)];
        self.competeButton.layer.masksToBounds = YES;
        self.competeButton.layer.cornerRadius = 5.0f;
        self.competeButton.titleLabel.textColor = [UIColor whiteColor];
        self.competeButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:self.competeButton];
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
