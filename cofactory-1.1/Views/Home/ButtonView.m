//
//  ButtonView.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/11.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "ButtonView.h"
//#import "Config.h"

#define kTopMargin 5
#define kRadius 20


@implementation ButtonView

- (instancetype)initWithFrame:(CGRect)frame withString:(NSString *)btnTitle {
    self = [super initWithFrame:frame];
    if (self) {
        // 背景色
        [self setBackgroundColor:[UIColor whiteColor]];
        
        // 添加按钮


        NSArray*btnImageArr=@[@"home_button1",@"home_button2",@"home_button3",@"home_button4"];
        NSArray*btnTitleArr = @[@"流行资讯",@"找合作商",btnTitle,@"认证服务"];
        
        for (int i =0; i<4; i++) {
            
            UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(
                                                                   (frame.size.width-4*(frame.size.height-20))/5+i*(frame.size.height-20+(frame.size.width-4*(frame.size.height-20))/5),
                                                                   2.5f,
                                                                   frame.size.height-20,
                                                                   frame.size.height-20
                                                                   )
                          ];
            [btn setBackgroundImage:[UIImage imageNamed:btnImageArr[i]] forState:UIControlStateNormal];
            btn.layer.cornerRadius=(frame.size.height-20)/2.0f;
            btn.layer.masksToBounds=YES;
            if (i==0) {
                self.pushHelperButton=btn;
            }
            if (i==1) {
                self.findCooperationButton=btn;
            }
            if (i==2) {
                self.postButton=btn;
            }
            if (i==3) {
                self.authenticationButton=btn;
            }
            [self addSubview:btn];
            
            UILabel*btnTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(
                                                                           (frame.size.width-4*(frame.size.height-10))/5+i*(frame.size.height-10+(frame.size.width-4*(frame.size.height-10))/5),
                                                                           frame.size.height-15,
                                                                           frame.size.height-10,
                                                                           10
                                                                           )
                                   ];


            btnTitleLabel.text=btnTitleArr[i];
            //btnTitleLabel.backgroundColor=[UIColor greenColor];
            btnTitleLabel.textColor=[UIColor blackColor];
            btnTitleLabel.textAlignment=NSTextAlignmentCenter;
            btnTitleLabel.font=[UIFont systemFontOfSize:12];
            [self addSubview:btnTitleLabel];
        }
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
