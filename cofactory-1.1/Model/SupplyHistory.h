//
//  SupplyHistory.h
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/21.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupplyHistory : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSArray *photoArray;
@property (nonatomic, strong) NSString *oid;

- (instancetype)initModelWith:(NSDictionary *)dictionary;
+(instancetype)getModelWith:(NSDictionary *)dictionary;


@end
