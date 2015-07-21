//
//  factoryServiceRange.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/17.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "FactoryRangeModel.h"

@implementation FactoryRangeModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.serviceList = @[@"服装厂",@"加工厂",@"代裁厂",@"锁眼钉扣厂"];

        self.allServiceRange = @[@[@"童装",@"成人装"],@[@"针织",@"梭织"]];

        self.allFactorySize = @[@[@"10万件-30万件", @"30万件-50万件", @"50万件-100万件", @"100万件-200万件", @"200万件以上"],@[@"2人-4人", @"4人-10人", @"10人-20人", @"20人以上"],@[@"2人-4人", @"4人-10人"],@[@"2人-4人", @"4人-10人"]];
    }
    return self;
}


@end
