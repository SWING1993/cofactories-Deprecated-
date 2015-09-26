//
//  ActivityCell.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/9.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "ActivityCell.h"
#define kMargin [[UIScreen mainScreen] bounds].size.width / 375
#define kSpace 30*kMargin

@implementation ActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(kSpace, 10 *kMargin, 70*kMargin, 18 *kMargin)];
        self.photoView.image = [UIImage imageNamed:@"营销活动"];
        [self addSubview:self.photoView];
        
        self.middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpace + CGRectGetMaxX(self.photoView.frame), 10*kMargin, 40*kMargin, 18 *kMargin)];
        self.middleLabel.text = @"热门";
        self.middleLabel.textAlignment = NSTextAlignmentCenter;
        self.middleLabel.font = kFont;
        self.middleLabel.textColor = [UIColor colorWithRed:215/255. green:86/255. blue:69/255. alpha:1];
        
        self.middleLabel.layer.borderWidth = 0.8;
        self.middleLabel.layer.borderColor = [UIColor colorWithRed:215/255. green:86/255. blue:69/255. alpha:1].CGColor;
        self.middleLabel.layer.cornerRadius = 3;
        self.middleLabel.layer.masksToBounds = YES;
        
        
        [self addSubview:self.middleLabel];
        self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.middleLabel.frame) + kSpace, 9*kMargin, 160*kMargin, 20 *kMargin)];
        self.rightLabel.text = @"聚工厂抽奖进行中！";
        self.rightLabel.font = kFont;
        [self addSubview:self.rightLabel];
        
    }
    return self;
}




@end
