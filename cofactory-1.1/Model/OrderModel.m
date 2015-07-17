//
//  OrderModel.m
//  聚工厂
//
//  Created by 唐佳诚 on 15/7/8.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _oid = [[dictionary objectForKey:@"oid"] intValue];
        _uid = [[dictionary objectForKey:@"uid"] intValue];
        _type = [[dictionary objectForKey:@"type"] intValue];
        _accept = NO;// 需要改
        _amount = [[dictionary objectForKey:@"amount"] intValue];
        _serviceRange = [dictionary objectForKey:@"serviceRange"];
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[[dictionary objectForKey:@"createdAt"] intValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-DD";// 年月日
        _createTime = [dateFormatter stringFromDate:date];
    }
    return self;
}

@end
