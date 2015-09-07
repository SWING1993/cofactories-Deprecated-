//
//  BidManagerTableViewCell.m
//  cofactory-1.1
//
//  Created by gt on 15/9/7.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "BidManagerTableViewCell.h"

@implementation BidManagerTableViewCell{
    UILabel *_nameLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
       _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, 100, 40)];
      [self addSubview:_nameLabel];
    }
    
    return self;
}

- (void)getDataWithBidManagerModel:(BidManagerModel *)model{
    _nameLabel.text = model.factoryName;
}

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
