//
//  PopularMesageTableViewCell.m
//  cofactory-1.1
//
//  Created by gt on 15/9/15.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "PopularMesageTableViewCell.h"
#import "InformationModel.h"
@implementation PopularMesageTableViewCell{
    UILabel *_titleLabel;
    UILabel *_interestLabel;
    UILabel *_commentLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, kScreenW - 150, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_titleLabel];

        _commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-60, 20, 50, 20)];
        _commentLabel.font = [UIFont systemFontOfSize:12.0f];
        _commentLabel.textColor = [UIColor grayColor];
        _commentLabel.textAlignment = 1;
        [self addSubview:_commentLabel];
        
        _interestLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-120, 20, 50, 20)];
        _interestLabel.font = [UIFont systemFontOfSize:12.0f];
        _interestLabel.textColor = [UIColor grayColor];
        _interestLabel.textAlignment = 1;
        [self addSubview:_interestLabel];

    }
    
    return self;
}

- (void)setInformation:(InformationModel *)information {
    if (_information != information) {
        _information = information;
    }
    _titleLabel.text = information.title;
    _commentLabel.text = [NSString stringWithFormat:@"%@评论", information.comment];
    _interestLabel.text = [NSString stringWithFormat:@"%@喜欢", information.interest];
}

- (void)getDataWithDictionary:(NSDictionary *)dictionary{

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
