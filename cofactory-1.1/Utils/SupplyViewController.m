//
//  Purchase ViewController.m
//  cofactory-1.1
//
//  Created by gt on 15/9/18.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "SupplyViewController.h"

#import "AddmaterialViewController.h"
//#import "SearchSupplyFactoryViewController.h"
#import "PurchaseHistoryPublicVC.h"

@interface SupplyViewController ()

@end

@implementation SupplyViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x28303b"]] forBarMetrics:UIBarMetricsDefault];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"供应面辅料";
    self.view.backgroundColor = [UIColor whiteColor];
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"历史发布" style:UIBarButtonItemStyleBordered target:self action:@selector(historyPublishButton)];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"面辅料_标题"]];
    imageView.frame = CGRectMake(100, (kScreenW - 64)/4, kScreenW-200, 50);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
    NSArray *buttonBGImageArray = @[@"面辅料_供应面料",@"面辅料_供应辅料",@"面辅料_供应胚布"];
    for (int i=0 ; i<3; i++) {
        DLog(@"%d--%d",i/2,i%2);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((kScreenW-180)/4+(i%3)*(60+(kScreenW-180)/4), (kScreenH - 64- 85)/2 , 60, 85);

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
    
    DLog(@"发布供应！");
    AddmaterialViewController *VC = [[AddmaterialViewController alloc]init];
    VC.materialType = button.tag;  // 采购面料
    [self.navigationController pushViewController:VC animated:YES];

}

//- (void)historyPublishButton {
//    
//    SearchSupplyFactoryViewController *searchSupplyFactoryVC = [[SearchSupplyFactoryViewController alloc] init];
//    searchSupplyFactoryVC.isMe = NO;
//    [self.navigationController pushViewController:searchSupplyFactoryVC animated:YES];
//    
//}


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
