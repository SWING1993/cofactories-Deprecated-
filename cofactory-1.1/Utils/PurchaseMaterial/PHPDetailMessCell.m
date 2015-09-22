

//
//  PHPDetailMessCell.m
//  cofactory-1.1
//
//  Created by gt on 15/9/22.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "PHPDetailMessCell.h"

@implementation PHPDetailMessCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLabel = [[UILabel alloc]init];
        [self addSubview:_titleLabel];
      
        _messageLabel = [[UILabel alloc]init];
        [self addSubview:_messageLabel];
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
