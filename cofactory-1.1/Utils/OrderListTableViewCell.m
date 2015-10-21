//
//  OrderListTableViewCell.m
//  111111
//
//  Created by 宇宙之神 on 15/7/19.
//  Copyright (c) 2015年 宇宙之神. All rights reserved.
//

#import "OrderListTableViewCell.h"
#import "Header.h"
@implementation OrderListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
       
        UIView *labelBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 15)];
        labelBGView.backgroundColor = [UIColor colorWithRed:255/255.0 green:106/255.0 blue:106/255.0 alpha:1.0];
        labelBGView.userInteractionEnabled = YES;
        [self addSubview:labelBGView];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenW-20, 15)];
        self.timeLabel.font = [UIFont systemFontOfSize:14.0f];
        self.timeLabel.textColor = [UIColor whiteColor];
        [labelBGView addSubview:self.timeLabel];
        
        self.orderImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 60, 60)];
        self.orderImage.contentMode = UIViewContentModeScaleAspectFill;
        self.orderImage.layer.masksToBounds = YES;
        self.orderImage.layer.cornerRadius = 5;
        [self addSubview:self.orderImage];
        
        self.orderTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, kScreenW/2, 20)];
        self.orderTypeLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.orderTypeLabel];
        
        self.amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 40, kScreenW/2, 20)];
        self.amountLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.amountLabel];
        
        self.workingTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 60, kScreenW/2, 20)];
        self.workingTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.workingTimeLabel];
        
        
        
       

        self.statusImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-75, 15, 65, 65)];
        self.statusImage.image = [UIImage imageNamed:@"章.jpg"];
        [self addSubview:self.statusImage];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 87, [UIScreen mainScreen].bounds.size.width-20, 1)];
        lineLabel.backgroundColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:0.3];
        [self addSubview:lineLabel];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.frame = CGRectMake(10, 92, 60, 22);
        [self.deleteButton setTitle:@"删除订单" forState:UIControlStateNormal];
        self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.deleteButton.layer.masksToBounds = YES;
        self.deleteButton.layer.cornerRadius = 3;
        self.deleteButton.backgroundColor = [UIColor colorWithRed:190.0f/255.0f green:190.0f/255.0f blue:190.0f/255.0f alpha:0.3];
        [self addSubview:self.deleteButton];

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
        
        self.interestCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.deleteButton.frame.origin.x+100, 92,30 , 22)];
        self.interestCountLabel.font = [UIFont systemFontOfSize:14.0f];
        self.interestCountLabel.textColor = [UIColor orangeColor];
        self.interestCountLabel.textAlignment = 2;
        [self addSubview:self.interestCountLabel];
        
        self.labels = [[UILabel alloc]initWithFrame:CGRectMake(self.interestCountLabel.frame.origin.x+30, 92, 140, 22)];
        self.labels.font = [UIFont systemFontOfSize:14.0f];
        self.labels.text = @"家厂商已投标";
        [self addSubview:self.labels];
    
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
