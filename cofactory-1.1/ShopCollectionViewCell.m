//
//  ShopCollectionViewCell.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/10/8.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "ShopCollectionViewCell.h"

@implementation ShopCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
        self.shopImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.shopImage];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.shopImage.frame.size.height - 20, self.frame.size.width, 20)];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = kSmallFont;
        self.nameLabel.backgroundColor = [UIColor whiteColor];
        [self.shopImage addSubview:self.nameLabel];
    }
    return self;
}

- (UIButton *)but {
    if (!_but) {
        self.but = [UIButton buttonWithType:UIButtonTypeCustom];
        self.but.frame = CGRectMake(self.frame.size.width - 25, 0, 25, 25);
        [self.but setBackgroundImage:[UIImage imageNamed:@"删除图片"] forState:UIControlStateNormal];
    }
    return _but;
}

- (void)setIsDeleteButtonHide:(BOOL)isDeleteButtonHide {
    _isDeleteButtonHide = isDeleteButtonHide;
    if (!_isDeleteButtonHide) {
        [self addSubview:self.but];
    } else {
        [self.but removeFromSuperview];
    }
    
}

@end
