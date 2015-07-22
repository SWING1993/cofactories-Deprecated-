//
//  VeifyEndViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/22.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "VeifyEndViewController.h"

@interface VeifyEndViewController ()

@end

@implementation VeifyEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor=[UIColor whiteColor];

    UIImageView*logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2-45, 100, 90, 90)];
    logoImage.image=[UIImage imageNamed:@"logo"];
    [self.view addSubview:logoImage];

    UILabel*logoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 220, kScreenW, 20)];
    logoLabel.text=@"恭喜您已经成为聚工厂认证用户";
    logoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:logoLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.


}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
