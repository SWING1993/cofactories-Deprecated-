//
//  FindFactoryCell.m
//  jugongchang
//
//  Created by 赵广印 on 15/9/10.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "FindFactoryCell.h"
//屏幕宽高
#define kScreenW [[UIScreen mainScreen] bounds].size.width
#define kScreenH [[UIScreen mainScreen] bounds].size.height


@implementation FindFactoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 服装厂
        self.clothingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.clothingButton.frame = CGRectMake(0, 0, 0.45*kScreenW, 3*kScreenW / 7);
        [self.clothingButton setImage:[UIImage imageNamed:@"服装厂"] forState:UIControlStateNormal];
        self.clothingButton.adjustsImageWhenHighlighted = NO;

        [self addSubview:self.clothingButton];
        
        //锁眼钉扣厂
        self.fastenerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.fastenerButton.frame = CGRectMake(self.clothingButton.frame.size.width, 0, kScreenW - self.clothingButton.frame.size.width, self.clothingButton.frame.size.height / 2);
        [self.fastenerButton setImage:[UIImage imageNamed:@"锁眼钉扣厂"] forState:UIControlStateNormal];
        self.fastenerButton.adjustsImageWhenHighlighted = NO;

        [self addSubview:self.fastenerButton];
        
        //加工厂
        self.machineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.machineButton.frame = CGRectMake(self.fastenerButton.frame.origin.x, self.fastenerButton.frame.size.height, self.fastenerButton.frame.size.width / 2, self.fastenerButton.frame.size.height);
        [self.machineButton setImage:[UIImage imageNamed:@"加工厂"] forState:UIControlStateNormal];
        self.machineButton.adjustsImageWhenHighlighted = NO;
        [self addSubview:self.machineButton];
        
        //代裁厂
        self.cutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cutButton.frame = CGRectMake(CGRectGetMaxX(self.machineButton.frame), self.fastenerButton.frame.size.height, self.fastenerButton.frame.size.width / 2, self.fastenerButton.frame.size.height);
        [self.cutButton setImage:[UIImage imageNamed:@"代裁厂"] forState:UIControlStateNormal];
        self.cutButton.adjustsImageWhenHighlighted = NO;
        [self addSubview:self.cutButton];
        
    }
    return self;
}
@end
