//
//  OrderModel.h
//  聚工厂
//
//  Created by 唐佳诚 on 15/7/8.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface OrderModel : NSObject

@property (nonatomic, assign) int oid;
@property (nonatomic, assign) int uid;
@property (nonatomic, assign) FactoryType type;
@property (nonatomic, assign) BOOL accept;// 现在是 BOOL 值，以后要改
@property (nonatomic, assign) int amount;
@property (nonatomic, copy) NSString *workingTime;
@property (nonatomic, copy) NSString *serviceRange;
@property (nonatomic, copy) NSString *createTime;//订单创建时间
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *interest;
@property (nonatomic, copy) NSString *facName;




- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
