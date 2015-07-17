//
//  HomeItemModel.h
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/11.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface HomeItemModel : NSObject

@property (nonatomic, strong) NSArray *allItemArray;// 全部项目数组
@property (nonatomic, strong) NSMutableArray *itemArray;// 当前自定义项目数组
@property (nonatomic, strong) NSArray *colorArray;// 颜色数组

@end
