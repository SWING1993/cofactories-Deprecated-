//
//  PMSectionOneTableViewCell.m
//  cofactory-1.1
//
//  Created by gt on 15/9/15.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "PMSectionOneTableViewCell.h"

@implementation PMSectionOneTableViewCell{
    UILabel *_titleLabel;
    UIImageView *_abbreviateImage;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 200, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:_titleLabel];
        
        _abbreviateImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-60, 5, 50, 50)];
        _abbreviateImage.layer.masksToBounds = YES;
        _abbreviateImage.layer.cornerRadius = 5;
        _abbreviateImage.layer.borderWidth = 1;
        _abbreviateImage.layer.backgroundColor = [UIColor grayColor].CGColor;
        [self addSubview:_abbreviateImage];
        
    }
    return self;
}

- (void)getDataWithDictionary:(NSDictionary *)dictionary{
    _titleLabel.text = dictionary[@"title"];
    _abbreviateImage.image = [UIImage imageNamed:dictionary[@"image"]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
