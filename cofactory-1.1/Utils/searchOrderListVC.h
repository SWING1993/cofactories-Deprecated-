//
//  searchOrderListVC.h
//  cofactory-1.1
//
//  Created by gt on 15/7/24.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchOrderListVC : UIViewController
@property (nonatomic,assign)int userType;

@property (nonatomic, assign) NSInteger currentData1Index;
@property (nonatomic, assign) NSInteger currentData2Index;
@property (nonatomic, assign) NSInteger currentData3Index;
@property (nonatomic, assign) NSInteger currentData1SelectedIndex;

/**搜索订单的类别
 *1.找服装厂外发加工订单
 *2.找服装厂外发代裁订单
 *3.找服装厂外发锁眼钉扣订单
 */
@property (nonatomic,assign)int orderListType;

@end
