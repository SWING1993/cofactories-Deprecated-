//
//  FactoryListTableViewCell.m
//  22222
//
//  Created by gt on 15/7/20.
//  Copyright (c) 2015年 gt. All rights reserved.
//

#import "FactoryListTableViewCell.h"

@implementation FactoryListTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.companyImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 78, 78)];
        [self addSubview:self.companyImage];
        
        self.companyNameLB = [[UILabel alloc]initWithFrame:CGRectMake(82, 0, 140, 20)];
        self.companyNameLB.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.companyNameLB];
        
        self.companyLocationLB = [[UILabel alloc]initWithFrame:CGRectMake(82, 20, 160, 20)];
        self.companyLocationLB.font = [UIFont systemFontOfSize:12];
        self.companyLocationLB.textColor = [UIColor grayColor];
        [self addSubview:self.companyLocationLB];

        self.certifyUserLB = [[UILabel alloc]initWithFrame:CGRectMake(82, 40, 60, 20)];
        self.certifyUserLB.backgroundColor = [UIColor colorWithRed:52/255.0 green:88/255.0 blue:141/255.0 alpha:1.0];
        self.certifyUserLB.font = [UIFont systemFontOfSize:12];
        self.certifyUserLB.textAlignment = 1;
        self.certifyUserLB.textColor = [UIColor whiteColor];
        self.certifyUserLB.text = @"认证用户";
        [self addSubview:self.certifyUserLB];

        self.isBusyLB = [[UILabel alloc]initWithFrame:CGRectMake(82, 60, 140, 20)];
        self.isBusyLB.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.isBusyLB];
        
        self.factoryNatureLB = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-65, 0, 50, 20)];
        self.factoryNatureLB.font = [UIFont systemFontOfSize:12];
        self.factoryNatureLB.textColor = [UIColor grayColor];
        self.factoryNatureLB.textAlignment = 2;
        [self addSubview:self.factoryNatureLB];

        self.isHaveCarLB = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-65, 20, 50, 20)];
        self.isHaveCarLB.font = [UIFont systemFontOfSize:12];
        self.isHaveCarLB.textColor = [UIColor colorWithRed:52/255.0 green:88/255.0 blue:141/255.0 alpha:1.0];
        self.isHaveCarLB.textAlignment = 2;
        self.isHaveCarLB.text = @"自备货车";
        [self addSubview:self.isHaveCarLB];
        
        self.distenceLB = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-95, 60, 80, 20)];
        self.distenceLB.font = [UIFont systemFontOfSize:12];
        self.distenceLB.textAlignment = 2;
        self.distenceLB.textColor = [UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1.0];
        [self addSubview:self.distenceLB];
        
    
        
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
