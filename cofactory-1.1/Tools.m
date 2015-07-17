//
//  Tools.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/13.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (NSMutableArray *)RangeSizeWith:(NSString *)sizeString {

    NSMutableArray*mutableArray=[[NSMutableArray alloc]initWithCapacity:0];

    NSArray*sizeArray=[sizeString componentsSeparatedByString:@"-"];

    //最小值
    NSString*firstSizeString = [sizeArray firstObject];
    NSArray*firstArray=[firstSizeString componentsSeparatedByString:@"万件"];
    NSString*sizeMin=[firstArray firstObject];
    [mutableArray addObject:sizeMin];


    //最大值
    NSString*lastSizeString = [sizeArray lastObject];
    NSArray*lastArray=[lastSizeString componentsSeparatedByString:@"万件"];
    NSString*sizeMax=[lastArray firstObject];
    [mutableArray addObject:sizeMax];

    return mutableArray;
}

+ (MBProgressHUD *)createHUD {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:window];

    [window addSubview:hud];
    [hud show:YES];

    return hud;
}

@end
