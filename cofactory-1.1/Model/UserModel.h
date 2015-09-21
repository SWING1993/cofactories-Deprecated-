//
//  UserModel.h
//  聚工厂
//
//  Created by 唐佳诚 on 15/7/6.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GarmentFactory,// 服装厂
    ProcessingFactory,// 加工厂
    CuttingFactory,// 代裁厂
    LockButtonFactory,// 锁眼钉扣厂
    MechanicalFactory,// 机械修理厂
    materialFactory //面辅料商

} FactoryType;

// 实际就是工厂模型
@interface UserModel : NSObject

@property (nonatomic, assign) int uid;
@property (nonatomic, assign) FactoryType factoryType;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *id_card;
@property (nonatomic, copy) NSString *factoryName;
@property (nonatomic, strong) NSString *factorySize;
@property (nonatomic, assign) double factoryLon;
@property (nonatomic, assign) double factoryLat;
@property (nonatomic, copy) NSString *factoryFree;
@property (nonatomic, copy) NSString *factoryAddress;
@property (nonatomic, copy) NSString *factoryServiceRange;
@property (nonatomic, copy) NSString *factoryDescription;
@property (nonatomic, copy) NSString *tag;

@property (nonatomic, assign) int factoryFinishedDegree;
@property (nonatomic, assign) int hasTruck;

@property (nonatomic, copy) NSString  *factoryFreeStatus;

@property (nonatomic, copy) NSString  *factoryFreeTime;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithTouristIdentity:(FactoryType)factoryType;

@end
