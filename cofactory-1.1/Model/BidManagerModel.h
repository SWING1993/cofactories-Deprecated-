//
//  BidManagerModel.h
//  cofactory-1.1
//
//  Created by gt on 15/9/7.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BidManagerModel : NSObject
@property (nonatomic,copy)NSString *factoryName;
@property (nonatomic,strong)NSArray *photoArray;
@property (nonatomic,assign)NSInteger uid;
- (instancetype)initBidManagerModelWith:(NSDictionary *)dictionary;
+(instancetype)getBidManagerModelWith:(NSDictionary *)dictionary;
@end
