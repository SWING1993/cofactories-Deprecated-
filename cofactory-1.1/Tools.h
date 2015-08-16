//
//  Tools.h
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/13.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Header.h"
#import "MBProgressHUD.h"
#import <Foundation/Foundation.h>

@interface Tools : NSObject

//分割字符串
+ (NSMutableArray *)RangeSizeWith:(NSString *)sizeString;


+ (NSMutableArray *)WithTime:(NSString *)timeString;



+ (MBProgressHUD *)createHUD;


+ (NSString *)SizeWith:(NSString *)sizeString;


/*!
 身份是不是游客

 @return YES=游客  NO=已登录
 */
+ (BOOL)isTourist;



+ (NSString *)compareIfTodayAfterDates:(NSDate *)comps;

/*!
 提示框

 @param tipStr 提示框文本
 */
+ (void)showHudTipStr:(NSString *)tipStr;


@end
