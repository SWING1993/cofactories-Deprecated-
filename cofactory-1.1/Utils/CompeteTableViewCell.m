//
//  CompeteTableViewCell.m
//  cofactory-1.1
//
//  Created by gt on 15/8/13.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "CompeteTableViewCell.h"

@implementation CompeteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.companyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 160, 44)];
        self.companyNameLabel.font = [UIFont systemFontOfSize:14.0f];
        self.companyNameLabel.textColor = [UIColor grayColor];
        [self addSubview:self.companyNameLabel];
        
        self.competeImage = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60-15, 7, 60, 30)];
        self.competeImage.layer.masksToBounds = YES;
        self.competeImage.layer.cornerRadius = 5.0f;
        self.competeImage.textColor = [UIColor whiteColor];
        self.competeImage.font = [UIFont systemFontOfSize:16.0f];
        self.competeImage.textAlignment =1;
        [self addSubview:self.competeImage];
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
