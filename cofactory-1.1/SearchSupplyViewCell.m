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
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        self.photoView.layer.cornerRadius = 8;
        self.photoView.clipsToBounds = YES;
        [self addSubview:self.photoView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoView.frame) + 10, 10, kScreenW - 30 - self.photoView.frame.size.width - 50, 20)];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.nameLabel];
        
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame), 10, 50, 20)];
        self.typeLabel.textAlignment = NSTextAlignmentRight;
        self.typeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.typeLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame),  kScreenW - 30 - self.photoView.frame.size.width, 20)];
        self.priceLabel.font = [UIFont systemFontOfSize:13];
        self.priceLabel.textColor = [UIColor grayColor];
        [self addSubview:self.priceLabel];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.priceLabel.frame), CGRectGetWidth(self.priceLabel.frame) , 20)];
        self.infoLabel.font = [UIFont systemFontOfSize:13];
        self.infoLabel.textColor = [UIColor grayColor];
        [self addSubview:self.infoLabel];
        
        
        
    }
    return self;
}

- (void)setHistory:(SupplyHistory *)history {
    if (_history != history) {
        _history = history;
    }
    if ([history.type isEqualToString:@"辅料"]) {
        self.typeLabel.textColor = [UIColor colorWithRed:70/255.0 green:126/255.0 blue:220/255.0 alpha:1.0];
    }else{
        self.typeLabel.textColor = [UIColor colorWithRed:241/255.0 green:145/255.0 blue:73/255.0 alpha:1.0];
    }
    

    [self.photoView sd_setImageWithURL:[NSURL URLWithString:history.photo] placeholderImage:[UIImage imageNamed:@"placeholder88"]];
    self.nameLabel.text = history.name;
    self.priceLabel.text = [NSString stringWithFormat:@"价格：%ld", history.price];
    self.typeLabel.text = history.type;
    self.infoLabel.text = [NSString stringWithFormat:@"备注：%@", history.info];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
