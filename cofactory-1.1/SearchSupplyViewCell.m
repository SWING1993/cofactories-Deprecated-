//
//  SearchSupplyViewCell.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/19.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "SearchSupplyViewCell.h"

@implementation SearchSupplyViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        self.photoView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.photoView];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoView.frame) + 10, 10, kScreenW - 30 - self.photoView.frame.size.width, 20)];
        self.infoLabel.backgroundColor = [UIColor greenColor];
        [self addSubview:self.infoLabel];
        
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.infoLabel.frame), CGRectGetMaxY(self.infoLabel.frame),  CGRectGetWidth(self.infoLabel.frame), 20)];
        self.numberLabel.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.numberLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.infoLabel.frame), CGRectGetMaxY(self.numberLabel.frame), CGRectGetWidth(self.infoLabel.frame) / 2, 20)];
        self.timeLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.timeLabel];
        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeLabel.frame), CGRectGetMaxY(self.numberLabel.frame), CGRectGetWidth(self.infoLabel.frame) / 2, 20)];
        
        self.addressLabel.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.addressLabel];
        
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
