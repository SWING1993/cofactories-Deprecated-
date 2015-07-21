//
//  MessageModel.h
//  聚工厂
//
//  Created by 唐佳诚 on 15/7/8.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic, strong) NSString *time1;

@property (nonatomic, strong) NSString *time2;


@property (nonatomic, copy) NSString *message;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
