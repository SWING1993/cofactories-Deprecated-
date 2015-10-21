//
//  FacTableViewCell.m
//  cofactory-1.1
//
//  Created by GTF on 15/10/21.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "FacTableViewCell.h"

@implementation FacTableViewCell{
    UIImageView *_facImageView;
    UILabel     *_facName;
    UILabel     *_facAddress;
    UILabel     *_facCertify;
    UILabel     *_facFree;
    UILabel     *_facType;
    UILabel     *_facTag;
    UILabel     *_facCity;

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _facImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
        _facImageView.layer.masksToBounds = YES;
        _facImageView.layer.cornerRadius = 3;
        [self addSubview:_facImageView];
        
        for (int i = 0; i<4; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(80, i*20, 160, 20);
            label.font = kSmallFont;
            [self addSubview:label];
            switch (i) {
                case 0:
                    _facName = label;
                    break;
                case 1:
                    _facAddress = label;
                    _facAddress.textColor = [UIColor grayColor];
                    break;
                case 2:
                    _facCertify = label;
                    _facCertify.textColor = [UIColor whiteColor];
                    _facCertify.text = @"认证用户";
                    _facCertify.textAlignment = 1;
                    _facCertify.backgroundColor = [UIColor colorWithRed:52/255.0 green:99/255.0 blue:211/255.0 alpha:1.0];
                    break;
                case 3:
                    _facFree = label;
                    break;

                default:
                    break;
            }
        }
        
        for (int i = 0; i<3; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(kScreenW-65, i*20, 60, 20);
            label.textAlignment = 2;
            label.font = kSmallFont;
            [self addSubview:label];
            switch (i) {
                case 0:
                    _facType = label;
                    _facType.textColor = [UIColor grayColor];
                    break;
                case 1:
                    _facTag = label;
                    _facTag.textColor = [UIColor colorWithHexString:@"0x3bbd79"];
                    break;
                case 2:
                    _facCity = label;
                    _facCity.textColor = [UIColor colorWithRed:52/255.0 green:99/255.0 blue:211/255.0 alpha:1.0];
                    break;
                default:
                    break;
            }
         }
    }
    return self;
}

- (void)getFactoryDataWithModel:(FactoryModel *)model{
    DLog(@"factoryType==%d",model.factoryType);
    
    NSString* imageUrlString = [NSString stringWithFormat:@"%@/factory/%d.png",PhotoAPI,model.uid];
    [_facImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"placeholder88"]];
    
    _facName.text = model.factoryName;
    _facAddress.text = model.factoryAddress;
    if (model.verifyStatus == 0) {
        _facCertify.hidden = YES;
    }else{
        _facCertify.hidden = NO;
        _facCertify.frame = CGRectMake(80, 40, 60, 20);
        _facCertify.layer.masksToBounds = YES;
        _facCertify.layer.cornerRadius = 3;
    }
    if (model.factoryType == 1){
        NSString *dateString = model.factoryFreeTime;
        NSArray *array = [dateString componentsSeparatedByString:@"T"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyy-MM-dd"];
        NSDate *dateForCell = [formatter dateFromString:array[0]];
        NSString *dateStrings = [Tools compareIfTodayAfterDates:dateForCell];
        NSArray *array1 = [dateStrings componentsSeparatedByString:@"天"];
        int date = [array1[0] intValue];
        if (date <= 0)
        {
            _facFree.text = @"空闲";
        }
        if (date > 0)
        {
            _facFree.text = [NSString stringWithFormat:@"%d天后有空",date];
        }
        _facType.text = @"加工厂";
  
    }else if (model.factoryType == 2 ){
        _facFree.text = model.factoryFreeStatus;
        _facType.text = @"代裁厂";
    }else if ( model.factoryType == 3){
        _facFree.text = model.factoryFreeStatus;
        _facType.text = @"锁眼钉扣厂";
    }else if ( model.factoryType == 0){
        _facFree.text = @"";
        _facType.text = @"服装厂";
    }else if ( model.factoryType == 5){
        _facFree.text = @"";
        _facType.text = @"面辅料商";
    }
    if ([model.tag isEqualToString:@"0"]||[model.tag isEqualToString:@"(null)"]) {
        _facTag.hidden = YES;
        
    }else{
        _facTag.hidden = NO;
        _facTag.text = model.tag;
        
    }
    
    _facCity.frame = CGRectMake(kScreenW-65, 60, 60, 20);
    _facCity.text = model.city;


}
@end
