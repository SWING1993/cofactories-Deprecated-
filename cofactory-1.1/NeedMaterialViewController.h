//
//  NeedMaterialViewController.h
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/24.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LookOverNeedModel;

@interface NeedMaterialViewController : UIViewController
@property (nonatomic, strong) LookOverNeedModel *detail;
@property (nonatomic, strong) NSString *oid;
@property (nonatomic, strong) NSArray *photoArray;
@property (nonatomic, strong) NSString *amount;

@property (nonatomic, assign) BOOL isCompletion;//订单是否完成
@property (nonatomic, assign) NSString *needName;//订单的名字

@end
