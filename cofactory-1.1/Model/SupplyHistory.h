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
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *oid, *factoryUid;
@property (nonatomic, strong) NSString *width;
@property (nonatomic, strong) NSString *usage;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSMutableArray *photoArray;

- (instancetype)initModelWith:(NSDictionary *)dictionary;
+(instancetype)getModelWith:(NSDictionary *)dictionary;


@end
