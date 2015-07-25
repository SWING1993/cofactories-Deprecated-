//
//  OrderListTableViewCell.h
//  111111
//
//  Created by 宇宙之神 on 15/7/19.
//  Copyright (c) 2015年 宇宙之神. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListTableViewCell : UITableViewCell
/*@property (weak, nonatomic) IBOutlet UILabel *time;
 @property (weak, nonatomic) IBOutlet UIImageView *orderImage;
 @property (weak, nonatomic) IBOutlet UILabel *orderType;
 @property (weak, nonatomic) IBOutlet UILabel *workingTime;
 @property (weak, nonatomic) IBOutlet UILabel *amount;
 @property (weak, nonatomic) IBOutlet UIButton *acceptOrder;
 */
@property (nonatomic,strong) UILabel *timeLabel,  *orderTypeLabel, *workingTimeLabel,  *amountLabel,  *interestCountLabel,  *label;
@property (nonatomic,strong) UIImageView *orderImage;
@property (nonatomic,strong) UIView *intersestLabelView;
@property (nonatomic,strong) UIButton *confirmOrderBtn,  *orderDetailsBtn;
@end
