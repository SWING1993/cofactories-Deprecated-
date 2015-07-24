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

    if ([sizeString rangeOfString:@"万件"].location !=NSNotFound) {

        NSArray*sizeArray=[sizeString componentsSeparatedByString:@"-"];

        //最小值
        NSString*firstSizeString = [sizeArray firstObject];
        NSArray*firstArray=[firstSizeString componentsSeparatedByString:@"万件"];
        NSString*min=[NSString stringWithFormat:@"%@0000",[firstArray firstObject]];
        NSNumber*sizeMin = [[NSNumber alloc]initWithInteger:[min integerValue]];
        [mutableArray addObject:sizeMin];

        //最大值
        NSString*lastSizeString = [sizeArray lastObject];
        NSArray*lastArray=[lastSizeString componentsSeparatedByString:@"万件"];
        NSString*max=[NSString stringWithFormat:@"%@0000",[lastArray firstObject]];
        NSNumber* sizeMax= [[NSNumber alloc]initWithInteger:[max integerValue]];
        [mutableArray addObject:sizeMax];

    }
    if ([sizeString rangeOfString:@"人"].location !=NSNotFound) {

        NSArray*sizeArray=[sizeString componentsSeparatedByString:@"-"];

        //最小值
        NSString*firstSizeString = [sizeArray firstObject];
        NSArray*firstArray=[firstSizeString componentsSeparatedByString:@"人"];
        NSString*min=[firstArray firstObject];
        NSNumber*sizeMin = [[NSNumber alloc]initWithInteger:[min integerValue]];
        [mutableArray addObject:sizeMin];

        //最大值
        NSString*lastSizeString = [sizeArray lastObject];
        NSArray*lastArray=[lastSizeString componentsSeparatedByString:@"万件"];
        NSString*max=[lastArray firstObject];
        NSNumber* sizeMax= [[NSNumber alloc]initWithInteger:[max integerValue]];
        [mutableArray addObject:sizeMax];
    }

    return mutableArray;
}

+ (NSMutableArray *)WithTime:(NSString *)timeString {
    NSMutableArray*mutableArray=[[NSMutableArray alloc]initWithCapacity:0];
    NSArray*sizeArray=[timeString componentsSeparatedByString:@"T"];
    NSString*yearString = [sizeArray firstObject];
    NSString*dayString = [sizeArray lastObject];
    [mutableArray addObject:yearString];
    [mutableArray addObject:dayString];
    return mutableArray;
}


+ (MBProgressHUD *)createHUD {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:window];

    [window addSubview:hud];
    [hud show:YES];

    return hud;
}

+ (NSString *)SizeWith:(NSString *)sizeString {
    NSString*string;
    if ([sizeString rangeOfString:@"万件以上"].location !=NSNotFound) {
        NSArray*sizeArray=[sizeString componentsSeparatedByString:@"万件以上"];
        int size = [[sizeArray firstObject] intValue];
        NSString*min=[NSString stringWithFormat:@"%d",size/10000];
        string = [NSString stringWithFormat:@"%@万件以上",min];
    }
    else{
        NSArray*sizeArray=[sizeString componentsSeparatedByString:@"万件"];
        NSString*size = [sizeArray firstObject];
        NSArray*sizeArray2=[size componentsSeparatedByString:@"到"];
        int firstSize = [[sizeArray2 firstObject] intValue];
        int lastSize = [[sizeArray2 lastObject] intValue];
        NSString*min=[NSString stringWithFormat:@"%d",firstSize/10000];
        NSString*max=[NSString stringWithFormat:@"%d",lastSize/10000];
        string = [NSString stringWithFormat:@"%@万件-%@万件",min,max];
    }
    return string;
}

@end
