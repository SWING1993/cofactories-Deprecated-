//
//  PushEditViewController.h
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/15.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushEditViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *listArray;// 上一个视图控制器的 listArray 引用
@property (nonatomic, assign) int itemType;
@property (nonatomic, strong) NSArray *pickList;
@end
