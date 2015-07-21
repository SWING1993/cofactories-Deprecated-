//
//  HomeItemModel.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/11.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "HomeItemModel.h"

@implementation HomeItemModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.allItemArray = @[@"各类营销活动", @"找服装厂外发加工订单", @"找服装厂外发代裁订单", @"找服装厂外发锁眼钉扣订单", @"找服装厂信息", @"找加工厂信息", @"找代裁厂信息", @"找锁眼钉扣厂信息"];
        self.itemArray = [[NSMutableArray alloc] initWithCapacity:self.allItemArray.count];

        self.colorArray=@[[UIColor colorWithRed:130.0f/255.0f green:206.0f/255.0f blue:231/255.0f alpha:1.0f],
                          [UIColor colorWithRed:139.0f/255.0f green:216.0f/255.0f blue:159/255.0f alpha:1.0f],
                          [UIColor colorWithRed:231.0f/255.0f green:196.0f/255.0f blue:127/255.0f alpha:1.0f],
                          [UIColor colorWithRed:255.0f/255.0f green:166.0f/255.0f blue:127/255.0f alpha:1.0f],
                          [UIColor colorWithRed:251.0f/255.0f green:166.0f/255.0f blue:166/255.0f alpha:1.0f],
                          [UIColor colorWithRed:168.0f/255.0f green:174.0f/255.0f blue:214/255.0f alpha:1.0f],
                          [UIColor colorWithRed:222.0f/255.0f green:226.0f/255.0f blue:201/255.0f alpha:1.0f],
                          [UIColor colorWithRed:223.0f/255.0f green:230.0f/255.0f blue:236 /255.0f alpha:1.0f]];
        //self.colorArray = @[[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];[UIColor lightGrayColor],[UIColor redColor],[UIColor purpleColor],[UIColor orangeColor],[UIColor magentaColor],[UIColor cyanColor];
    }
    return self;
}




@end
