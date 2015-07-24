//
//  FactoryModel.h
//  聚工厂
//
//  Created by 唐佳诚 on 15/7/8.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

typedef enum {
    NotAuthenticated = 1,// 未提交认证资料
    Authenticating,// 正在认证
    Authenticated// 通过认证
} AuthStatus;

@interface FactoryModel : NSObject

@property (nonatomic, assign) int uid;
@property (nonatomic, assign) int oid;
@property (nonatomic, copy) NSString *factoryName;
@property (nonatomic, strong) NSString *factorySize;
@property (nonatomic, copy) NSString *factoryServiceRange;
@property (nonatomic, copy) NSString *factoryAddress;
@property (nonatomic, copy) NSString *factoryDescription;
@property (nonatomic, assign) int factoryFinishedDegree;
@property (nonatomic, copy) NSString *legalPerson;
@property (nonatomic, copy) NSString *idCard;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, assign) AuthStatus authStatus;
@property (nonatomic, assign) FactoryType factoryType;
@property (nonatomic, assign) int distance;
@property (nonatomic, copy) NSString* factoryFreeStatus;
@property (nonatomic, copy) NSString* factoryFreeTime;


@property (nonatomic,assign) int verifyStatus;
@property (nonatomic,assign)int hasTruck;
@property (nonatomic,assign)int otherTwoFactoryStatus;
@property (nonatomic,copy)NSDate *facTypeOneStatus;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
