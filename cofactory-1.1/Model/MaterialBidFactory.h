//
//  MaterialBidFactory.h
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/24.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaterialBidFactory : NSObject
@property (nonatomic, strong) NSString *factoryName;
@property (nonatomic, assign) int uid;
- (instancetype)initBidManagerModelWith:(NSDictionary *)dictionary;
+(instancetype)getBidManagerModelWith:(NSDictionary *)dictionary;
@end
