//
//  ShopCollectionViewCell.h
//  cofactory-1.1
//
//  Created by 赵广印 on 15/10/8.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *shopImage;
@property(nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, assign) BOOL isDeleteButtonHide;

@property (nonatomic, strong) UIButton *but;
@end
