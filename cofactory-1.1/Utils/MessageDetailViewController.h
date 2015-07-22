//
//  MessageDetailViewController.h
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/11.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailViewController : UITableViewController

@property (nonatomic, strong) NSString *messageStr;

@property (nonatomic, strong) NSString *timeString;


@property (nonatomic, strong) UIImageView *avatarView;

@property (nonatomic, strong) UILabel *bubbleLabel;

@end
