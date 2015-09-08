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
    UIImageView *_bgImageView;
    UIButton *_commitButton;
    NSString *_commitString;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 160, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_nameLabel];
        
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 70, 70)];
        _bgImageView.layer.masksToBounds = YES;
        _bgImageView.layer.cornerRadius = 35;
        [self addSubview:_bgImageView];
        
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitButton.frame = CGRectMake(100, 35, 60, 25);
        _commitButton.layer.masksToBounds = YES;
        _commitButton.layer.cornerRadius = 5;
        _commitButton.layer.borderWidth = 1;
        _commitButton.layer.borderColor = [UIColor colorWithRed:70/255.0 green:126/255.0 blue:220/255.0 alpha:1.0].CGColor;
        [_commitButton setTitleColor:[UIColor colorWithRed:70/255.0 green:126/255.0 blue:220/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_commitButton setTitle:@"投标备注" forState:UIControlStateNormal];
        _commitButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_commitButton addTarget:self action:@selector(showCommitString) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_commitButton];
        
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageButton.frame = CGRectMake(100, 65, 60, 25);
        _imageButton.layer.masksToBounds = YES;
        _imageButton.layer.cornerRadius = 5;
        _imageButton.layer.borderWidth = 1;
        _imageButton.layer.borderColor = [UIColor colorWithRed:70/255.0 green:126/255.0 blue:220/255.0 alpha:1.0].CGColor;
        [_imageButton setTitleColor:[UIColor colorWithRed:70/255.0 green:126/255.0 blue:220/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_imageButton setTitle:@"投标图片" forState:UIControlStateNormal];
        _imageButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_imageButton];
    }
    
    return self;
}

- (void)getDataWithBidManagerModel:(BidManagerModel *)model indexPath:(NSIndexPath *)indexPath{
    _nameLabel.text = model.factoryName;
    _commitString = model.commit;
    [_bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%d.png",PhotoAPI,model.uid]] placeholderImage:[UIImage imageNamed:@"消息头像"]];
}

- (void)showCommitString{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"投标备注" message:_commitString delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    alertView.tag = 12;
    [alertView show];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
