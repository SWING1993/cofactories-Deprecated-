//
//  PurchasePublicHistoryModel.h
//  cofactory-1.1
//
//  Created by gt on 15/9/19.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PurchasePublicHistoryModel : NSObject
@property (nonatomic,copy)NSString  *name,  *comment, *unit,  *type;
@property (nonatomic,assign)NSInteger amount;
@property (nonatomic,strong)NSArray *photoArray;
- (instancetype)initModelWith:(NSDictionary *)dictionary;
+(instancetype)getModelWith:(NSDictionary *)dictionary;
@end
