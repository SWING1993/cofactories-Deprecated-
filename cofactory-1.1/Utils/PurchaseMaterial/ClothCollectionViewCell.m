//
//  ClothCollectionViewCell.m
//  cofactory-1.1
//
//  Created by GTF on 15/10/8.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "ClothCollectionViewCell.h"

@implementation ClothCollectionViewCell
- (void)initWithUI
{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (kScreenW-40)/3.0, 120)];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor grayColor].CGColor;
        [self addSubview:view];
        
        self.imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (kScreenW-40)/3.0, 90)];
        [view addSubview:self.imageButton];
        
        self.messageLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, (kScreenW-40)/3.0, 30)];
        self.messageLable.font = [UIFont systemFontOfSize:10];
        self.messageLable.backgroundColor = [UIColor whiteColor];
        self.messageLable.textAlignment = 1;
        [view addSubview:self.messageLable];
        
}

@end
