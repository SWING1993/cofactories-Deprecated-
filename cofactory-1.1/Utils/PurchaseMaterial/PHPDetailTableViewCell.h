//
//  PHPDetailTableViewCell.h
//  cofactory-1.1
//
//  Created by gt on 15/9/21.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LookoverMaterialModel;
@class PurchasePublicHistoryModel;
@interface PHPDetailTableViewCell : UITableViewCell
- (void)getDataWithModel:(LookoverMaterialModel *)model isMaterial:(BOOL)isMaterial;
- (void)getDataWithOtherModel:(NSInteger)uid isMaterial:(BOOL)isMaterial;
@property (nonatomic,strong)UIButton *phoneButton;
@end
