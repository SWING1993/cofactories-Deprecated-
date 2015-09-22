//
//  userInformationCell.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/22.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "userInformationCell.h"

@implementation userInformationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        self.userImageView.layer.cornerRadius = 8;
        self.userImageView.clipsToBounds = YES;
        self.userImageView.backgroundColor = [UIColor yellowColor];
        
        [self addSubview:self.userImageView];
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userImageView.frame) + 10, 10, kScreenW - 30 - CGRectGetWidth(self.userImageView.frame), 30)];
        self.userNameLabel.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.userNameLabel];
        
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
