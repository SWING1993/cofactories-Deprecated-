//
//  LookOverNeedModel.h
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/24.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LookOverNeedModel : NSObject
@property (nonatomic, copy)NSString *name, *phone, *info, *createdAt;
@property (nonatomic, assign)NSInteger oid, uid, amount;
@property (nonatomic, copy) NSArray *photoArray;
- (instancetype)initModelWith:(NSDictionary *)dictionary;
+ (instancetype)getModelWith:(NSDictionary *)dictionary;


@end
