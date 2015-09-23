//
//  SupplyHistory.h
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/21.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupplyHistory : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSArray *photoArray;
@property (nonatomic, copy) NSString *oid;

- (instancetype)initModelWith:(NSDictionary *)dictionary;
+(instancetype)getModelWith:(NSDictionary *)dictionary;


@end
