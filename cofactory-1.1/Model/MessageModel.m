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
        NSLog(@"%@",date);

        NSDateFormatter*df1 = [[NSDateFormatter alloc]init];//格式化
        [df1 setDateFormat:@"yyyy-MM-dd"];

        NSDateFormatter*df2 = [[NSDateFormatter alloc]init];//格式化
        [df2 setDateFormat:@"HH:mm:ss"];
        _time1 = [df1 stringFromDate:date];
        _time2 = [df2 stringFromDate:date];

        _message=[dictionary objectForKey:@"message"];
    }
    return self;
}

@end
