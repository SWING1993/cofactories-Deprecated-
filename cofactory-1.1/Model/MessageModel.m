//
//  MessageModel.m
//  聚工厂
//
//  Created by 唐佳诚 on 15/7/8.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[[dictionary objectForKey:@"time"] intValue]];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        dateFormatter1.dateFormat = @"yyyy-MM-DD";// 年月日
        _time1 = [dateFormatter1 stringFromDate:date];

        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        dateFormatter2.dateFormat = @"HH:mm:ss";// 年月日
        _time2 = [dateFormatter2 stringFromDate:date];

        _message=[dictionary objectForKey:@"message"];
    }
    return self;
}

@end
