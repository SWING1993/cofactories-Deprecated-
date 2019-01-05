//
//  MaterialBidManagerModel.m
//  cofactory-1.1
//
//  Created by gt on 15/9/24.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "MaterialBidManagerModel.h"

@implementation MaterialBidManagerModel
- (instancetype)initModelWith:(NSDictionary *)dictionary{
    
    if (self = [super init]) {
        
        _name = dictionary[@"factoryName"];
        _price = [NSString stringWithFormat:@"%@",dictionary[@"price"]];
        _goodsSource = dictionary[@"status"];
        _photoArray = dictionary[@"photo"];
        _userID = [dictionary[@"uid"] integerValue];
        if (dictionary[@"comment"] == nil) {
            _comment = @"未填写";
        }else{
            _comment = dictionary[@"comment"];
        }
    }
    return self;
}

+(instancetype)getModelWith:(NSDictionary *)dictionary{
    return [[self alloc]initModelWith:dictionary];
}
@end
