//
//  MaterialInfoCell.h
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/19.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InformationModel;
@interface MaterialInfoCell : UITableViewCell


@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) InformationModel *info;
+ (CGFloat)heightOfCell:(NSString *)title;

@end
