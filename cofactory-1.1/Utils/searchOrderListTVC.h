//
//  searchOrderListTVC.h
//  cofactory-1.1
//
//  Created by gt on 15/7/24.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchOrderListTVC : UITableViewCell
@property (nonatomic,strong) UILabel *timeLabel,  *orderTypeLabel, *workingTimeLabel,  *amountLabel,  *interestCountLabel,  *labels;
@property (nonatomic,strong) UIImageView *orderImage,  *statusImage;
@property (nonatomic,strong) UIButton *confirmOrderBtn,  *orderDetailsBtn;
- (void)getDataWithModel:(OrderModel *)model orderListType:(int)orderListType;
@end
