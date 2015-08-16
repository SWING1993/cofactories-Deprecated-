//
//  searchOrderListTVC.m
//  cofactory-1.1
//
//  Created by gt on 15/7/24.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "searchOrderListTVC.h"
#import "Header.h"

@implementation searchOrderListTVC

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *labelBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 15)];
        labelBGView.backgroundColor = [UIColor colorWithRed:255/255.0 green:106/255.0 blue:106/255.0 alpha:1.0];
        labelBGView.userInteractionEnabled = YES;
        [self addSubview:labelBGView];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenW, 15)];
        self.timeLabel.font = [UIFont systemFontOfSize:14.0f];
        self.timeLabel.textColor = [UIColor whiteColor];
        [labelBGView addSubview:self.timeLabel];
        
        self.orderImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 60, 60)];
        self.orderImage.layer.masksToBounds = YES;
        self.orderImage.layer.cornerRadius = 5;
        [self addSubview:self.orderImage];
        
        self.orderTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, 140, 20)];
        self.orderTypeLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.orderTypeLabel];
        
        self.amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 40, 160, 20)];
        self.amountLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.amountLabel];
        
        self.workingTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 60, 100, 20)];
        self.workingTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.workingTimeLabel];
        
//        self.intersestLabelView = [[UIView alloc]initWithFrame:CGRectMake(170, 60, [UIScreen mainScreen].bounds.size.width-180, 20)];
//        self.intersestLabelView.userInteractionEnabled = YES;
//        [self addSubview:self.intersestLabelView];
//
        
        self.interestCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 92, (kScreenW-140)/2.0, 22)];
        self.interestCountLabel.font = [UIFont systemFontOfSize:14.0f];
        self.interestCountLabel.textColor = [UIColor orangeColor];
        self.interestCountLabel.textAlignment = 2;
        [self addSubview:self.interestCountLabel];
        
        
        self.labels = [[UILabel alloc]initWithFrame:CGRectMake((kScreenW-140)/2.0, 92, 140, 22)];
        self.labels.font = [UIFont systemFontOfSize:14.0f];
        self.labels.text = @"家厂商对此订单感兴趣";
        [self addSubview:self.labels];
        
        self.statusImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-75, 15, 65, 65)];
        self.statusImage.image = [UIImage imageNamed:@"章.jpg"];
        [self addSubview:self.statusImage];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 87, [UIScreen mainScreen].bounds.size.width-20, 1)];
        lineLabel.backgroundColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:0.3];
        [self addSubview:lineLabel];
        
        
        self.orderDetailsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.orderDetailsBtn.frame = CGRectMake(kScreenW-70, 92, 60, 22);
        [self.orderDetailsBtn setTitle:@"订单详情" forState:UIControlStateNormal];
        self.orderDetailsBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        self.orderDetailsBtn.layer.masksToBounds = YES;
        self.orderDetailsBtn.layer.cornerRadius = 3;
        self.orderDetailsBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:106/255.0 blue:106/255.0 alpha:1.0];
        [self addSubview:self.orderDetailsBtn];
        
        UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, [UIScreen mainScreen].bounds.size.width, 10)];
        backgroundView.backgroundColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:0.3];
        [self addSubview:backgroundView];
        
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
