//
//  MaterialInfoCell.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/19.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "MaterialInfoCell.h"
#import "InformationModel.h"
@implementation MaterialInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameLabel];
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 10, 10, kScreenW - 30 - CGRectGetWidth(self.nameLabel.frame), 20)];
        self.infoLabel.font = [UIFont systemFontOfSize:15];
        self.infoLabel.numberOfLines = 0;
        [self addSubview:self.infoLabel];
        
    }
    return self;
}


- (void)setInfo:(InformationModel *)info {
    if (_info != info) {
        _info = info;
    }
    CGSize size = CGSizeMake(kScreenW - 30 - 80, 0);
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGRect rect = [info.title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect frame = self.infoLabel.frame;
    frame.size.height = rect.size.height;
    self.infoLabel.frame = frame;
    
    self.infoLabel.text = info.title;
    
}

+ (CGFloat)heightOfCell:(NSString *)title {
    CGSize size = CGSizeMake(kScreenW - 30 - 80, 0);
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGRect rect = [title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGFloat height = rect.size.height + 20;
    return height;
    
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
