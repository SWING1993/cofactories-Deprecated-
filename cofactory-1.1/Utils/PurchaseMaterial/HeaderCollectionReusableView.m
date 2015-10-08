//
//  HeaderCollectionReusableView.m
//  cofactory-1.1
//
//  Created by GTF on 15/10/8.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@implementation HeaderCollectionReusableView{
    UIImageView *_bgImageView;
    UILabel     *_facName;
    UILabel     *_facAddress;

}

- (void)getDataWithFactoryModel:(FactoryModel *)model{
    
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH/2.0-40-30)];
    _bgImageView.image = [UIImage imageNamed:@"布bg.png"];
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    
    _userHeader = [[UIButton alloc] initWithFrame:CGRectMake(10, _bgImageView.bounds.size.height-15-60, 60, 60)];
    _userHeader.layer.masksToBounds = YES;
    _userHeader.layer.cornerRadius = 30;
    [_userHeader sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%d.png",PhotoAPI,model.uid]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"消息头像"]];
    [_bgImageView addSubview:_userHeader];
    
    _facName = [[UILabel alloc] initWithFrame:CGRectMake(90,  _bgImageView.bounds.size.height-20-60, kScreenW-100, 40)];
    _facName.font = kLargeFont;
    _facName.text = model.factoryName;
    [_bgImageView addSubview:_facName];
    
    _facAddress = [[UILabel alloc] initWithFrame:CGRectMake(90,  _bgImageView.bounds.size.height-20-30, kScreenW-100, 30)];
    _facAddress.font = kFont;
    _facAddress.textColor = [UIColor grayColor];
    _facAddress.text = model.factoryAddress;
    [_bgImageView addSubview:_facAddress];

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, kScreenH/2.0-40-30, 100, 40)];
    label.font = kFont;
    label.text = @"产品信息";
    [self addSubview:label];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenH/2.0-30, kScreenW, 0.8)];
    line.backgroundColor = [UIColor grayColor];
    [self addSubview:line];
}

@end
