//
//  MaterialBidTableViewCell.h
//  cofactory-1.1
//
//  Created by gt on 15/9/24.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MaterialBidManagerModel;
@interface MaterialBidTableViewCell : UITableViewCell
@property (nonatomic,strong)UIButton *userButton,  *commentButton,  *photoButton,  *selectedButton;
- (void)getDataWithModel:(MaterialBidManagerModel *)model;
@end
