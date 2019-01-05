//
//  PHPDetailTableViewCell.m
//  cofactory-1.1
//
//  Created by gt on 15/9/21.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "PHPDetailTableViewCell.h"
#import "LookoverMaterialModel.h"
#import "PurchasePublicHistoryModel.h"
#import "LookoverMaterialModel.h"

@implementation PHPDetailTableViewCell{
    UIImageView *_bgImageView;
    UILabel     *_titleLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        _bgImageView.layer.masksToBounds = YES;
        _bgImageView.layer.cornerRadius = 5;
        NSNumber *uid = (NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:@"selfuid"];
        [_bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%@.png",PhotoAPI,uid]] placeholderImage:[UIImage imageNamed:@"消息头像"]];
        [self addSubview:_bgImageView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 200, 30)];
        NSString *factoryName = (NSString *)[[NSUserDefaults standardUserDefaults] valueForKey:@"factoryName"];
        _titleLabel.text = factoryName;
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [self addSubview:_titleLabel];
        
        _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneButton.frame = CGRectMake(kScreenW-110, 20, 70, 30);
        [_phoneButton setBackgroundImage:[UIImage imageNamed:@"联系厂商"] forState:UIControlStateNormal];
        _phoneButton.layer.masksToBounds = YES;
        _phoneButton.layer.cornerRadius = 5;
        [self addSubview:_phoneButton];
        
    }
    return self;
}

- (void)getDataWithModel:(LookoverMaterialModel *)model isMaterial:(BOOL)isMaterial{
    
    if (isMaterial) {
        [_bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%zi.png",PhotoAPI,model.userID]] placeholderImage:[UIImage imageNamed:@"消息头像"]];
        
        [HttpClient getUserProfileWithUid:model.userID andBlock:^(NSDictionary *responseDictionary) {
            FactoryModel *model = (FactoryModel *)responseDictionary[@"model"];
            _titleLabel.text = model.factoryName;
        }];
    }
}

- (void)getDataWithOtherModel:(NSInteger)uid isMaterial:(BOOL)isMaterial {
    if (isMaterial) {
        [_bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%zi.png",PhotoAPI,uid]] placeholderImage:[UIImage imageNamed:@"消息头像"]];
        
        [HttpClient getUserProfileWithUid:uid andBlock:^(NSDictionary *responseDictionary) {
            FactoryModel *model = (FactoryModel *)responseDictionary[@"model"];
            _titleLabel.text = model.factoryName;
        }];
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
