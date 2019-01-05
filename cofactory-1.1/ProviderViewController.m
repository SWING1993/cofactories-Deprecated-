//
//  ProviderViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/10/8.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "ProviderViewController.h"
#import "SearchSupplyFactoryViewController.h"
#import "PurchaseHistoryPublicVC.h"
#import "ShopViewController.h"

@interface ProviderViewController ()

@end

@implementation ProviderViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x28303b"]] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"供应管理";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"历史发布" style:UIBarButtonItemStylePlain target:self action:@selector(historyPublishButton)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

    NSArray *buttonBGImageArray = @[@"我的店铺" ,@"面辅料_查看求购",];
    for (int i=0 ; i<2; i++) {
        DLog(@"%d--%d",i/2,i%2);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((kScreenW-120)/3+(i%2)*(60+(kScreenW-120)/3), (kScreenH - 64)/2 - 85, 60, 85);
        [button setBackgroundImage:[UIImage imageNamed:buttonBGImageArray[i]] forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        button.tag = i+1;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)buttonClick:(id)sender{
    
    UIButton *button = (UIButton*)sender;
    DLog(@"button.tag = %ld",(long)button.tag)
    
    if (button.tag == 2) {
        DLog(@"查看求购！");
        PurchaseHistoryPublicVC *VC = [[PurchaseHistoryPublicVC alloc]init];
        VC.isMe = YES;
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
        backItem.title=@"返回";
        self.navigationItem.backBarButtonItem = backItem;
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        ShopViewController *shopVC = [[ShopViewController alloc] init];
        [self.navigationController pushViewController:shopVC animated:YES];
    }
}
- (void)historyPublishButton {
    
    SearchSupplyFactoryViewController *searchSupplyFactoryVC = [[SearchSupplyFactoryViewController alloc] init];
    searchSupplyFactoryVC.isMe = NO;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:searchSupplyFactoryVC animated:YES];
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
