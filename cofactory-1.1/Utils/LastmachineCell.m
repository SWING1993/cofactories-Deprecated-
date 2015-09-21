//
//  LastmachineCell.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/11.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "LastmachineCell.h"

@implementation LastmachineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //NSArray *arr = @[@"加工厂订单外发", @"寻找加工厂订单"];
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*(kScreenW / 2 + 0.3) - 0.3, 0, kScreenW / 2 + 0.3, kScreenW / 3 - 0.09*kScreenW);
            //[btn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
            btn.adjustsImageWhenHighlighted = NO;
            btn.imageView.contentMode= UIViewContentModeScaleAspectFill;
            if (i == 0) {
                self.leftButton = btn;
            } else if (i == 1) {
                self.rightButton = btn;
            }
            [self addSubview:btn];
        }
    }
    
    
    return self;
}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
