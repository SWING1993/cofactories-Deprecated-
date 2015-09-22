//
//  Purchase ViewController.m
//  cofactory-1.1
//
//  Created by gt on 15/9/18.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "PurchaseVC.h"
#import "PurchaseFabricOrAccessoryVC.h"
#import "PurchaseHistoryPublicVC.h"
#import "SearchSupplyFactoryViewController.h"
@interface PurchaseVC ()

@end

@implementation PurchaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"采购及查找";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"历史发布" style:UIBarButtonItemStyleBordered target:self action:@selector(historyPublishButton)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"采购产品.png"]];
    imageView.frame = CGRectMake(100, 90, kScreenW-200, 50);
    [self.view addSubview:imageView];
    
    NSArray *buttonBGImageArray = @[@"采购面料.png",@"采购辅料.png",@"看面辅料.png"];
    for (int i=0 ; i<3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(40+i*((kScreenW-180-80)/2.0+60), 220, 60, 85);
        [button setBackgroundImage:[UIImage imageNamed:buttonBGImageArray[i]] forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        button.tag = i+1;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}

- (void)customBackTitle{
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"返回";
    backItem.tintColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)buttonClick:(id)sender{
    
    UIButton *button = (UIButton*)sender;
    switch (button.tag) {
        case 1:
        {
            PurchaseFabricOrAccessoryVC *VC = [[PurchaseFabricOrAccessoryVC alloc]init];
            VC.materiaType = @"面料";  // 采购面料
            [self customBackTitle];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
        case 2:
        {
            PurchaseFabricOrAccessoryVC *VC = [[PurchaseFabricOrAccessoryVC alloc]init];
            VC.materiaType = @"辅料";  // 采购辅料
            [self customBackTitle];
            [self.navigationController pushViewController:VC animated:YES];
        }
  
            break;
            
        case 3:
        {
            SearchSupplyFactoryViewController *VC = [[SearchSupplyFactoryViewController alloc]init];
            [self customBackTitle];
            VC.isMe = YES;
            [self.navigationController pushViewController:VC animated:YES];
        }

        default:
            break;
    }
}

- (void)historyPublishButton{
    
    PurchaseHistoryPublicVC *VC = [[PurchaseHistoryPublicVC alloc]init];
    [self customBackTitle];
    [self.navigationController pushViewController:VC animated:YES];
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
