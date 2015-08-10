//
//  GetPushModel.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/8/7.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "GetPushModel.h"

@implementation GetPushModel
- (instancetype)getPushModelWith:(NSDictionary *)dictionary{

    if (self == [super init]) {

        self.dictanceArray = dictionary[@"distance"];
        self.factoryTypes = dictionary[@"factoryType"];
        self.serviceRange = dictionary[@"serviceRange"];
        self.sizeArray = dictionary[@"size"];
        self.type = dictionary[@"type"];
    }
    return self;
}

+ (instancetype)getPushModelWith:(NSDictionary *)dictionary{

    return [[self alloc]getPushModelWith:dictionary];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"self.dictanceArray=%@,self.factoryTypes=%@,self.serviceRange=%@,self.sizeArray=%@,self.type=%@",self.dictanceArray,self.factoryTypes,self.serviceRange,self.sizeArray,self.type];
}
@end
