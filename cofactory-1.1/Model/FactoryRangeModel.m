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
        self.serviceList = @[@"服装厂",@"加工厂",@"代裁厂",@"锁眼钉扣厂",@"机械修理厂",@"面辅料商"];
        
        
//        @property (nonatomic, strong) NSArray *garmentRange;//服装厂业务类型
//        @property (nonatomic, strong) NSArray *processingRange;//加工厂业务类型
//        @property (nonatomic, strong) NSArray *materialRange;//面辅料商业务类型
   
        
        self.garmentRange = @[@"童装", @"成人装"];
        self.processingRange = @[@"针织", @"梭织"];
        self.materialRange = @[@"面料", @"辅料"];


//        @property (nonatomic, strong) NSArray *garmentSize;//服装厂规模
//        @property (nonatomic, strong) NSArray *processingSize;//加工厂规模
//        @property (nonatomic, strong) NSArray *cuttingSize;//代裁厂规模
//        @property (nonatomic, strong) NSArray *mechanicalSize;//锁眼钉扣规模
        
        self.garmentSize = @[@"0万件-10万件",@"10万件-40万件", @"40万件-100万件", @"100万件--200万件", @"200万件以上"];
        self.processingSize = @[@"0人-2人",@"2人-10人",  @"10人-20人", @"20人以上"];
        self.cuttingSize = @[@"0人-2人", @"2人-4人", @"4人以上"];
        self.lockButtonFactorySize = @[@"0人-2人", @"2人-4人", @"4人以上"];
        
        self.allServiceRange = @[self.garmentRange,self.processingRange,self.materialRange];
        self.allFactorySize = @[self.garmentSize, self.processingSize, self.cuttingSize, self.lockButtonFactorySize];

    }
    return self;
}


@end
