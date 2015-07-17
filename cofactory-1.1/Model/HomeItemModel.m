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
        self.colorArray = @[
                            [UIColor blueColor],
                            [UIColor lightGrayColor],
                            [UIColor redColor],
                            [UIColor purpleColor],
                            [UIColor orangeColor],
                            [UIColor magentaColor],
                            [UIColor cyanColor],

                            ];
    }
    return self;
}




@end
