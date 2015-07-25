//
//  PushTableViewCell.m
//  cofactory-1.1
//
//  Created by gt on 15/7/23.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "PushTableViewCell.h"
#import "Header.h"
@implementation PushTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake((kScreenW-260)/2.0, 10, 260, 120)];
        view.layer.masksToBounds =YES;
        view.layer.borderWidth = 1;
        view.layer.cornerRadius = 5;
        view.layer.borderColor = [UIColor colorWithRed:55/255.0 green:117/255.0 blue:189/255.0 alpha:1.0].CGColor;
        [self addSubview:view];
        
        for (int i=0 ; i<2; i++)
        {
            UILabel *lineLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 30+i*30, 120, 1)];
            lineLB.backgroundColor = [UIColor colorWithRed:180/255.0 green:112/255.0 blue:117/255.0 alpha:1.0];
            [view addSubview:lineLB];
        }
        
        UILabel *lineLB1 = [[UILabel alloc]initWithFrame:CGRectMake(140, 90, 120, 1)];
        lineLB1.backgroundColor = [UIColor colorWithRed:180/255.0 green:112/255.0 blue:117/255.0 alpha:1.0];
        [view addSubview:lineLB1];
        
        self.typeLB = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 115, 30)];
        self.typeLB.font = [UIFont systemFontOfSize:13];
        [view addSubview:self.typeLB];
        
        self.distenceLB = [[UILabel alloc]initWithFrame:CGRectMake(5, 30, 115, 30)];
        self.distenceLB.font = [UIFont systemFontOfSize:13];
        [view addSubview:self.distenceLB];
       
        self.scaleLB = [[UILabel alloc]initWithFrame:CGRectMake(145, 60, 115, 30)];
        self.scaleLB.font = [UIFont systemFontOfSize:12];
        [view addSubview:self.scaleLB];
        
        self.businessLB = [[UILabel alloc]initWithFrame:CGRectMake(145, 90, 115, 30)];
        self.businessLB.font = [UIFont systemFontOfSize:12];
        [view addSubview:self.businessLB];
        
        self.deletButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deletButton.frame = CGRectMake(260-30, 0, 30, 30);
        [self.deletButton setBackgroundImage:[UIImage imageNamed:@"DeleteButton.png"] forState:UIControlStateNormal];
        [view addSubview:self.deletButton];

        UILabel *lineLB2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
        lineLB2.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.8];
        [self addSubview:lineLB2];
        
        
        
        
        
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
