//
//  OrderListViewController.h
//  111111
//
//  Created by 宇宙之神 on 15/7/19.
//  Copyright (c) 2015年 宇宙之神. All rights reserved.
//

typedef enum : NSUInteger {
    GarmentFactoryOrder,
    HistoryOrder,
    ProcessingFactoryOrder
} MyOrderEnum;

#import <UIKit/UIKit.h>

@interface OrderListViewController : UIViewController
@property (nonatomic,assign)int userType;

@property (nonatomic, assign) MyOrderEnum myOrderEnum ;



@end
