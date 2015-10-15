//
//  factoryServiceRange.h
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/17.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FactoryRangeModel : NSObject
/*
GarmentFactory,// 服装厂
ProcessingFactory,// 加工厂
CuttingFactory,// 代裁厂
LockButtonFactory,// 锁眼钉扣厂
MechanicalFactory,// 机械修理厂
materialFactory //面辅料商
 */

@property (nonatomic, strong) NSArray *serviceList;

@property (nonatomic, strong) NSArray *allServiceRange;//全部业务类型

@property (nonatomic, strong) NSArray *garmentRange;//服装厂业务类型
@property (nonatomic, strong) NSArray *processingRange;//加工厂业务类型
@property (nonatomic, strong) NSArray *materialRange;//面辅料商业务类型


@property (nonatomic, strong) NSArray *allFactorySize;

@property (nonatomic, strong) NSArray *garmentSize;//服装厂规模
@property (nonatomic, strong) NSArray *processingSize;//加工厂规模
@property (nonatomic, strong) NSArray *cuttingSize;//代裁厂规模
@property (nonatomic, strong) NSArray *lockButtonFactorySize;//代裁厂规模

- (instancetype)init;

@end
