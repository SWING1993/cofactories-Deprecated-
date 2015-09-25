//
//  MaterialBidViewController.h
//  cofactory-1.1
//
//  Created by gt on 15/9/24.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class MaterialBidManagerModel;
@class PurchasePublicHistoryModel;

@interface MaterialBidViewController : UIViewController
//@property (nonatomic,strong)MaterialBidManagerModel *model;
@property (nonatomic,strong)PurchasePublicHistoryModel *orderModel;

@property (nonatomic,strong)NSArray *dataArray;;

@end
