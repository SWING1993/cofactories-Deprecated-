//
//  BidManagerTableViewCell.h
//  cofactory-1.1
//
//  Created by gt on 15/9/7.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BidManagerTableViewCell : UITableViewCell
- (void)getDataWithBidManagerModel:(BidManagerModel *)model indexPath:(NSIndexPath *)indexPath;
@property (nonatomic,strong) UIButton *imageButton;

@end
