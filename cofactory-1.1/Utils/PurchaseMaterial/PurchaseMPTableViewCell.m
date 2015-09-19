//
//  PurchaseMPTableViewCell.m
//  cofactory-1.1
//
//  Created by gt on 15/9/19.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "PurchaseMPTableViewCell.h"

@implementation PurchaseMPTableViewCell{
    
    UILabel      *_nameLabel;
    UILabel      *_amountLabel;
    UILabel      *_commentLabel;
    UILabel      *_typeLabel;
    UIImageView  *_bgImage;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 65, 65)];
        _bgImage.layer.masksToBounds = YES;
        _bgImage.layer.cornerRadius = 5;
        [self addSubview:_bgImage];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.frame = CGRectMake(100, 8, kScreenW-100-45, 25);
        [self addSubview:_nameLabel];
        
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.frame = CGRectMake(kScreenW-45, 10, 40, 25);
        [self addSubview:_typeLabel];
        
        _amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 35, 160, 25)];
        _amountLabel.textColor = [UIColor grayColor];
        _amountLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_amountLabel];
        
        _commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 160, 25)];
        _commentLabel.textColor = [UIColor grayColor];
        _commentLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_commentLabel];
        
    }
    return self;
}

- (void)getDataWithModel:(PurchasePublicHistoryModel *)model{
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    _typeLabel.text = model.type;
    if ([model.type isEqualToString:@"辅料"]) {
        _typeLabel.textColor = [UIColor colorWithRed:70/255.0 green:126/255.0 blue:220/255.0 alpha:1.0];
    }else{
        _typeLabel.textColor = [UIColor colorWithRed:241/255.0 green:145/255.0 blue:73/255.0 alpha:1.0];
    }
    
    _amountLabel.text = [NSString stringWithFormat:@"数量: %ld%@",model.amount,model.unit];
    _commentLabel.text = [NSString stringWithFormat:@"备注: %@",model.comment];
    if (model.photoArray.count > 0 ) {
        NSString *imageOne = model.photoArray[0];
        [_bgImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,imageOne]] placeholderImage:[UIImage imageNamed:@"placeholder88"]];
    }else{
        _bgImage.image = [UIImage imageNamed:@"placeholder88"];
    }
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
