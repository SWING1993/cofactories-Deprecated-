//
//  OrderListViewController.h
//  111111
//
//  Created by 宇宙之神 on 15/7/19.
//  Copyright (c) 2015年 宇宙之神. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListViewController : UIViewController
@property (nonatomic,assign)int userType;

@property (nonatomic, assign) NSInteger currentData1Index;
@property (nonatomic, assign) NSInteger currentData2Index;
@property (nonatomic, assign) NSInteger currentData3Index;
@property (nonatomic, assign) NSInteger currentData1SelectedIndex;

@property (nonatomic, assign) BOOL isHistory;

@property (nonatomic, assign) BOOL HiddenJSDropDown;


@end
