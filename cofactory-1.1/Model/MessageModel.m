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
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-DD HH:mm:ss";// 年月日
        _time = [dateFormatter stringFromDate:date];
    }
    return self;
}

@end
