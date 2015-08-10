//
//  GetPushModel.h
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/8/7.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetPushModel : NSObject

@property (nonatomic,copy)NSArray *dictanceArray,   *sizeArray;
@property (nonatomic,strong)NSNumber *factoryTypes;
@property (nonatomic,copy)NSString * serviceRange,   *type;

- (instancetype)getPushModelWith:(NSDictionary *)dictionary;
+(instancetype)getPushModelWith:(NSDictionary *)dictionary;

@end
