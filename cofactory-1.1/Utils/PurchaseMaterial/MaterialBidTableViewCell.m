//
//  MaterialBidTableViewCell.m
//  cofactory-1.1
//
//  Created by gt on 15/9/24.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "MaterialBidTableViewCell.h"
#import "MaterialBidManagerModel.h"
@implementation MaterialBidTableViewCell{
    
    UILabel  *_nameLB;
    UILabel  *_priceLB;
    UILabel  *_goodsSourceLB;

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedButton.frame = CGRectMake(10, 25, 20, 20);
        _selectedButton.backgroundColor = [UIColor grayColor];
        _selectedButton.layer.masksToBounds = YES;
        _selectedButton.layer.cornerRadius = 10;
        _selectedButton.layer.borderWidth = 1;
        _selectedButton.layer.borderColor = [UIColor brownColor].CGColor;
        [self addSubview:_selectedButton];

        self.userButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.userButton.frame = CGRectMake(40, 10, 50, 50);
        self.userButton.layer.masksToBounds = YES;
        self.userButton.layer.borderWidth = 1;
        self.userButton.layer.borderColor = [UIColor grayColor].CGColor;
        self.userButton.layer.cornerRadius = 5;
        [self addSubview:self.userButton];
        
        for (int i = 0 ; i<3; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 5+i*20, 100, 20)];
            [self addSubview:label];
            
            switch (i) {
                case 0:
                    label.font = [UIFont systemFontOfSize:14.0f];
                    _nameLB = label;
                    break;
                    
                case 1:
                    label.font = [UIFont systemFontOfSize:12.0f];
                    label.textColor = [UIColor grayColor];
                    _priceLB = label;
                    break;

                case 2:
                    label.font = [UIFont systemFontOfSize:12.0f];
                    label.textColor = [UIColor grayColor];
                    _goodsSourceLB = label;
                    break;

                    
                default:
                    break;
            }
        }
        
        NSArray *array = @[@"备注",@"图片"];
        for (int i = 0; i<2; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(kScreenW-65, 8+i*28, 55, 20);
            [button setTitle:array[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:53/255.0 green:100/255.0 blue:215/255.0 alpha:1.0] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 5;
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor colorWithRed:53/255.0 green:100/255.0 blue:215/255.0 alpha:1.0].CGColor;
            [self addSubview:button];
            
            if (i == 0) {
                _commentButton = button;
            }else{
                _photoButton = button;
            }
        }
    }
    return self;
}

- (void)getDataWithModel:(MaterialBidManagerModel *)model{
    _nameLB.text = model.name;
    if (model.price == -1) {
        _priceLB.text = @"价格:  面议";
    }else{
        _priceLB.text = [NSString stringWithFormat:@"价格:  %zi元",model.price];
    }
    _goodsSourceLB.text = [NSString stringWithFormat:@"货源状态:  %@",model.goodsSource];
    [self.userButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%zi.png",PhotoAPI,model.userID]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"消息头像"]];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
