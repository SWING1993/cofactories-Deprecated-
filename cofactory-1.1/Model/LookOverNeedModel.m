//
//  LookOverNeedModel.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/24.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "LookOverNeedModel.h"

@implementation LookOverNeedModel

- (instancetype)initModelWith:(NSDictionary *)dictionary{
    
    if (self = [super init]) {
        _info = dictionary[@"description"];
        _name = dictionary[@"name"];
        _phone = dictionary[@"phone"];
        _photoArray = [NSArray arrayWithArray:dictionary[@"photo"]];
        _uid = [dictionary[@"uid"] integerValue];
        _amount = [dictionary[@"amount"] integerValue];
        _oid = [dictionary[@"id"] integerValue];
        _createdAt = dictionary[@"createdAt"];
    }
    return self;
}


+ (instancetype)getModelWith:(NSDictionary *)dictionary{
    return [[self alloc]initModelWith:dictionary];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@, %@, %@, %ld, %ld, %ld, %@", _photoArray, _info, _name, _phone, (long)_uid, (long)_amount, (long)_oid, _createdAt];
}

@end
