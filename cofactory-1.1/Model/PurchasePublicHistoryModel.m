//
//  PurchasePublicHistoryModel.m
//  cofactory-1.1
//
//  Created by gt on 15/9/19.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "PurchasePublicHistoryModel.h"

@implementation PurchasePublicHistoryModel
- (instancetype)initModelWith:(NSDictionary *)dictionary{
    
    if (self = [super init]){
        self.amount = [dictionary[@"amount"] integerValue];
        self.userID = [dictionary[@"id"] integerValue];
        self.factoyUid = [dictionary[@"factoyUid"] integerValue];
        self.photoArray = dictionary[@"photo"];
        self.name = dictionary[@"name"];
        self.comment = dictionary[@"description"];
        self.unit = dictionary[@"unit"];
        self.type = dictionary[@"type"];
        self.creatTime = dictionary[@"createdAt"];
    }
    return self;
}

+(instancetype)getModelWith:(NSDictionary *)dictionary{
    return [[self alloc]initModelWith:dictionary];
}

@end
