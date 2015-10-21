//
//  OrderDetailViewController.h
//  cofactory-1.1
//
//  Created by GTF on 15/10/15.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailViewController : UIViewController
@property (nonatomic,retain)OrderModel *model;
@property (nonatomic,assign) BOOL isHistory;
@end
