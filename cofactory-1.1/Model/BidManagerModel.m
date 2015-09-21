//
//  BidManagerModel.m
//  cofactory-1.1
//
//  Created by gt on 15/9/7.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "BidManagerModel.h"

@implementation BidManagerModel
- (instancetype)initBidManagerModelWith:(NSDictionary *)dictionary{
    
    if (self = [super init]){
        self.factoryName = dictionary[@"factoryName"];
        self.photoArray = dictionary[@"photo"];
        self.uid = [dictionary[@"uid"] intValue];
        
        if (dictionary[@"commit"] == nil || [dictionary[@"commit"] isEqualToString:@"null"]) {
            self.commit = @"厂家未添加投标备注";
        }else{
            self.commit = dictionary[@"commit"];
        }
    }
    return self;
}
+(instancetype)getBidManagerModelWith:(NSDictionary *)dictionary{
    return [[self alloc]initBidManagerModelWith:dictionary];
 }
@end
