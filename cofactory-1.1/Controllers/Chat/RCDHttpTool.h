//
//  RCDHttpTool.h
//  cofactory-1.1
//
//  Created by 宋国华 on 15/10/10.
//  Copyright © 2015年 聚工科技. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <RongIMLib/RCUserInfo.h>
#import <RongIMLib/RCGroup.h>
//#import "RCDUserInfo.h"

@interface RCDHttpTool : NSObject

+ (void) getTokenWithUserId:(NSString *)UserId Withname:(NSString *)name WithportraitUri:(NSString *)portraitUri andBlock:(void (^)(int code))block;

@end
