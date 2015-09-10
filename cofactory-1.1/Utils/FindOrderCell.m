//
//  FindOrderCell.m
//  jugongchang
//
//  Created by 赵广印 on 15/9/10.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "FindOrderCell.h"
//屏幕宽高
#define kScreenW [[UIScreen mainScreen] bounds].size.width
#define kScreenH [[UIScreen mainScreen] bounds].size.height


@implementation FindOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.clothingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.clothingButton setImage:[UIImage imageNamed:@"服装厂－订单"] forState:UIControlStateNormal];
        self.clothingButton.frame = CGRectMake(0, 0, 0.45*kScreenW, kScreenW / 3);
        [self addSubview:self.clothingButton];
        
        
        NSArray *btnImageArr = @[@"加工厂－订单", @"代裁厂－订单", @"锁眼钉扣厂－订单"];
        for (int i = 0; i < 3; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(self.clothingButton.frame.size.width + i*(kScreenW - self.clothingButton.frame.size.width) / 3, 0, (kScreenW - self.clothingButton.frame.size.width) / 3, kScreenW / 3);
            [btn setImage:[UIImage imageNamed:btnImageArr[i]] forState:UIControlStateNormal];
            if (i == 0) {
                self.fastenerButton = btn;
            } else if (i == 1) {
                self.machineButton = btn;
            } else if (i == 2){
                self.cutButton = btn;
            }
            [self addSubview:btn];
        }
        
    }
    return self;
}



@end
