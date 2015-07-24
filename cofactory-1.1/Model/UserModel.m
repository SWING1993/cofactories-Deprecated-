//
//  UserModel.m
//  聚工厂
//
//  Created by 唐佳诚 on 15/7/6.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _uid = [[dictionary objectForKey:@"uid"] intValue];
        _factoryType = [[dictionary objectForKey:@"factoryType"] intValue];
        _factoryFreeStatus = [dictionary objectForKey:@"factoryFreeStatus"];
        _hasTruck =[[dictionary objectForKey:@"hasTruck"] intValue];
        _phone = [dictionary objectForKey:@"phone"];
        _name = [dictionary objectForKey:@"name"];
        _job = [dictionary objectForKey:@"job"];
        _id_card = [dictionary objectForKey:@"id_card"];
        _factoryName = [dictionary objectForKey:@"factoryName"];
        NSArray *factorySize = [dictionary objectForKey:@"factorySize"];
        if ([factorySize[1] intValue] == 2147483647) {
            // 最大的选项
            switch (_factoryType) {
                case GarmentFactory:
                    _factorySize = [[NSString alloc] initWithFormat:@"%@万件以上", factorySize[0]];
                    break;
                case ProcessingFactory:
                case CuttingFactory:
                case LockButtonFactory:
                    _factorySize = [[NSString alloc] initWithFormat:@"%@人以上", factorySize[0]];
                    break;
                    
                default:
                    break;
            }
        } else {
            // 范围选项
            switch (_factoryType) {
                case GarmentFactory:
                    _factorySize = [[NSString alloc] initWithFormat:@"%@到%@万件", factorySize[0], factorySize[1]];
                    break;
                case ProcessingFactory:
                case CuttingFactory:
                case LockButtonFactory:
                    _factorySize = [[NSString alloc] initWithFormat:@"%@到%@人", factorySize[0], factorySize[1]];
                    
                default:
                    break;
            }
        }
        _factoryLon = [dictionary objectForKey:@"factoryLon"] == nil ? 0 : [[dictionary objectForKey:@"factoryLon"] intValue];
        _factoryLat = [dictionary objectForKey:@"factoryLat"] == nil ? 0 : [[dictionary objectForKey:@"factoryLat"] intValue];
        if ([dictionary objectForKey:@"factoryFree"] == nil) {
            // 没有设置状态或者是服装厂
            _factoryFree = nil;
        } else if ([[dictionary objectForKey:@"factoryFree"] intValue] == 0 || [[dictionary objectForKey:@"factoryFree"] intValue] == 1) {
            // 代裁厂锁眼钉扣厂
            _factoryFree = [[dictionary objectForKey:@"factoryFree"] boolValue] ? @"有空闲" : @"没空";
        } else {
            // 加工厂
            NSDate *date= [[NSDate alloc] initWithTimeIntervalSince1970:[[dictionary objectForKey:@"factoryFree"] intValue]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            _factoryFree = [formatter stringFromDate:date];
        }
        _factoryFreeTime = dictionary[@"factoryFreeTime"];
        _factoryAddress = [dictionary objectForKey:@"factoryAddress"];
        _factoryServiceRange = [dictionary objectForKey:@"factoryServiceRange"];
        _factoryDescription = [dictionary objectForKey:@"factoryDescription"];
        _factoryFinishedDegree = [[dictionary objectForKey:@"factoryFinishedDegree"] intValue];
    }
    return self;
}

- (instancetype)initWithTouristIdentity:(FactoryType)factoryType {
    self = [super init];
    if (self) {
        _uid = factoryType;
        _factoryType = factoryType;
        _phone = nil;
        _name = @"游客";
        _job = nil;
        _id_card = nil;
        _factoryName = nil;
        _factorySize = nil;
        _factoryLon = 0;
        _factoryLat = 0;
        _factoryAddress = nil;
        _factoryServiceRange = nil;
        _factoryDescription = nil;
        _factoryFinishedDegree = 0;
    }
    return self;
}

- (NSString *)description {
    return [[NSString alloc] initWithFormat:@"uid: %d\nfactoryType: %d\nphone: %@\nname: %@\njob: %@\nid_card: %@\nfactoryName: %@\nfactorySize: %@\nfactoryLon: %f\nfactoryLat: %f\nfactoryFree: %@\nfactoryAddress: %@\nfactoryServiceRange: %@\nfactoryDescription: %@\nfactoryFinishedDegree: %d", _uid, _factoryType, _phone, _name, _job, _id_card, _factoryName, _factorySize, _factoryLon, _factoryLat, _factoryFree, _factoryAddress, _factoryServiceRange, _factoryDescription, _factoryFinishedDegree];
}

@end
