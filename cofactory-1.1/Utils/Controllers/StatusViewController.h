//
//  StatusViewController.h
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/15.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StatusViewController : UITableViewController

@property (nonatomic, assign) int factoryType;

@property (nonatomic, copy) NSString* factoryFreeStatus;

@property (nonatomic, copy) NSString* factoryFreeTime;

@property (nonatomic, assign) int hasTruck;

@end
