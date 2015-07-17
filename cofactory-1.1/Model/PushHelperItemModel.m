//
//  PushHelperItemModel.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/11.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "PushHelperItemModel.h"

@implementation PushHelperItemModel

- (instancetype)initWithType:(int)factoryType andDistance:(NSString *)distance andSize:(NSString *)factorySize andBusinessType:(NSString *)businessType {
    self = [super init];
    if (self) {
        self.factoryType = factoryType;
        NSDictionary *distanceDetailArray = @{@"10公里以内": @10000, @"50公里以内": @50000, @"100公里以内": @100000, @"150公里以内": @150000, @"不限距离": @1000000};
        NSDictionary *sizeDetailArray = @{@"500件以内": @500, @"500件-1000件": @1000, @"1000件-2000件": @2000, @"2000件到5000件": @5000, @"5000件以上": @10000, @"2人": @2, @"2人-4人": @4, @"4人以上": @100};
        self.distance = [distanceDetailArray objectForKey:distance];
        self.factorySize = [sizeDetailArray objectForKey:factorySize];
        self.businessType = businessType;
    }
    return self;
}

- (instancetype)initWithType:(int)factoryType andDistanceNum:(NSNumber *)distance andSize:(NSNumber *)factorySize andBusinessType:(NSString *)businessType {
    self = [super init];
    if (self) {
        self.factoryType = factoryType;
        self.distance = distance;
        self.factorySize = factorySize;
        self.businessType = businessType;
    }
    return self;
}
@end
