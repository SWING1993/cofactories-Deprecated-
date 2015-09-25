//
//  MaterialBidFactory.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/24.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "MaterialBidFactory.h"

@implementation MaterialBidFactory
- (instancetype)initBidManagerModelWith:(NSDictionary *)dictionary{
    
    if (self = [super init]){
        self.factoryName = dictionary[@"factoryName"];
        self.uid = [dictionary[@"uid"] intValue];
        
    }
    return self;
}
+(instancetype)getBidManagerModelWith:(NSDictionary *)dictionary{
    return [[self alloc]initBidManagerModelWith:dictionary];
}

@end
