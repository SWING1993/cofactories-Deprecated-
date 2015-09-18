//
//  CommentCell.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/18.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "CommentCell.h"
#import "CommentModel.h"
@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, (kScreenW - 40) / 2, 30)];
        self.authorLabel.font = [UIFont systemFontOfSize:13];
        self.authorLabel.textColor = [UIColor grayColor];
        [self addSubview:self.authorLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.authorLabel.frame), 10, (kScreenW - 40) / 2, 30)];
        self.timeLabel.font = [UIFont systemFontOfSize:13];
        self.timeLabel.textColor = [UIColor grayColor];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.timeLabel];
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.authorLabel.frame), kScreenW - 40, 50)];
        self.contentLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.contentLabel];
        
    }
    return self;
}


- (void)setComment:(CommentModel *)comment {
    if (_comment != comment) {
        _comment = comment;
    }
    self.authorLabel.text = comment.authour;
    
    self.timeLabel.text = [Tools getUTCFormateDate:comment.time];
    CGSize size = CGSizeMake(kScreenW - 20, 0);
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGRect rect = [comment.comment boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect frame = self.contentLabel.frame;
    frame.size.height = rect.size.height;
    self.contentLabel.frame = frame;
    self.contentLabel.text = comment.comment;

}


+ (CGFloat)heightOfCell:(CommentModel *)comment {
    CGSize size = CGSizeMake(kScreenW - 20, 0);
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGRect rect = [comment.comment boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGFloat height = rect.size.height + 50;
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
