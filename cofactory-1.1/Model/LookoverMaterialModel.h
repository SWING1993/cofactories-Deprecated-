//
//  LookoverMaterialModel.h
//  cofactory-1.1
//
//  Created by gt on 15/9/23.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LookoverMaterialModel : NSObject

@property (nonatomic, copy) NSString *descriptions;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSArray *photoArray;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) NSInteger materialID;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, copy) NSString *useage;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *userName;


- (instancetype)initModelWith:(NSDictionary *)dictionary;
+(instancetype)getModelWith:(NSDictionary *)dictionary;


@end
