//
//  OrderListTableViewCell.h
//  111111
//
//  Created by 宇宙之神 on 15/7/19.
//  Copyright (c) 2015年 宇宙之神. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *timeLabel,  *orderTypeLabel, *workingTimeLabel,  *amountLabel,  *interestCountLabel,  *labels;
@property (nonatomic,strong) UIImageView *orderImage,  *statusImage;
@property (nonatomic,strong) UIView *intersestLabelView;
@property (nonatomic,strong) UIButton  *orderDetailsBtn;
@end
