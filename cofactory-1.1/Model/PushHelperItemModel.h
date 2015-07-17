//
//  PushHelperItemModel.h
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/11.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushHelperItemModel : NSObject


@property (nonatomic, assign) int factoryType;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSNumber *factorySize;
@property (nonatomic, strong) NSString *businessType;

- (instancetype)initWithType:(int)factoryType andDistance:(NSString *)distance andSize:(NSString *)factorySize andBusinessType:(NSString *)businessType;
- (instancetype)initWithType:(int)factoryType andDistanceNum:(NSNumber *)distance andSize:(NSNumber *)factorySize andBusinessType:(NSString *)businessType;



@end
