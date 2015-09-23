//
//  LookoverMaterialModel.m
//  cofactory-1.1
//
//  Created by gt on 15/9/23.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "LookoverMaterialModel.h"

@implementation LookoverMaterialModel
- (instancetype)initModelWith:(NSDictionary *)dictionary{
    
    if (self = [super init]) {
        _descriptions = dictionary[@"description"];
        _name = dictionary[@"name"];
        _phone = dictionary[@"phone"];
        _photoArray = dictionary[@"photo"];
        _type = dictionary[@"type"];
        _userID = [dictionary[@"uid"] integerValue];
        _price = [dictionary[@"price"] integerValue];
        if (dictionary[@"usage"] == nil) {
            _useage = @"数据暂无";
        }else{
            _useage = dictionary[@"usage"];
        }
        if ([_type isEqualToString:@"面料"]) {
            _width = dictionary[@"width"];
        }else{
            
        }
    }
    return self;
}


+(instancetype)getModelWith:(NSDictionary *)dictionary{
    return [[self alloc]initModelWith:dictionary];
}

@end
