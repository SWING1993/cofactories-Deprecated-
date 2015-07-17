//
//  CooperationViewController.m
//  聚工厂
//
//  Created by Mr.song on 15/7/10.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "CooperationViewController.h"
#import "Header.h"

#import "Tools.h"

@interface CooperationViewController ()
@end

@implementation CooperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    NSLog(@"git123");
    
    NSMutableArray*arr=    [Tools RangeSizeWith:@"10万件-20万件"];

    NSLog(@"%@-%@",[arr firstObject],[arr lastObject]);
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
